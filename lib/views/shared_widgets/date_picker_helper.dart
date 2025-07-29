import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/responsive_style.dart';

Future<DateTime?> promptForUsageDate(DateTime initialDate) async {
  final style = ResponsiveStyle.to;
  final spacingMD = style.spacingMD;

  final DateTime? pickedDate = await showDatePicker(
    context: Get.context!,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
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

  return pickedDate;
}
