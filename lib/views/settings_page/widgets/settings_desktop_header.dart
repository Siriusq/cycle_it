import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDesktopHeader extends StatelessWidget {
  const SettingsDesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    // 桌面端模拟 AppBar 样式
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Center(
                  child: Text('settings'.tr, style: titleLG),
                ),
              ),
              const SizedBox(width: 40), //补偿返回按钮宽度，保证标题居中
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
