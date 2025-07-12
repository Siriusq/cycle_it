import 'package:cycle_it/views/settings_page/widgets/settings_desktop_header.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_options_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';
import '../../../utils/responsive_style.dart';

class SettingsDesktopBody extends StatelessWidget {
  const SettingsDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double maxFormWidth = style.desktopFormMaxWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxFormWidth,
          maxHeight: Get.height * 0.9,
        ),
        child: Obx(() {
          final ThemeData currentTheme =
              themeController.currentThemeData;

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2,
                color: currentTheme.colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(15),
              color: currentTheme.colorScheme.surfaceContainerLow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 模拟AppBar
                SettingsDesktopHeader(),

                SettingsOptionsLayout(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
