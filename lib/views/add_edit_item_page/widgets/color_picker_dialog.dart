import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';

Future<Color?> showCustomColorPickerDialog(
  Color initColor,
  BuildContext context,
) async {
  Color selectedColor = initColor;
  final TextStyle titleMD =
      Theme.of(context).textTheme.titleMedium!.useSystemChineseFont();

  return await Get.dialog<Color>(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 设置对话框圆角
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias,
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        //height: Get.height * 0.7, // 占据屏幕高度的 70%
        width: ResponsiveStyle.to.dialogWidth, // 占据屏幕宽度的 90%
        child: SingleChildScrollView(
          child: ColorPicker(
            color: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            width: 44,
            height: 44,
            borderRadius: 4,
            spacing: 8,
            runSpacing: 8,
            wheelDiameter: 250,
            title: Text('select_color'.tr),
            subheading: Text('shades_and_tones'.tr, style: titleMD),
            wheelSubheading: Text(
              'pick_color_wheel'.tr,
              style: titleMD,
            ),
            recentColorsSubheading: Text(
              'recent_color'.tr,
              style: titleMD,
            ),
            showMaterialName: false,
            showColorName: false,
            showColorCode: false,
            showRecentColors: true,
            copyPasteBehavior: const ColorPickerCopyPasteBehavior(),
            enableShadesSelection: true,
            enableTonalPalette: false,
            tonalColorSameSize: true,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: true,
              ColorPickerType.accent: true,
              ColorPickerType.bw: false,
              ColorPickerType.custom: false,
              ColorPickerType.wheel: true,
            },
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.cancel),
          label: Text('cancel'.tr),
        ),
        TextButton.icon(
          onPressed: () {
            Get.back(result: selectedColor);
          },
          icon: const Icon(Icons.check),
          label: Text('confirm'.tr),
        ),
      ],
    ),
  );
}
