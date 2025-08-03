import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/responsive_style.dart';

Future<DateTime?> promptForDateSelection(
  DateTime initialDate, {
  bool isPrevious = true,
}) async {
  final style = ResponsiveStyle.to;
  final spacingMD = style.spacingMD;

  final DateTime? pickedDate = await showDatePicker(
    context: Get.context!,
    initialDate: initialDate,
    firstDate: isPrevious ? DateTime(2000) : DateTime.now(),
    lastDate:
        isPrevious
            ? DateTime.now()
            : DateTime.now().add(Duration(days: 365)),
    helpText: 'date_help'.tr,
    cancelText: 'cancel'.tr,
    confirmText: 'confirm'.tr,
    errorFormatText: 'date_format_error'.tr,
    errorInvalidText: 'date_invalid_error'.tr,
    fieldHintText: 'date_input_hint'.tr,
    fieldLabelText: 'date_input_label'.tr,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Get.theme.copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(spacingMD),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    // 将时间部分统一设置为零点零分，避免时间间隔运算不准确
    return pickedDate.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  return null;
}
