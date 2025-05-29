import 'package:drift/drift.dart';

// 定义 Tags 表
@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name =>
      text().withLength(min: 1, max: 50).unique()(); // 标签名唯一
  IntColumn get colorValue => integer()(); // 存储 Color 的 int 值
}
