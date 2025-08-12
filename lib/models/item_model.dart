import 'package:cycle_it/models/tag_model.dart';
import 'package:cycle_it/models/usage_record_model.dart';
import 'package:flutter/material.dart';

class ItemModel {
  final int? id;
  final String name;
  final String? usageComment;
  final List<UsageRecordModel> usageRecords;
  final List<TagModel> tags;
  final String emoji;
  final Color iconColor;
  final bool notifyBeforeNextUse;
  final TimeOfDay? notificationTime;

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
    this.notificationTime,
    this.usageCount = 0,
    this.firstUsedDate,
    this.lastUsedDate,
    this.avgInterval = 0.0,
  });

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
    ValueGetter<TimeOfDay?>? notificationTime,
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
      notificationTime:
          notificationTime != null
              ? notificationTime()
              : this.notificationTime,
      usageCount: usageCount ?? this.usageCount,
      firstUsedDate: firstUsedDate ?? this.firstUsedDate,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
      avgInterval: avgInterval ?? this.avgInterval,
    );
  }
}
