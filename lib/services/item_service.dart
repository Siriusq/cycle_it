import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  // 用于添加新物品，或者需要全量替换的场景
  Future<int> saveItem(ItemModel item) async {
    return await _db.upsertItem(item);
  }

  // 更新物品信息，不会触碰使用记录
  Future<void> updateItemDetails(ItemModel item) async {
    await _db.transaction(() async {
      // 1. 只更新 Items 表中在编辑页可修改的字段
      await (_db.update(_db.items)
        ..where((tbl) => tbl.id.equals(item.id!))).write(
        ItemsCompanion(
          name: Value(item.name),
          usageComment: Value(item.usageComment),
          emoji: Value(item.emoji),
          iconColorValue: Value(item.iconColor.toARGB32()),
          notifyBeforeNextUse: Value(item.notifyBeforeNextUse),
        ),
      );

      // 2. 更新物品与标签的关联关系（先删后增）
      await (_db.delete(_db.itemTags)
        ..where((it) => it.itemId.equals(item.id!))).go();

      if (item.tags.isNotEmpty) {
        await _db.batch((batch) {
          for (final tag in item.tags) {
            batch.insert(
              _db.itemTags,
              ItemTagsCompanion(
                itemId: Value(item.id!),
                tagId: Value(tag.id),
              ),
            );
          }
        });
      }
    });
    // 这个方法完全不涉及 UsageRecords 表
  }

  // 删除物品
  Future<void> deleteItem(int itemId) async {
    await _db.deleteItem(itemId);
  }

  // --- UsageRecord 相关操作 ---

  // 添加使用记录并重新计算间隔 (事务处理)
  Future<void> addUsageRecordAndRecalculate(
    int itemId,
    DateTime usedAt,
  ) async {
    await _db.addUsageRecordAndRecalculate(itemId, usedAt);
  }

  // 编辑使用记录并重新计算间隔 (事务处理)
  Future<void> editUsageRecordAndRecalculate(
    int recordId,
    int itemId,
    DateTime newUsedAt,
  ) async {
    await _db.editUsageRecordAndRecalculate(
      recordId,
      itemId,
      newUsedAt,
    );
  }

  // 删除使用记录并重新计算间隔 (事务处理)
  Future<void> deleteUsageRecordAndRecalculate(
    int recordId,
    int itemId,
  ) async {
    await _db.deleteUsageRecordAndRecalculate(recordId, itemId);
  }

  // 获取某个物品及其关联的使用记录和标签
  Future<ItemModel?> getItemWithUsageRecords(int itemId) async {
    final itemData =
        await (_db.select(_db.items)
          ..where((tbl) => tbl.id.equals(itemId))).getSingleOrNull();

    if (itemData == null) return null;

    final usageRecords = await _db
        .getUsageRecordsByItemId(itemId: itemId)
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
    //在 Service 层对 usageRecords 进行初始排序
    usageRecords.sort((a, b) => a.usedAt.compareTo(b.usedAt));

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
      emoji: itemData.emoji,
      iconColor: Color(itemData.iconColorValue),
      notifyBeforeNextUse: itemData.notifyBeforeNextUse,
      usageCount: itemData.usageCount,
      firstUsedDate: itemData.firstUsed,
      lastUsedDate: itemData.lastUsedDate,
      avgInterval: itemData.avgInterval,
    );
  }

  // --- Tag 相关操作 ---

  Future<List<TagModel>> getAllTags() async {
    return await _db.getAllTags();
  }

  Future<int> saveTag(TagModel tag) async {
    return await _db.insertTag(
      TagsCompanion.insert(
        name: tag.name,
        colorValue: tag.color.toARGB32(),
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

  // --------------- 仅测试用 ---------------
  // 使用/lib/test/mock_data.dart中的数据初始化数据库数据
  Future<void> initializeData() async {
    // 检查标签表是否为空，如果为空，则插入 mock 数据
    final tagCount = await _db.getTagCount();
    if (tagCount == 0) {
      if (kDebugMode) print('Inserting mock tags...');
      for (final tag in allTagsFromMock) {
        await _db.insertTag(
          TagsCompanion.insert(
            name: tag.name,
            colorValue: tag.color.toARGB32(),
          ),
        );
      }
    }

    // 检查物品表是否为空，如果为空，则插入 mock 数据
    final itemCount = await _db.getItemCount();
    if (itemCount == 0) {
      if (kDebugMode) print('Inserting mock items...');
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
            if (kDebugMode) {
              print(
                'Warning: Tag ${tag.name} not found in DB for item ${item.name}',
              );
            }
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
                emoji: item.emoji,
                iconColorValue: item.iconColor.toARGB32(),
                notifyBeforeNextUse: item.notifyBeforeNextUse,
                firstUsed: item.firstUsedDate,
                usageCount: item.usageCount,
                lastUsedDate: item.lastUsedDate,
                avgInterval: item.avgInterval,
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

          await _db.recalculateAndSaveUsageRecords(item.id!);
          await _db.updateItemStatistics(item.id!);
        }
      }
    }
  }
}
