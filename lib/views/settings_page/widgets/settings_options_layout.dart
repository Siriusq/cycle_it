import 'package:cycle_it/views/settings_page/widgets/language_switch_section.dart';
import 'package:cycle_it/views/settings_page/widgets/theme_switch_section.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

class SettingsOptionsLayout extends StatelessWidget {
  const SettingsOptionsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacingMD,
        vertical: spacingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ThemeSwitchSection(),
          SizedBox(height: spacingMD),
          const LanguageSwitchSection(),
        ],
      ),
    );
  }
}
