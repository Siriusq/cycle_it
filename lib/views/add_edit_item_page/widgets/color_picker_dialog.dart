import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

Future<Color?> showCustomColorPickerDialog(Color initColor) async {
  Color selectedColor = initColor;
  final ResponsiveStyle style = ResponsiveStyle.to;
  final TextStyle titleTextStyleLG = style.titleTextLG;
  final TextStyle titleTextStyle = style.titleTextMD;
  final double spacingSM = style.spacingSM;
  final double spacingMD = style.spacingMD;
  final TextStyle bodyTextStyle = style.bodyText;

  return await Get.dialog<Color>(
    AlertDialog(
      backgroundColor: kPrimaryBgColor,
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
        width: style.dialogWidth, // 占据屏幕宽度的 90%
        child: SingleChildScrollView(
          child: ColorPicker(
            color: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            width: 44,
            height: 44,
            borderRadius: 4,
            spacing: spacingSM,
            runSpacing: spacingSM,
            wheelDiameter: 250,
            title: Text('select_color'.tr, style: titleTextStyleLG),
            subheading: Text(
              'shades_and_tones'.tr,
              style: titleTextStyle,
            ),
            wheelSubheading: Text(
              'pick_color_wheel'.tr,
              style: titleTextStyle,
            ),
            recentColorsSubheading: Text(
              'recent_color'.tr,
              style: titleTextStyle,
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
          style: TextButton.styleFrom(
            //fixedSize: Size(emojiEditIconWidth, 40),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.cancel_outlined, color: kTextColor),
          label: Text('cancel'.tr, style: bodyTextStyle),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            //fixedSize: Size(emojiEditIconWidth, 40),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Get.back(result: selectedColor);
          },
          icon: Icon(Icons.check_circle_outline, color: kTextColor),
          label: Text('confirm'.tr, style: bodyTextStyle),
        ),
      ],
    ),
  );
}
