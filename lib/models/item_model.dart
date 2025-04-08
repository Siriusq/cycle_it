import 'package:flutter/material.dart';

import 'usage_record_model.dart';

class ItemModel {
  final int id;
  final String name;
  final String? iconName;
  final Color? iconColor;
  final DateTime firstUsed;
  final List<UsageRecordModel> usageRecords;
  final bool notifyBeforeNextUse;

  ItemModel({
    required this.id,
    required this.name,
    required this.firstUsed,
    required this.usageRecords,
    this.iconName,
    this.iconColor,
    this.notifyBeforeNextUse = true,
  });

  // 计算使用频率
  double get usageFrequency {
    if (usageRecords.isEmpty) return 0;
    final daysSinceFirst = DateTime.now().difference(firstUsed).inDays;
    if (daysSinceFirst == 0) return usageRecords.length.toDouble();
    return daysSinceFirst / usageRecords.length;
  }

  // 预计下次使用时间 = 上次使用时间 + 平均使用间隔
  DateTime? get nextExpectedUse {
    if (usageRecords.length < 2) return null;

    // 按使用时间排序
    final sorted = usageRecords.map((e) => e.usedAt).toList()..sort();

    List<int> intervals = [];
    for (int i = 1; i < sorted.length; i++) {
      final interval = sorted[i].difference(sorted[i - 1]).inDays;
      intervals.add(interval);
    }
    if (intervals.isEmpty) return null;

    final avgInterval = intervals.reduce((a, b) => a + b) ~/ intervals.length;
    final lastUse = sorted.last;

    return lastUse.add(Duration(days: avgInterval));
  }
}
