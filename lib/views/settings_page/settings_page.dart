import 'package:cycle_it/views/settings_page/widgets/settings_app_bar.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_desktop_body.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_options_layout.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive_style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobileDevice = ResponsiveStyle.to.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // 在宽屏幕上不显示AppBar
          appBar: isMobileDevice ? SettingsAppBar() : null,
          body:
              isMobileDevice
                  ? SingleChildScrollView(
                    child: Center(child: SettingsOptionsLayout()),
                  )
                  : SettingsDesktopBody(),
        );
      },
    );
  }
}
