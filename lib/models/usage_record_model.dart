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

  // 计算间隔的工厂方法
  factory UsageRecordModel.withInterval({
    required int itemId,
    required DateTime usedAt,
    required DateTime? previousUsedAt,
  }) {
    return UsageRecordModel(
      id: 0, // 插入新记录时自动生成
      itemId: itemId,
      usedAt: usedAt,
      intervalSinceLastUse:
          previousUsedAt != null
              ? usedAt.difference(previousUsedAt).inDays
              : null,
    );
  }
}
