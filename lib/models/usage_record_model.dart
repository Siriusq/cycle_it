class UsageRecordModel {
  final int id;
  final int itemId;
  final DateTime usedAt;
  final int? intervalSinceLastUse; // 与上次使用的间隔天数

  UsageRecordModel({
    required this.id,
    required this.itemId,
    required this.usedAt,
    this.intervalSinceLastUse,
  });
}
