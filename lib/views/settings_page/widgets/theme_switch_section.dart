import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';
import '../../../utils/responsive_style.dart';

class ThemeSwitchSection extends StatelessWidget {
  const ThemeSwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingMD = style.spacingMD;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('theme'.tr, style: titleTextStyle)],
          ),
          SizedBox(height: spacingMD),
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                ThemeModeOption.values.map((option) {
                  return Obx(() {
                    final bool isSelected =
                        themeController.currentThemeModeOption ==
                        option;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: ElevatedButton(
                        onPressed:
                            () => themeController.setTheme(option),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                          backgroundColor:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          elevation: isSelected ? 5 : 2,
                        ),
                        child: Text(
                          _getOptionText(option),
                          style: bodyTextStyle,
                        ),
                      ),
                    );
                  });
                }).toList(),
          ),
        ],
      ),
    );
  }

  // 获取主题选项的显示文本
  String _getOptionText(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return 'light_theme'.tr;
      case ThemeModeOption.dark:
        return 'dark_theme'.tr;
      case ThemeModeOption.system:
        return 'follow_system'.tr;
    }
  }
}
