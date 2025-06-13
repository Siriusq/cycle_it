import 'package:drift/drift.dart';

// 物品表
@DataClassName('ItemData')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 255)();

  TextColumn get usageComment => text().nullable()();

  IntColumn get iconCodePoint => integer()(); //存储字体编码
  TextColumn get iconFontFamily =>
      text().withLength(min: 1, max: 255)(); // 存储字体名

  IntColumn get iconColorValue => integer()(); // 存储 Color 的 int 值
  DateTimeColumn get firstUsed => dateTime().nullable()();

  BoolColumn get notifyBeforeNextUse =>
      boolean().withDefault(const Constant(false))();
}
