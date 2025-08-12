import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/theme_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeSwitchSection extends StatelessWidget {
  const ThemeSwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 定义屏幕宽度断点
    final double breakpoint =
        ResponsiveStyle.to.settingsPageBreakpoint;
    final ThemeController themeController = Get.find();
    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > breakpoint) {
            // 宽屏布局
            return _buildWideLayout(
              context,
              themeController,
              titleLG,
            );
          } else {
            // 窄屏布局
            return _buildNarrowLayout(
              context,
              themeController,
              titleLG,
            );
          }
        },
      ),
    );
  }

  // 宽屏布局
  Widget _buildWideLayout(
    BuildContext context,
    ThemeController themeController,
    TextStyle titleStyle,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('theme'.tr, style: titleStyle),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: VerticalDivider(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildButtons(themeController, context),
            ),
          ),
        ],
      ),
    );
  }

  // 窄屏布局
  Widget _buildNarrowLayout(
    BuildContext context,
    ThemeController themeController,
    TextStyle titleStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Text('theme'.tr, style: titleStyle)),
        const SizedBox(height: 16.0),
        ..._buildButtons(themeController, context),
      ],
    );
  }

  // 构建按钮列表
  List<Widget> _buildButtons(
    ThemeController themeController,
    BuildContext context,
  ) {
    return ThemeModeOption.values.map((option) {
      final button = Obx(() {
        final bool isSelected =
            themeController.currentThemeModeOption == option;
        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => themeController.setTheme(option),
            style: TextButton.styleFrom(
              textStyle:
                  Theme.of(
                    context,
                  ).textTheme.labelLarge!.useSystemChineseFont(),
              foregroundColor:
                  isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
              backgroundColor:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color:
                      isSelected
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            icon: Icon(_getOptionIcon(option)),
            label: Text(_getOptionText(option)),
          ),
        );
      });

      if (option != ThemeModeOption.values.last) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: button,
        );
      }
      return button;
    }).toList();
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

  // 获取主题选项的图标
  IconData _getOptionIcon(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return Icons.light_mode;
      case ThemeModeOption.dark:
        return Icons.dark_mode;
      case ThemeModeOption.system:
        return Icons.brightness_medium_outlined;
    }
  }
}
