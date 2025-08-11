import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageTagDesktopHeader extends StatelessWidget {
  final VoidCallback onAddTag; // 用于触发添加标签对话框的回调

  const ManageTagDesktopHeader({super.key, required this.onAddTag});

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
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'tag_management'.tr,
                    style: titleLG,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAddTag, // 使用传入的回调
              ),
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
