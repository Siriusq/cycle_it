import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isLarge;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final style =
        isLarge
            ? ResponsiveStyle.to.tagStyleLG
            : ResponsiveStyle.to.tagStyle;

    return Obx(() {
      final ThemeData currentTheme = themeController.currentThemeData;

      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: currentTheme.colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: style.spacing * 2,
            vertical: style.spacing * 0.5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: style.iconSize, color: iconColor),
              SizedBox(width: style.spacing * 0.5),
              Text(
                label,
                style: TextStyle(
                  fontSize: style.fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
