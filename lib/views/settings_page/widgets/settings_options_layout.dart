import 'package:cycle_it/views/settings_page/widgets/database_management_section.dart';
import 'package:cycle_it/views/settings_page/widgets/language_switch_section.dart';
import 'package:cycle_it/views/settings_page/widgets/theme_switch_section.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

class SettingsOptionsLayout extends StatelessWidget {
  const SettingsOptionsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final double spacingLG = ResponsiveStyle.to.spacingLG;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacingLG,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: spacingLG,
        children: [
          // 语言
          LanguageSwitchSection(),
          // 主题
          ThemeSwitchSection(),
          // 数据
          DatabaseManagementSection(),
          // 关于
          //AboutSection(),
        ],
      ),
    );
  }
}
