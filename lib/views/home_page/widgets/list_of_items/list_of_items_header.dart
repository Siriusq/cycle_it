import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/responsive_layout.dart';
import '../../../../utils/responsive_style.dart';
import 'custom_search_bar.dart';

class ListOfItemsHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItemsHeader({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingXS = style.spacingXS;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double verticalSpacing = isMobile ? spacingSM : spacingLG;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalSpacing,
        vertical: verticalSpacing,
      ),
      child: Row(
        children: [
          // 非桌面端显示抽屉按钮
          if (!ResponsiveLayout.isTripleCol(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
          if (!ResponsiveLayout.isTripleCol(context))
            SizedBox(width: spacingXS),

          // 搜索框
          const CustomSearchBar(),
          SizedBox(width: spacingXS),

          // 添加物品按钮
          IconButton(
            icon: const Icon(Icons.library_add_outlined),
            onPressed: () async {
              final result = await Get.toNamed('/AddEditItem');
              // 在显示 Snackbar 前添加一个微小延迟
              await Future.delayed(const Duration(milliseconds: 50));
              if (result != null && result['success']) {
                Get.snackbar('成功', '${result['message']}');
              }
            },
          ),
        ],
      ),
    );
  }
}
