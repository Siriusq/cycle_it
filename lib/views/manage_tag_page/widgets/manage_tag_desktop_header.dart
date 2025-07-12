import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';

class ManageTagDesktopHeader extends StatelessWidget {
  final VoidCallback onAddTag; // 用于触发添加标签对话框的回调

  const ManageTagDesktopHeader({super.key, required this.onAddTag});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final bool isMobileDevice = style.isMobileDevice;

    // 移动端不显示
    if (isMobileDevice) {
      return const SizedBox.shrink();
    }

    // 桌面端模拟 AppBar 样式
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacingSM,
            vertical: spacingMD,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'tag_management'.tr,
                    style: largeTitleTextStyle,
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
        Divider(height: 0),
      ],
    );
  }
}
