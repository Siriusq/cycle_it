import 'package:drift/drift.dart';

// 物品表
@DataClassName('ItemData')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 255)();

  TextColumn get usageComment => text().nullable()();

  TextColumn get emoji =>
      text().withLength(min: 1, max: 10)(); // Emoji 字符串，通常很短

  IntColumn get iconColorValue => integer()(); // 存储 Color 的 int 值

  BoolColumn get notifyBeforeNextUse =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get firstUsed => dateTime().nullable()();

  IntColumn get usageCount =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get lastUsedDate => dateTime().nullable()();

  RealColumn get avgInterval =>
      real().withDefault(const Constant(0.0))();

  // 存储通知的小时 (0-23)
  IntColumn get notificationHour => integer().nullable()();

  // 存储通知的分钟 (0-59)
  IntColumn get notificationMinute => integer().nullable()();
}
