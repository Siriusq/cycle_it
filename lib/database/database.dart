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
    // usageRecords 和 tags 需要单独加载，这里先给空列表
    usageRecords: [],
    tags: [],
    notifyBeforeNextUse: data.notifyBeforeNextUse,
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
  int get schemaVersion => 3; // 数据库版本号，如果表结构改变需要增加

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
    // 1. 一次性查询所有需要的数据表
    final allItemsData = await select(items).get();
    final allRecordsData =
        await (select(usageRecords)..orderBy([
          (t) => OrderingTerm(expression: t.usedAt),
        ])).get();
    final allTagsData = await select(tags).get();
    final allItemTagsData = await select(itemTags).get();

    // 2. 在内存中构建映射表以便快速查找，避免循环查询
    final recordsByItemId = <int, List<UsageRecordModel>>{};
    for (var record in allRecordsData) {
      final model = UsageRecordModel(
        id: record.id,
        itemId: record.itemId,
        usedAt: record.usedAt,
        intervalSinceLastUse: record.intervalSinceLastUse,
      );
      // 如果键不存在，则创建新列表
      (recordsByItemId[record.itemId] ??= []).add(model);
    }

    final tagsById = {
      for (var tag in allTagsData) tag.id: tagDataToModel(tag),
    };
    final tagsByItemId = <int, List<TagModel>>{};
    for (var itemTag in allItemTagsData) {
      final tag = tagsById[itemTag.tagId];
      if (tag != null) {
        (tagsByItemId[itemTag.itemId] ??= []).add(tag);
      }
    }

    // 3. 组装最终的 ItemModel 列表
    final result =
        allItemsData.map((itemData) {
          final itemRecords = recordsByItemId[itemData.id] ?? [];
          // 注意：这里已经通过查询排序了，但以防万一可以再次排序
          // itemRecords.sort((a, b) => a.usedAt.compareTo(b.usedAt));

          // 使用 copyWith 方法填充关联数据
          return itemDataToModel(itemData).copyWith(
            usageRecords: itemRecords,
            tags: tagsByItemId[itemData.id] ?? [],
          );
        }).toList();

    return result;
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
