import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';
import '../../settings_page/settings_page.dart'; // 确保此路径正确

class SideMenuAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SideMenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double appIconSize = style.appIconSize;
    final TextStyle titleTextEX = style.titleTextEX;
    final double iconSizeMD = style.iconSizeMD;
    final double iconSizeLG = style.iconSizeLG;
    final double appBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;

    return AppBar(
      automaticallyImplyLeading: false,
      // 防止滚动时变色
      backgroundColor:
          Theme.of(context).colorScheme.surfaceContainerLow,
      scrolledUnderElevation: 0,
      toolbarHeight: appBarHeight,
      titleSpacing: 0,

      // App 图标和 "Cycle It" 文本作为 AppBar 的 title
      title: Padding(
        // 添加左侧填充，以模拟原 SideMenuHeader 的整体 padding
        padding: EdgeInsets.only(left: spacingLG),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo_transparent.png",
              width: appIconSize,
              height: appIconSize,
              fit: BoxFit.contain,
            ),
            SizedBox(width: spacingMD),
            Expanded(
              // Expanded 确保文本可以占据剩余空间并处理溢出
              child: Text(
                "Cycle It",
                style: titleTextEX,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // AppBar底部的分割线
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Divider(height: 0),
      ),
      // 设置按钮作为 AppBar 的 actions
      actions: [
        SizedBox(
          height: iconSizeLG,
          width: iconSizeLG,
          child: IconButton(
            iconSize: iconSizeMD,
            padding: EdgeInsets.zero,
            // 移除默认填充
            constraints: const BoxConstraints(),
            // 移除默认约束
            onPressed: () => Get.to(() => const SettingsPage()),
            icon: const Icon(Icons.tune),
          ),
        ),
        SizedBox(width: spacingLG), // 右侧间距
      ],
    );
  }

  // 定义 AppBar 的首选大小，与 toolbarHeight 保持一致
  @override
  Size get preferredSize {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double appBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;

    // AppBar 高度设置
    return Size.fromHeight(appBarHeight + 1);
  }
}
