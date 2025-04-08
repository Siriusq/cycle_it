class UsageRecordModel {
  final int id;
  final int itemId;
  final DateTime usedAt;

  UsageRecordModel({
    required this.id,
    required this.itemId,
    required this.usedAt
  });
}