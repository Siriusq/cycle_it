import 'package:cycle_it/models/tag_model.dart';
import 'package:flutter/material.dart';

import 'usage_record_model.dart';

class ItemModel {
  final int? id;
  final String name;
  String? usageComment;
  final String emoji; // <--- 直接改为 String 类型的 emoji
  final Color iconColor;
  List<UsageRecordModel> usageRecords; // 列表始终保持时间排序
  final bool notifyBeforeNextUse;
  final List<TagModel> tags;

  // 缓存变量
  DateTime? _cachedFirstUsedDate;
  double? _cachedUsageFrequency;
  DateTime? _cachedNextExpectedUse;

  ItemModel({
    this.id,
    required this.name,
    this.usageComment,
    required this.usageRecords,
    required this.tags,
    required this.emoji,
    required this.iconColor,
    this.notifyBeforeNextUse = false,
  }) {
    // 构造时进行排序
    usageRecords.sort((a, b) => a.usedAt.compareTo(b.usedAt));
  }

  // 获取首次使用日期
  DateTime? get firstUsedDate {
    if (_cachedFirstUsedDate == null) {
      if (usageRecords.isEmpty) {
        _cachedUsageFrequency = null;
      } else {
        _cachedFirstUsedDate = usageRecords.first.usedAt;
      }
    }
    return _cachedFirstUsedDate;
  }

  // 计算使用频率
  double get usageFrequency {
    if (_cachedUsageFrequency == null) {
      if (usageRecords.isEmpty) {
        _cachedUsageFrequency = 0;
      } else {
        final daysSinceFirst =
            DateTime.now().difference(firstUsedDate!).inDays;
        if (daysSinceFirst == 0) {
          _cachedUsageFrequency = usageRecords.length.toDouble();
        } else {
          _cachedUsageFrequency =
              daysSinceFirst / usageRecords.length;
        }
      }
    }
    return _cachedUsageFrequency!;
  }

  // 预计下次使用时间 = 上次使用时间 + 平均使用间隔
  DateTime? get nextExpectedUse {
    if (_cachedNextExpectedUse == null) {
      if (usageRecords.length < 2) {
        _cachedNextExpectedUse = null;
      } else {
        // 使用已排序的 usageRecords
        List<int> intervals = [];
        for (int i = 1; i < usageRecords.length; i++) {
          final interval =
              usageRecords[i].usedAt
                  .difference(usageRecords[i - 1].usedAt)
                  .inDays;
          intervals.add(interval);
        }
        if (intervals.isEmpty) {
          _cachedNextExpectedUse = null;
        } else {
          final avgInterval =
              intervals.reduce((a, b) => a + b) ~/ intervals.length;
          final lastUse = usageRecords.last.usedAt;
          _cachedNextExpectedUse = lastUse.add(
            Duration(days: avgInterval),
          );
        }
      }
    }
    return _cachedNextExpectedUse;
  }

  // 在修改 usageRecords 后调用此方法来清除缓存
  void invalidateCalculatedProperties() {
    _cachedUsageFrequency = null;
    _cachedNextExpectedUse = null;
    _cachedProgress = null; // 你的 _cachedProgress 也需要清空
  }

  // 计算到今天的日期差
  int daysToToday(bool isNext) {
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
    final daysSinceLastUsage = daysToToday(false).abs();
    final daysTillNextUsage = daysToToday(true).abs();
    if (daysSinceLastUsage == 0) return 0;
    if (daysTillNextUsage <= 0) return 1.0;
    final totalDuration = daysSinceLastUsage + daysTillNextUsage;
    return daysSinceLastUsage / totalDuration;
  }
}
