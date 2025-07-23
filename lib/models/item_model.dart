import 'package:cycle_it/models/tag_model.dart';
import 'package:flutter/material.dart';

import 'usage_record_model.dart';

class ItemModel {
  final int? id;
  final String name;
  final String? usageComment;
  final List<UsageRecordModel> usageRecords;
  final List<TagModel> tags;
  final String emoji;
  final Color iconColor;
  final bool notifyBeforeNextUse;

  // --- 统计属性 ---
  final int usageCount;
  final DateTime? firstUsedDate;
  final DateTime? lastUsedDate;
  final double avgInterval; // 平均使用间隔天数

  ItemModel({
    this.id,
    required this.name,
    this.usageComment,
    this.usageRecords = const [],
    this.tags = const [],
    required this.emoji,
    required this.iconColor,
    this.notifyBeforeNextUse = false,
    this.usageCount = 0,
    this.firstUsedDate,
    this.lastUsedDate,
    this.avgInterval = 0.0,
  });

  // [修改] Getter 现在直接返回存储的属性值
  double get usageFrequency => avgInterval;

  DateTime? get nextExpectedUse =>
      lastUsedDate?.add(Duration(days: avgInterval.round()));

  double timePercentageBetweenLastAndNext() {
    if (lastUsedDate == null || nextExpectedUse == null) {
      return 0.0;
    }
    final now = DateTime.now();
    if (now.isBefore(lastUsedDate!)) return 0.0;
    if (now.isAfter(nextExpectedUse!)) return 1.0;

    final totalDuration =
        nextExpectedUse!.difference(lastUsedDate!).inSeconds;
    if (totalDuration <= 0) return 1.0;

    final elapsedDuration = now.difference(lastUsedDate!).inSeconds;
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  // copyWith 方法，方便创建对象的副本
  ItemModel copyWith({
    int? id,
    String? name,
    String? usageComment,
    List<UsageRecordModel>? usageRecords,
    List<TagModel>? tags,
    String? emoji,
    Color? iconColor,
    bool? notifyBeforeNextUse,
    int? usageCount,
    DateTime? firstUsedDate,
    DateTime? lastUsedDate,
    double? avgInterval,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      usageComment: usageComment ?? this.usageComment,
      usageRecords: usageRecords ?? this.usageRecords,
      tags: tags ?? this.tags,
      emoji: emoji ?? this.emoji,
      iconColor: iconColor ?? this.iconColor,
      notifyBeforeNextUse:
          notifyBeforeNextUse ?? this.notifyBeforeNextUse,
      usageCount: usageCount ?? this.usageCount,
      firstUsedDate: firstUsedDate ?? this.firstUsedDate,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
      avgInterval: avgInterval ?? this.avgInterval,
    );
  }

  // 计算到今天的日期差
  int daysToToday({required bool isNext}) {
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
}
