import 'package:cycle_it/database/tables/item_table.dart';
import 'package:drift/drift.dart';

// 使用记录表
@DataClassName('UsageRecordData')
class UsageRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get itemId =>
      integer().references(
        Items,
        #id,
        onDelete: KeyAction.cascade,
      )(); // 外键，删除 Item 时级联删除
  DateTimeColumn get usedAt => dateTime()();

  IntColumn get intervalSinceLastUse =>
      integer().nullable()(); // 与上次使用的时间间隔（天）
}
