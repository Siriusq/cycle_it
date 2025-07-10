import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';
import '../../settings_page/settings_page.dart';

class SideMenuHeader extends StatelessWidget {
  const SideMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final double spacingMD = style.spacingMD;
    final double appIconSize = style.appIconSize;
    final TextStyle titleTextEX = style.titleTextEX;
    final double iconSizeMD = style.iconSizeMD;
    final double iconSizeLG = style.iconSizeLG;

    return Padding(
      padding: EdgeInsets.all(spacingLG),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            // App 图标
            Image.asset(
              "assets/images/logo_transparent.png",
              width: appIconSize,
              height: appIconSize,
              fit: BoxFit.contain,
            ),
            SizedBox(width: spacingMD),
            // 中间文字
            Expanded(
              child: Text(
                "Cycle It",
                style: titleTextEX,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 设置按钮
            SizedBox(
              height: iconSizeLG,
              width: iconSizeLG,
              child: IconButton(
                iconSize: iconSizeMD,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Get.to(() => const SettingsPage()),
                icon: const Icon(Icons.tune, color: kTitleTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
