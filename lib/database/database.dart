import 'dart:io';

import 'package:cycle_it/database/tables/item_table.dart';
import 'package:cycle_it/database/tables/item_tag_table.dart';
import 'package:cycle_it/database/tables/tag_table.dart';
import 'package:cycle_it/database/tables/usage_record_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Table; // 与颜色插件冲突
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../models/usage_record_model.dart';

part 'database.g.dart'; // 由 Drift 自动生成

// 将 TagModel 转换为 TagData
TagData tagModelToData(TagModel model) {
  return TagData(
    id: model.id,
    name: model.name,
    colorValue: model.color.toARGB32(),
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
    emoji: model.emoji,
    iconColorValue: model.iconColor.toARGB32(),
    notifyBeforeNextUse: model.notifyBeforeNextUse,
    firstUsed: model.firstUsedDate,
    usageCount: model.usageCount,
    lastUsedDate: model.lastUsedDate,
    avgInterval: model.avgInterval,
  );
}

// 将 ItemData 转换为 ItemModel
ItemModel itemDataToModel(ItemData data) {
  return ItemModel(
    id: data.id,
    name: data.name,
    usageComment: data.usageComment,
    emoji: data.emoji,
    iconColor: Color(data.iconColorValue),
    notifyBeforeNextUse: data.notifyBeforeNextUse,
    firstUsedDate: data.firstUsed,
    usageCount: data.usageCount,
    lastUsedDate: data.lastUsedDate,
    avgInterval: data.avgInterval,
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

// 将 ItemModel 转换为 ItemsCompanion
ItemsCompanion itemModelToCompanion(ItemModel item) {
  return ItemsCompanion(
    id: item.id != null ? Value(item.id!) : const Value.absent(),
    name: Value(item.name),
    usageComment: Value(item.usageComment),
    emoji: Value(item.emoji),
    // 将颜色值存储为int
    iconColorValue: Value(item.iconColor.toARGB32()),
    // firstUsed 从 ItemModel 中获取
    firstUsed:
        item.firstUsedDate != null
            ? Value(item.firstUsedDate!)
            : const Value.absent(),
    notifyBeforeNextUse: Value(item.notifyBeforeNextUse),
  );
}

@DriftDatabase(tables: [Items, UsageRecords, Tags, ItemTags])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4; // 数据库版本号，如果表结构改变需要增加

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
    // 1. 直接从 items 表中查询所有数据，因为统计数据已经存在
    final allItemsData = await select(items).get();

    if (allItemsData.isEmpty) return [];

    // 2. 高效地获取所有标签
    final itemIds = allItemsData.map((item) => item.id).toList();
    final tagQuery = select(itemTags).join([
      innerJoin(tags, tags.id.equalsExp(itemTags.tagId)),
    ])..where(itemTags.itemId.isIn(itemIds));

    final tagRows = await tagQuery.get();

    final tagsByItemId = <int, List<TagModel>>{};
    for (final row in tagRows) {
      final tag = tagDataToModel(row.readTable(tags));
      final itemId = row.readTable(itemTags).itemId;
      (tagsByItemId[itemId] ??= []).add(tag);
    }

    // 3. 组装模型，几乎没有计算
    final lightweightItems =
        allItemsData.map((itemData) {
          return itemDataToModel(itemData).copyWith(
            tags: tagsByItemId[itemData.id] ?? [],
            usageRecords: [], // 首页列表不需要完整的记录
          );
        }).toList();

    return lightweightItems;
  }

  // 插入或更新物品
  Future<int> upsertItem(ItemModel item) async {
    // 根据是否有 item.id 判断编辑和添加物品
    final isInsert = item.id == null;

    int itemId;

    if (isInsert) {
      // 插入新物品
      itemId = await into(items).insert(itemModelToCompanion(item));
    } else {
      // 更新已有物品
      await update(items).replace(itemModelToCompanion(item));
      itemId = item.id!;
    }

    // 更新 item-tag 关系
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

    // 更新使用记录，删除旧的，插入新的
    await (delete(usageRecords)
      ..where((ur) => ur.itemId.equals(itemId))).go();
    if (item.usageRecords.isNotEmpty) {
      await batch((batch) {
        for (final record in item.usageRecords) {
          batch.insert(
            usageRecords,
            UsageRecordsCompanion(
              id: const Value.absent(),
              // 使用itemId作为外键
              itemId: Value(itemId),
              usedAt: Value(record.usedAt),
              intervalSinceLastUse:
                  record.intervalSinceLastUse != null
                      ? Value(record.intervalSinceLastUse!)
                      : const Value.absent(),
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

  // 获取使用记录
  Future<List<UsageRecordData>> getUsageRecordsByItemId({
    required int itemId,
  }) async {
    return await (select(usageRecords)
      ..where((tbl) => tbl.itemId.equals(itemId))).get();
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

  // 核心统计更新逻辑，用于计算并更新单个物品的统计数据
  Future<void> updateItemStatistics(int itemId) async {
    // 1. 获取该物品的所有使用记录
    final records =
        await (select(usageRecords)
              ..where((tbl) => tbl.itemId.equals(itemId))
              ..orderBy([(t) => OrderingTerm(expression: t.usedAt)]))
            .get();

    // 2. 计算统计数据
    final int usageCount = records.length;
    DateTime? firstUsed;
    DateTime? lastUsed;
    double avgInterval = 0.0;

    if (records.isNotEmpty) {
      firstUsed = records.first.usedAt;
      lastUsed = records.last.usedAt;
      if (records.length > 1) {
        // 使用 Drift 的聚合函数来计算平均值，更高效
        final avgQuery =
            selectOnly(usageRecords)
              ..addColumns([usageRecords.intervalSinceLastUse.avg()])
              ..where(usageRecords.itemId.equals(itemId));

        avgInterval =
            await avgQuery
                .map(
                  (row) => row.read(
                    usageRecords.intervalSinceLastUse.avg(),
                  ),
                )
                .getSingle() ??
            0.0;
      }
    }

    // 3. 将计算出的统计数据更新回 Items 表
    await (update(items)
      ..where((tbl) => tbl.id.equals(itemId))).write(
      ItemsCompanion(
        usageCount: Value(usageCount),
        firstUsed: Value(firstUsed),
        lastUsedDate: Value(lastUsed),
        avgInterval: Value(avgInterval),
      ),
    );
  }

  // 重新计算某个物品所有使用记录的间隔
  Future<void> recalculateAndSaveUsageRecords(int itemId) async {
    final allRecordsData =
        await (select(usageRecords)
              ..where((ur) => ur.itemId.equals(itemId))
              ..orderBy([(t) => OrderingTerm(expression: t.usedAt)]))
            .get();

    await batch((batch) {
      for (int i = 0; i < allRecordsData.length; i++) {
        int? interval;
        if (i > 0) {
          interval =
              allRecordsData[i].usedAt
                  .difference(allRecordsData[i - 1].usedAt)
                  .inDays;
        }
        batch.update(
          usageRecords,
          UsageRecordsCompanion(
            intervalSinceLastUse: Value(interval),
          ),
          where: (tbl) => tbl.id.equals(allRecordsData[i].id),
        );
      }
    });
  }

  // 添加使用记录并重新计算间隔 (事务处理)
  Future<void> addUsageRecordAndRecalculate(
    int itemId,
    DateTime usedAt,
  ) async {
    await transaction(() async {
      // 插入新记录
      await into(usageRecords).insert(
        UsageRecordsCompanion.insert(itemId: itemId, usedAt: usedAt),
      );

      // 重新计算并保存所有记录的间隔
      await recalculateAndSaveUsageRecords(itemId);

      // 更新物品的统计数据
      await updateItemStatistics(itemId);
    });
  }

  // 编辑使用记录并重新计算间隔 (事务处理)
  Future<void> editUsageRecordAndRecalculate(
    int recordId,
    int itemId,
    DateTime newUsedAt,
  ) async {
    await transaction(() async {
      // 更新指定记录的 usedAt
      await (update(usageRecords)..where(
        (tbl) => tbl.id.equals(recordId),
      )).write(UsageRecordsCompanion(usedAt: Value(newUsedAt)));

      await recalculateAndSaveUsageRecords(itemId);

      // 更新统计数据
      await updateItemStatistics(itemId);
    });
  }

  // 删除使用记录并重新计算间隔 (事务处理)
  Future<void> deleteUsageRecordAndRecalculate(
    int recordId,
    int itemId,
  ) async {
    await transaction(() async {
      await deleteUsageRecordData(recordId); // 调用已有的数据库层删除方法

      await recalculateAndSaveUsageRecords(itemId);

      // 更新统计数据
      await updateItemStatistics(itemId);
    });
  }

  // --------------------数据库导入与导出--------------------
  // 获取数据库文件路径
  Future<String> getDatabaseFilePath() async {
    final dbFolder = await _getDatabaseDirectory();
    return p.join(dbFolder.path, 'db.sqlite');
  }

  // 导出数据库
  Future<bool> exportDatabase() async {
    try {
      final currentDbPath = await getDatabaseFilePath();
      final currentDbFile = File(currentDbPath);

      if (!await currentDbFile.exists()) {
        Get.snackbar(
          'database_export_failed'.tr,
          'database_export_file_error'.tr,
        );
        return false;
      }

      // 使用 file_picker 选择保存目录
      String? selectedDirectory =
          await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // 用户取消了选择
        Get.snackbar(
          'database_export_failed'.tr,
          'database_export_canceled_error'.tr,
        );
        return false;
      }

      final exportPath = p.join(
        selectedDirectory,
        'cycle_it_backup_${DateTime.now().millisecondsSinceEpoch}.sqlite',
      );
      await currentDbFile.copy(exportPath);
      Get.snackbar(
        'database_export_successfully'.tr,
        'database_export_to'.trParams({'filepath': exportPath}),
      );
      return true;
    } catch (e) {
      Get.snackbar('database_export_failed'.tr, '$e');
      return false;
    }
  }

  // 导入数据库，这个方法只负责处理实际的文件替换逻辑，不涉及数据库连接的关闭和重新打开
  Future<bool> importDatabase(File selectedFile) async {
    try {
      final currentDbPath = await getDatabaseFilePath();
      final currentDbFile = File(currentDbPath);
      final walFile = File('$currentDbPath-wal');
      final shmFile = File('$currentDbPath-shm');

      // 删除现有数据库文件及其WAL和SHM文件（如果存在）
      if (await currentDbFile.exists()) {
        await currentDbFile.delete();
      }
      if (await walFile.exists()) {
        await walFile.delete();
      }
      if (await shmFile.exists()) {
        await shmFile.delete();
      }

      // 复制选择的文件到应用程序的数据库路径
      await selectedFile.copy(currentDbPath);

      return true;
    } catch (e) {
      Get.snackbar('database_import_failed'.tr, '$e');
      return false;
    }
  }
}

// 根据平台获取数据库存储目录
Future<Directory> _getDatabaseDirectory() async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    // 在桌面平台上，使用应用支持目录
    return await getApplicationSupportDirectory();
  } else {
    // 在移动平台上，使用应用文档目录（沙盒私有目录）
    return await getApplicationDocumentsDirectory();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await _getDatabaseDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // print(
      //   'Migrating database from $from to $to. Data will be reset.',
      // );
    },
  );
}
