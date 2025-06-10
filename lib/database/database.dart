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
    id: model.id!,
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

// Helper to convert ItemModel to ItemsCompanion
ItemsCompanion itemModelToCompanion(ItemModel item) {
  return ItemsCompanion(
    // If item.id is null (new item), use Value.absent() to let autoIncrement work.
    // Otherwise, use the provided id for updates.
    id: item.id != null ? Value(item.id!) : const Value.absent(),
    name: Value(item.name),
    usageComment: Value(item.usageComment),
    iconPath: Value(item.iconPath),
    iconColorValue: Value(item.iconColor.value), // Store Color as int
    // Assuming firstUsed is managed elsewhere or can be null.
    // If you need to explicitly set it based on ItemModel's records, do it here.
    // For simplicity, I'm assuming it's null unless you explicitly set it during updates.
    firstUsed:
        const Value.absent(), // Or Value(null) or Value(item.firstUsedDate) if available
    notifyBeforeNextUse: Value(item.notifyBeforeNextUse),
  );
}

@DriftDatabase(tables: [Items, UsageRecords, Tags, ItemTags])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // 数据库版本号，如果表结构改变需要增加

  // 获取标签数量
  Future<int> getTagCount() async {
    final countExpression = countAll(); // 使用全局的 countAll 聚合函数，不带参数
    // selectOnly 用于只选择聚合结果或其他自定义列
    final query = selectOnly(tags)..addColumns([countExpression]);
    // 执行查询，映射结果，然后获取单个结果（即计数）
    final result =
        await query
            .map((row) => row.read(countExpression))
            .getSingle();
    return result ?? 0;
  }

  // 获取物品数量
  Future<int> getItemCount() async {
    final countExpression = countAll(); // 使用全局的 countAll 聚合函数，不带参数
    final query = selectOnly(items)..addColumns([countExpression]);
    final result =
        await query
            .map((row) => row.read(countExpression))
            .getSingle();
    return result ?? 0;
  }

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

  // 更新标签
  Future<bool> updateTag(TagData tagData) {
    return update(tags).replace(tagData);
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
    // Determine if this is an insert or update operation based on item.id
    final isInsert = item.id == null;

    int itemId;

    if (isInsert) {
      // For a new item, just insert. Drift will auto-generate the ID.
      itemId = await into(items).insert(itemModelToCompanion(item));
    } else {
      // For an existing item, perform an update.
      // Use replace instead of insert with onConflict: DoUpdate for clearer intent
      // when you know it's an update and you have the ID.
      // Or, you can stick with DoUpdate if you prefer.
      // Let's use update for clarity if you have the ID.
      await update(items).replace(itemModelToCompanion(item));
      itemId = item.id!; // Use the existing ID for further operations
    }

    // Sync item-tag relationships
    // If `id` was auto-generated, `itemId` now holds the correct new ID.
    // If it was an update, `itemId` holds the correct existing ID.
    await (delete(itemTags)
      ..where((it) => it.itemId.equals(itemId))).go();
    if (item.tags.isNotEmpty) {
      await batch((batch) {
        for (final tag in item.tags) {
          batch.insert(
            itemTags,
            ItemTagsCompanion(
              itemId: Value(itemId),
              tagId: Value(tag.id),
            ),
          );
        }
      });
    }

    // Sync usage records (delete old, insert new)
    // Ensure the UsageRecordsCompanion uses Value.absent() for its own ID
    await (delete(usageRecords)
      ..where((ur) => ur.itemId.equals(itemId))).go();
    if (item.usageRecords.isNotEmpty) {
      await batch((batch) {
        for (final record in item.usageRecords) {
          batch.insert(
            usageRecords,
            UsageRecordsCompanion(
              id: const Value.absent(), // Let Drift auto-generate UsageRecord's ID
              itemId: Value(
                itemId,
              ), // Use the item's ID for the foreign key
              usedAt: Value(record.usedAt),
              intervalSinceLastUse:
                  record.intervalSinceLastUse != null
                      ? Value(record.intervalSinceLastUse!)
                      : const Value.absent(), // Correct for nullable
            ),
          );
        }
      });
    }

    return itemId;
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
