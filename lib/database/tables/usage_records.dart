class UsageRecordModel {
  final int id;
  final DateTime usedAt;

  UsageRecordModel({required this.id, required this.usedAt});
}

List<UsageRecordModel> usageRecordExample = List.generate(
  ureDemo.length,
  (index) => UsageRecordModel(id: ureDemo[index]['id'], usedAt: ureDemo[index]['usedAt']),
);

List ureDemo = [
  {"id": 2, "usedAt": DateTime(2025, 2, 3, 12, 20, 1, 0, 0)},
];
