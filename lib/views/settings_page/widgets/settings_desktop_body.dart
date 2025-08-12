import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_desktop_header.dart';
import 'package:cycle_it/views/settings_page/widgets/settings_options_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDesktopBody extends StatelessWidget {
  const SettingsDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    final double maxFormWidth =
        ResponsiveStyle.to.desktopFormMaxWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxFormWidth,
          maxHeight: Get.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 模拟AppBar
              SettingsDesktopHeader(),

              Flexible(child: SettingsOptionsLayout()),
            ],
          ),
        ),
      ),
    );
  }
}
