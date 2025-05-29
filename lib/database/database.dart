import 'dart:io';

import 'package:cycle_it/database/tables/item_table.dart';
import 'package:cycle_it/database/tables/item_tag_table.dart';
import 'package:cycle_it/database/tables/tag_table.dart';
import 'package:cycle_it/database/tables/usage_record_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table; // For Color
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../models/usage_record_model.dart';

part 'database.g.dart'; // Drift 会自动生成这个文件

// 将 TagModel 转换为 TagData
TagData tagModelToData(TagModel model) {
  return TagData(
    id: model.id,
    name: model.name,
    colorValue: model.color.value,
  );
}

// 将 TagData 转换为 TagModel
TagModel tagDataToModel(TagData data) {
  return TagModel(
    id: data.id,
    name: data.name,
    color: Color(data.colorValue),
  );
}

// 将 ItemModel 转换为 ItemData
ItemData itemModelToData(ItemModel model) {
  return ItemData(
    id: model.id,
    name: model.name,
    usageComment: model.usageComment,
    iconPath: model.iconPath,
    iconColorValue: model.iconColor.value,
    notifyBeforeNextUse: model.notifyBeforeNextUse,
  );
}

// 将 UsageRecordModel 转换为 UsageRecordData
UsageRecordData usageRecordModelToData(UsageRecordModel model) {
  return UsageRecordData(
    id: model.id,
    itemId: model.itemId,
    usedAt: model.usedAt,
    intervalSinceLastUse: model.intervalSinceLastUse,
  );
}

@DriftDatabase(tables: [Items, UsageRecords, Tags, ItemTags])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // 数据库版本号，如果表结构改变需要增加

  // ---- 查询方法 ----

  // 获取所有标签
  Future<List<TagModel>> getAllTags() async {
    final allTagsData = await select(tags).get();
    return allTagsData.map(tagDataToModel).toList();
  }

  // 插入标签
  Future<int> insertTag(TagsCompanion entry) {
    return into(tags).insert(entry);
  }

  // 根据名称查询标签
  Future<TagModel?> getTagByName(String name) async {
    final result =
        await (select(tags)
          ..where((t) => t.name.equals(name))).getSingleOrNull();
    return result != null ? tagDataToModel(result) : null;
  }

  // 删除标签
  Future<int> deleteTag(int id) {
    return (delete(tags)..where((t) => t.id.equals(id))).go();
  }

  // 获取所有物品（用于主页列表）
  Future<List<ItemModel>> getAllItems() async {
    final allItemsData = await select(items).get();
    final List<ItemModel> result = [];
    for (final itemData in allItemsData) {
      // 加载每个物品的标签和使用记录
      final itemTag =
          await (select(itemTags)
                ..where((it) => it.itemId.equals(itemData.id)))
              .join([
                innerJoin(tags, tags.id.equalsExp(itemTags.tagId)),
              ])
              .map((row) => tagDataToModel(row.readTable(tags)))
              .get();

      final itemUsageRecords = await (select(usageRecords)
            ..where((ur) => ur.itemId.equals(itemData.id))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.usedAt,
                mode: OrderingMode.asc,
              ),
            ]))
          .get()
          .then(
            (list) =>
                list
                    .map(
                      (data) => UsageRecordModel(
                        id: data.id,
                        itemId: data.itemId,
                        usedAt: data.usedAt,
                        intervalSinceLastUse:
                            data.intervalSinceLastUse,
                      ),
                    )
                    .toList(),
          );

      result.add(
        ItemModel(
          id: itemData.id,
          name: itemData.name,
          usageComment: itemData.usageComment,
          iconPath: itemData.iconPath,
          iconColor: Color(itemData.iconColorValue),
          usageRecords: itemUsageRecords,
          tags: itemTag,
          notifyBeforeNextUse: itemData.notifyBeforeNextUse,
        ),
      );
    }
    return result;
  }

  // 插入或更新物品
  Future<int> upsertItem(ItemModel item) async {
    final id = await into(items).insert(
      itemModelToData(item).toCompanion(true),
      onConflict: DoUpdate(
        (_) => itemModelToData(item).toCompanion(true),
      ),
    );

    // 同步物品和标签关系
    await (delete(itemTags)
      ..where((it) => it.itemId.equals(id))).go(); // 先删除旧关系
    if (item.tags.isNotEmpty) {
      await batch((batch) {
        for (final tag in item.tags) {
          batch.insert(
            itemTags,
            ItemTagsCompanion(
              itemId: Value(id),
              tagId: Value(tag.id),
            ),
          );
        }
      });
    }

    // 同步使用记录 (简化处理：删除旧的，插入新的)
    // 实际应用中可能需要更精细的更新逻辑
    await (delete(usageRecords)
      ..where((ur) => ur.itemId.equals(id))).go();
    if (item.usageRecords.isNotEmpty) {
      await batch((batch) {
        for (final record in item.usageRecords) {
          batch.insert(
            usageRecords,
            usageRecordModelToData(record).toCompanion(true),
          );
        }
      });
    }
    return id;
  }

  // 删除物品
  Future<int> deleteItem(int id) {
    return (delete(items)..where((t) => t.id.equals(id))).go();
  }

  // 新增：按分页和排序获取使用记录 (已在 ItemService 中定义，这里是数据库层的方法)
  Future<List<UsageRecordData>> getPaginatedUsageRecordsData({
    required int itemId,
    required int offset,
    required int limit,
    required String sortBy,
    required bool sortAscending,
  }) async {
    OrderingTerm orderingTerm;
    switch (sortBy) {
      case 'usedAt':
        orderingTerm = OrderingTerm(
          expression: usageRecords.usedAt,
          mode: sortAscending ? OrderingMode.asc : OrderingMode.desc,
        );
        break;
      case 'intervalSinceLastUse':
        orderingTerm = OrderingTerm(
          expression: usageRecords.intervalSinceLastUse,
          mode: sortAscending ? OrderingMode.asc : OrderingMode.desc,
        );
        break;
      default: // 默认按 usedAt 排序
        orderingTerm = OrderingTerm(
          expression: usageRecords.usedAt,
          mode: OrderingMode.asc,
        );
    }

    return await (select(usageRecords)
          ..where((tbl) => tbl.itemId.equals(itemId))
          ..orderBy([(tbl) => orderingTerm])
          ..limit(limit, offset: offset))
        .get();
  }

  // 获取某个物品的使用记录总数
  Future<int> getUsageRecordCountByItemId(int itemId) {
    return (select(usageRecords)..where(
      (tbl) => tbl.itemId.equals(itemId),
    )).get().then((list) => list.length);
  }

  // 插入或更新 UsageRecord
  Future<int> upsertUsageRecord(UsageRecordModel record) {
    return into(usageRecords).insert(
      usageRecordModelToData(record).toCompanion(true),
      onConflict: DoUpdate(
        (_) => usageRecordModelToData(record).toCompanion(true),
      ),
    );
  }

  // 删除 UsageRecord
  Future<int> deleteUsageRecordData(int recordId) {
    return (delete(usageRecords)
      ..where((tbl) => tbl.id.equals(recordId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
