import 'package:cycle_it/database/tables/item_table.dart';
import 'package:cycle_it/database/tables/tag_table.dart';
import 'package:drift/drift.dart';

// 定义 Item 和 Tag 之间的多对多关系表
@DataClassName('ItemTagData')
class ItemTags extends Table {
  IntColumn get itemId =>
      integer().references(Items, #id, onDelete: KeyAction.cascade)();

  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {itemId, tagId}; // 复合主键
}
