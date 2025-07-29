import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/responsive_style.dart';

Future<TimeOfDay?> promptForNotifyTime(TimeOfDay initialTime) async {
  final style = ResponsiveStyle.to;
  final spacingMD = style.spacingMD;

  final TimeOfDay? pickedTime = await showTimePicker(
    context: Get.context!,
    initialTime: initialTime,
    helpText: 'time_help'.tr,
    cancelText: 'cancel'.tr,
    confirmText: 'confirm'.tr,
    errorInvalidText: 'time_invalid_error'.tr,
    hourLabelText: 'hour_label'.tr,
    minuteLabelText: 'minute_label'.tr,
    builder: (BuildContext context, Widget? child) {
      final ThemeData currentTheme = Get.theme;
      return Theme(
        data: currentTheme.copyWith(
          // 修复默认状态下数字 Overflow 的问题
          textTheme: TextTheme(bodyLarge: style.bodyTextLG),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(spacingMD),
            ),
          ),
          timePickerTheme: TimePickerThemeData(
            helpTextStyle: style.titleTextMD.copyWith(
              color: currentTheme.colorScheme.onSurface,
            ),
            dayPeriodColor: currentTheme.colorScheme.inversePrimary,
            dayPeriodTextColor: currentTheme.colorScheme.onSurface,
          ),
        ),
        child: child!,
      );
    },
  );

  return pickedTime;
}
