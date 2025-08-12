import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_app_bar.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_desktop_body.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_options_layout.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 判断宽窄布局
    final bool isNarrowLayout = ResponsiveLayout.isNarrowLayout(
      context,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return isNarrowLayout
            ? Scaffold(
              appBar: SettingsAppBar(),
              body: SingleChildScrollView(
                child: Center(child: SettingsOptionsLayout()),
              ),
            )
            : Scaffold(body: SettingsDesktopBody());
      },
    );
  }
}
