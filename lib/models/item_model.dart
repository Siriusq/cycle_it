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

  // --- 缓存的计算属性 ---
  DateTime? _firstUsedDate;
  DateTime? _lastUsedDate;
  double? _usageFrequency;
  DateTime? _nextExpectedUse;

  ItemModel({
    this.id,
    required this.name,
    this.usageComment,
    this.usageRecords = const [],
    this.tags = const [],
    required this.emoji,
    required this.iconColor,
    this.notifyBeforeNextUse = false,
  }) {
    _calculateProperties();
  }

  DateTime? get firstUsedDate => _firstUsedDate;

  DateTime? get lastUsedDate => _lastUsedDate;

  double get usageFrequency => _usageFrequency ?? 0.0;

  DateTime? get nextExpectedUse => _nextExpectedUse;

  void _calculateProperties() {
    if (usageRecords.isNotEmpty) {
      // 确保记录是排序的
      usageRecords.sort((a, b) => a.usedAt.compareTo(b.usedAt));
      _firstUsedDate = usageRecords.first.usedAt;
      _lastUsedDate = usageRecords.last.usedAt;

      if (usageRecords.length > 1) {
        final totalInterval = usageRecords
            .skip(1)
            .map((e) => e.intervalSinceLastUse ?? 0)
            .reduce((a, b) => a + b);
        _usageFrequency = totalInterval / (usageRecords.length - 1);
        _nextExpectedUse = _lastUsedDate!.add(
          Duration(days: _usageFrequency!.round()),
        );
      }
    }
  }

  void invalidateCalculatedProperties() {
    _calculateProperties();
  }

  double timePercentageBetweenLastAndNext() {
    if (_lastUsedDate == null || _nextExpectedUse == null) {
      return 0.0;
    }
    final now = DateTime.now();
    if (now.isBefore(_lastUsedDate!)) return 0.0;
    if (now.isAfter(_nextExpectedUse!)) return 1.0;

    final totalDuration =
        _nextExpectedUse!.difference(_lastUsedDate!).inSeconds;
    if (totalDuration <= 0) return 1.0;

    final elapsedDuration = now.difference(_lastUsedDate!).inSeconds;
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
