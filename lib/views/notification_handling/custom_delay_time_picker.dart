import 'package:cycle_it/views/shared_widgets/date_picker_helper.dart';
import 'package:cycle_it/views/shared_widgets/time_picker_helper.dart';
import 'package:flutter/material.dart';

// 自定义推迟通知时间
Future<DateTime?> promptForCustomDelayTime() async {
  final DateTime now = DateTime.now();

  // 选择通知日期
  final DateTime? pickedDate = await promptForDateSelection(
    now,
    isPrevious: false,
  );

  if (pickedDate == null) {
    return null;
  }

  // 选择通知时间
  final TimeOfDay? pickedTime = await promptForNotifyTime(
    TimeOfDay.fromDateTime(now),
  );

  if (pickedTime == null) {
    return null;
  }

  // 组合日期和时间
  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
