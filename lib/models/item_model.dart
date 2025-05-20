import 'package:cycle_it/models/tag_model.dart';
import 'package:flutter/material.dart';

import 'usage_record_model.dart';

class ItemModel {
  final int id;
  final String name;
  String? usageComment;
  final String iconPath;
  final Color iconColor;
  DateTime? firstUsed;
  final List<UsageRecordModel> usageRecords;
  final bool notifyBeforeNextUse;
  final List<TagModel> tags;

  ItemModel({
    required this.id,
    required this.name,
    this.usageComment,
    this.firstUsed,
    required this.usageRecords,
    required this.tags,
    required this.iconPath,
    required this.iconColor,
    this.notifyBeforeNextUse = true,
  });

  // 计算使用频率
  double get usageFrequency {
    if (usageRecords.isEmpty) return 0;
    final daysSinceFirst =
        DateTime.now().difference(usageRecords.first.usedAt).inDays;
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

    final avgInterval =
        intervals.reduce((a, b) => a + b) ~/ intervals.length;
    final lastUse = sorted.last;

    return lastUse.add(Duration(days: avgInterval));
  }

  // 计算日期差
  int daysBetweenTodayAnd(bool isNext) {
    DateTime targetDate;
    if (isNext) {
      if (nextExpectedUse == null) return 0;
      targetDate = nextExpectedUse!;
    } else {
      if (usageRecords.isEmpty) return 0;
      targetDate = usageRecords.last.usedAt;
    }
    // 获取当前日期，去除时分秒，避免计算误差
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    final target = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    return target.difference(currentDate).inDays;
  }

  // 计算上次使用与下次使用之间的时间进度
  double? _cachedProgress;
  double timePercentageBetweenLastAndNext() {
    return _cachedProgress ??= _calculateProgress();
  }

  double _calculateProgress() {
    final daysSinceLastUsage = daysBetweenTodayAnd(false).abs();
    final daysTillNextUsage = daysBetweenTodayAnd(true).abs();
    if (daysSinceLastUsage == 0) return 0;
    if (daysTillNextUsage <= 0) return 1.0;
    final totalDuration = daysSinceLastUsage + daysTillNextUsage;
    return daysSinceLastUsage / totalDuration;
  }
}
