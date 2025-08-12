import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final String textLine = 'info'.tr;
    final TextStyle labelLG =
        Theme.of(
          context,
        ).textTheme.labelLarge!.useSystemChineseFont();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          // 一行显示
          return Text(
            textLine,
            textAlign: TextAlign.center,
            style: labelLG,
          );
        } else {
          // 三行显示
          final parts =
              textLine.split('·').map((e) => e.trim()).toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children:
                parts
                    .map(
                      (part) => Text(
                        part,
                        textAlign: TextAlign.center,
                        style: labelLG,
                      ),
                    )
                    .toList(),
          );
        }
      },
    );
  }
}
