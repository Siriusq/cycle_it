import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<TimeOfDay?> promptForNotifyTime(TimeOfDay initialTime) async {
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
      final TextStyle titleLG =
          Theme.of(
            context,
          ).textTheme.titleLarge!.useSystemChineseFont();
      final TextStyle bodyLG =
          Theme.of(
            context,
          ).textTheme.bodyLarge!.useSystemChineseFont();

      return Theme(
        data: currentTheme.copyWith(
          // 修复默认状态下数字 Overflow 的问题
          textTheme: TextTheme(bodyLarge: bodyLG),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(padding: EdgeInsets.all(12)),
          ),
          timePickerTheme: TimePickerThemeData(
            helpTextStyle: titleLG.copyWith(
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
