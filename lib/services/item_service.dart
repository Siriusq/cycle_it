import 'dart:ui';

import 'package:drift/drift.dart';

import '../data/usage_record_data_source.dart'; // 引入 PaginatedUsageRecordsResult
import '../database/database.dart';
import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../models/usage_record_model.dart';
import '../test/mock_data.dart';

class ItemService {
  final MyDatabase _db;

  ItemService(this._db);

  // --- Item 相关操作 ---
  Future<List<ItemModel>> getAllItems() async {
    return await _db.getAllItems(); // 调用数据库层的方法
  }

  // 插入或更新物品
  Future<int> saveItem(ItemModel item) async {
    return await _db.upsertItem(item);
  }

  // 删除物品
  Future<void> deleteItem(int itemId) async {
    await _db.deleteItem(itemId);
  }

  // --- UsageRecord 相关操作 ---

  // 获取某个物品的使用记录，支持分页和排序
  Future<PaginatedUsageRecordsResult> getPaginatedUsageRecords({
    required int itemId,
    required int offset,
    required int limit,
    required String sortBy,
    required bool sortAscending,
  }) async {
    final recordsData = await _db.getPaginatedUsageRecordsData(
      itemId: itemId,
      offset: offset,
      limit: limit,
      sortBy: sortBy,
      sortAscending: sortAscending,
    );
    final totalCount = await _db.getUsageRecordCountByItemId(itemId);

    final records =
        recordsData
            .map(
              (data) => UsageRecordModel(
                id: data.id,
                itemId: data.itemId,
                usedAt: data.usedAt,
                intervalSinceLastUse: data.intervalSinceLastUse,
              ),
            )
            .toList();

    return PaginatedUsageRecordsResult(
      records: records,
      totalCount: totalCount,
    );
  }

  // 添加使用记录并重新计算间隔 (事务处理)
  Future<void> addUsageRecordAndRecalculate(
    int itemId,
    DateTime usedAt,
  ) async {
    await _db.transaction(() async {
      // 获取当前物品的所有使用记录（已排序）
      final currentRecordsData =
          await (_db.select(_db.usageRecords)
                ..where((ur) => ur.itemId.equals(itemId))
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.usedAt,
                    mode: OrderingMode.asc,
                  ),
                ]))
              .get();

      // 计算新记录的间隔
      int? newInterval;
      if (currentRecordsData.isNotEmpty) {
        final lastRecord = currentRecordsData.last;
        newInterval = usedAt.difference(lastRecord.usedAt).inDays;
      }

      // 插入新记录
      final newRecordId = await _db
          .into(_db.usageRecords)
          .insert(
            UsageRecordsCompanion.insert(
              itemId: itemId,
              usedAt: usedAt,
              intervalSinceLastUse: Value(newInterval),
            ),
          );

      // 如果新记录不是最后一条（虽然正常添加时是最后一条），
      // 但为了通用性，我们重新获取并更新受影响的记录。
      // 更高效的做法是只更新新记录和下一条（如果存在）
      // 这里我们简化为获取所有记录并重新计算所有，因为 GetX 控制器会重新加载 ItemModel，这也会触发 ItemModel 内部的 usageRecords 排序和缓存失效。
      await _recalculateAndSaveUsageRecords(itemId);
    });
  }

  // 编辑使用记录并重新计算间隔 (事务处理)
  Future<void> editUsageRecordAndRecalculate(
    int recordId,
    int itemId,
    DateTime newUsedAt,
  ) async {
    await _db.transaction(() async {
      // 更新指定记录的 usedAt
      await (_db.update(_db.usageRecords)
        ..where((tbl) => tbl.id.equals(recordId))).write(
        UsageRecordsCompanion(
          usedAt: Value(newUsedAt),
          intervalSinceLastUse: const Value(null),
        ), // 先清空，再重新计算
      );

      await _recalculateAndSaveUsageRecords(itemId);
    });
  }

  // 删除使用记录并重新计算间隔 (事务处理)
  Future<void> deleteUsageRecordAndRecalculate(
    int recordId,
    int itemId,
  ) async {
    await _db.transaction(() async {
      await _db.deleteUsageRecordData(recordId); // 调用数据库层的删除方法

      await _recalculateAndSaveUsageRecords(itemId);
    });
  }

  // 辅助方法：重新计算某个物品的所有使用记录的间隔并保存
  Future<void> _recalculateAndSaveUsageRecords(int itemId) async {
    final allRecordsData =
        await (_db.select(_db.usageRecords)
              ..where((ur) => ur.itemId.equals(itemId))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.usedAt,
                  mode: OrderingMode.asc,
                ),
              ]))
            .get();

    await _db.batch((batch) {
      for (int i = 0; i < allRecordsData.length; i++) {
        int? interval;
        if (i > 0) {
          interval =
              allRecordsData[i].usedAt
                  .difference(allRecordsData[i - 1].usedAt)
                  .inDays;
        }
        batch.update(
          _db.usageRecords,
          UsageRecordsCompanion(
            intervalSinceLastUse: Value(interval),
          ),
          where: (tbl) => tbl.id.equals(allRecordsData[i].id),
        );
      }
    });
  }

  // 获取某个物品及其关联的使用记录和标签
  Future<ItemModel?> getItemWithUsageRecords(int itemId) async {
    final itemData =
        await (_db.select(_db.items)
          ..where((tbl) => tbl.id.equals(itemId))).getSingleOrNull();

    if (itemData == null) return null;

    final usageRecords = await _db
        .getPaginatedUsageRecordsData(
          itemId: itemId,
          offset: 0,
          // 获取所有，不分页
          limit: 99999,
          // 设置一个足够大的限制
          sortBy: 'usedAt',
          sortAscending: true,
        )
        .then(
          (list) =>
              list
                  .map(
                    (data) => UsageRecordModel(
                      id: data.id,
                      itemId: data.itemId,
                      usedAt: data.usedAt,
                      intervalSinceLastUse: data.intervalSinceLastUse,
                    ),
                  )
                  .toList(),
        );

    final itemTags =
        await (_db.select(_db.itemTags)
              ..where((it) => it.itemId.equals(itemData.id)))
            .join([
              innerJoin(
                _db.tags,
                _db.tags.id.equalsExp(_db.itemTags.tagId),
              ),
            ])
            .map((row) => tagDataToModel(row.readTable(_db.tags)))
            .get();

    return ItemModel(
      id: itemData.id,
      name: itemData.name,
      usageComment: itemData.usageComment,
      usageRecords: usageRecords,
      tags: itemTags,
      iconPath: itemData.iconPath,
      iconColor: Color(itemData.iconColorValue),
      notifyBeforeNextUse: itemData.notifyBeforeNextUse,
    );
  }

  // 加载某个物品的所有使用记录，并确保按时间排序
  Future<List<UsageRecordModel>> getUsageRecordsByItemId(
    int itemId,
  ) async {
    final List<UsageRecordData> recordsData =
        await (_db.select(_db.usageRecords)
              ..where((tbl) => tbl.itemId.equals(itemId))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.usedAt,
                  mode: OrderingMode.asc,
                ), // 按照 usedAt 升序排列
              ]))
            .get();

    return recordsData.map((data) {
      return UsageRecordModel(
        id: data.id,
        itemId: data.itemId,
        usedAt: data.usedAt,
        intervalSinceLastUse: data.intervalSinceLastUse,
      );
    }).toList();
  }

  // --- Tag 相关操作 ---

  Future<List<TagModel>> getAllTags() async {
    return await _db.getAllTags();
  }

  Future<int> saveTag(TagModel tag) async {
    return await _db.insertTag(
      TagsCompanion.insert(
        name: tag.name,
        colorValue: tag.color.value,
      ),
    );
  }

  Future<TagModel?> getTagByName(String name) async {
    return await _db.getTagByName(name);
  }

  Future<bool> updateTag(TagModel tag) async {
    return await _db.updateTag(tagModelToData(tag));
  }

  Future<void> deleteTag(int tagId) async {
    await _db.deleteTag(tagId);
  }

  // 初始化数据库数据
  Future<void> initializeData() async {
    // 检查标签表是否为空，如果为空，则插入 mock 数据
    final tagCount = await _db.getTagCount(); // 需要在 MyDatabase 中添加此方法
    if (tagCount == 0) {
      print('Inserting mock tags...');
      for (final tag in allTagsFromMock) {
        await _db.insertTag(
          TagsCompanion.insert(
            name: tag.name,
            colorValue: tag.color.value,
          ),
        );
      }
    }

    // 检查物品表是否为空，如果为空，则插入 mock 数据
    final itemCount =
        await _db.getItemCount(); // 需要在 MyDatabase 中添加此方法
    if (itemCount == 0) {
      print('Inserting mock items...');
      for (final item in sampleItems) {
        // 在插入物品前，确保其关联的标签在数据库中存在，并获取它们的真实ID
        final List<TagModel> itemActualTags = [];
        for (final tag in item.tags) {
          final existingTag = await _db.getTagByName(tag.name);
          if (existingTag != null) {
            itemActualTags.add(existingTag);
          } else {
            // 如果 mock item 引用了不存在的标签，这里可以插入它或者抛出错误
            // 这里我们假设 mock tags 已经先被插入
            print(
              'Warning: Tag ${tag.name} not found in DB for item ${item.name}',
            );
          }
        }

        // 插入物品
        final insertedItemId = await _db
            .into(_db.items)
            .insert(
              ItemData(
                id: item.id!,
                // 使用 mock 的 ID
                name: item.name,
                usageComment: item.usageComment,
                iconPath: item.iconPath,
                iconColorValue: item.iconColor.value,
                notifyBeforeNextUse: item.notifyBeforeNextUse,
              ).toCompanion(true), // 使用 toCompanion(true) 允许指定 ID
              mode: InsertMode.insertOrReplace,
            );

        // 插入物品和标签关系
        if (itemActualTags.isNotEmpty) {
          await _db.batch((batch) {
            for (final tag in itemActualTags) {
              batch.insert(
                _db.itemTags,
                ItemTagsCompanion(
                  itemId: Value(insertedItemId),
                  tagId: Value(tag.id),
                ),
              );
            }
          });
        }

        // 插入使用记录
        if (item.usageRecords.isNotEmpty) {
          // 确保使用记录是按照 usedAt 排序的，以便正确计算 intervalSinceLastUse
          item.usageRecords.sort(
            (a, b) => a.usedAt.compareTo(b.usedAt),
          );

          await _db.batch((batch) {
            for (int i = 0; i < item.usageRecords.length; i++) {
              final record = item.usageRecords[i];
              int? interval;
              if (i > 0) {
                interval =
                    record.usedAt
                        .difference(item.usageRecords[i - 1].usedAt)
                        .inDays;
              }
              batch.insert(
                _db.usageRecords,
                UsageRecordsCompanion(
                  id: Value(record.id), // 使用 mock 的 ID
                  itemId: Value(insertedItemId),
                  usedAt: Value(record.usedAt),
                  intervalSinceLastUse: Value(interval),
                ),
                mode: InsertMode.insertOrReplace, // 如果ID冲突则替换
              );
            }
          });
        }
      }
    }
  }
}
