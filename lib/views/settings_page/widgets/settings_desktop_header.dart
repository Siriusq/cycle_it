import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';

class SettingsDesktopHeader extends StatelessWidget {
  const SettingsDesktopHeader({super.key});

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
                  child: Text('设置', style: largeTitleTextStyle),
                ),
              ),
              SizedBox(width: 40), //补偿返回按钮宽度，保证标题居中
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }
}
