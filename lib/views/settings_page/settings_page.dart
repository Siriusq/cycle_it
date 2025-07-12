import 'package:cycle_it/views/settings_page/widgets/settings_desktop_body.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_options_layout.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive_style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isMobileDevice = style.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // 在宽屏幕上不显示默认AppBar
          appBar:
              isMobileDevice
                  ? AppBar(title: const Text('主题切换'))
                  : null,
          body:
              isMobileDevice
                  ? SettingsOptionsLayout()
                  : SettingsDesktopBody(),
        );
      },
    );
  }
}
