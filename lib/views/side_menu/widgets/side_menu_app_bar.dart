import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SideMenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final double appBarHeight = style.appBarHeight;
    final double appIconSize = style.appIconSize;

    final TextStyle titleLG = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);

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
          spacing: 12,
          children: [
            Image.asset(
              "assets/images/logo_transparent.png",
              width: appIconSize,
              height: appIconSize,
              fit: BoxFit.contain,
            ),
            Expanded(
              // Expanded 确保文本可以占据剩余空间并处理溢出
              child: Text(
                'cycle_it'.tr,
                style: titleLG,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // AppBar底部的分割线
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 0),
      ),
      // 设置按钮作为 AppBar 的 actions
      actionsPadding: EdgeInsets.symmetric(horizontal: spacingLG),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed('/Settings'),
          icon: const Icon(Icons.tune),
        ),
      ],
    );
  }

  // AppBar 高度设置
  @override
  Size get preferredSize {
    return Size.fromHeight(ResponsiveStyle.to.appBarHeight + 1);
  }
}
