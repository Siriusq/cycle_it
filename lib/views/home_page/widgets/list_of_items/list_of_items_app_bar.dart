import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/responsive_layout.dart';
import '../../../../utils/responsive_style.dart';
import 'custom_search_bar.dart';

class ListOfItemsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItemsAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double searchBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    return AppBar(
      primary: isSingleCol,
      automaticallyImplyLeading: false,
      toolbarHeight: searchBarHeight,
      titleSpacing: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
      // 非桌面端显示抽屉按钮
      leading:
          !ResponsiveLayout.isTripleCol(context)
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed:
                    () => scaffoldKey.currentState?.openDrawer(),
              )
              : null,

      // 搜索框
      title: Padding(
        padding: EdgeInsets.only(left: isTripleCol ? 20 : 0),
        child: const CustomSearchBar(),
      ),

      // AppBar底部的分割线
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Divider(height: 0),
      ),

      // 添加物品按钮
      actionsPadding: EdgeInsets.symmetric(horizontal: spacingSM),
      actions: [
        IconButton(
          icon: const Icon(Icons.library_add_outlined),
          onPressed: () async {
            final result = await Get.toNamed('/AddEditItem');
            // 在显示 Snackbar 前添加一个微小延迟
            await Future.delayed(const Duration(milliseconds: 50));
            if (result != null && result['success']) {
              Get.snackbar(
                'success'.tr,
                '${result['message']}',
                duration: const Duration(seconds: 1),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double searchBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;

    // AppBar 高度设置
    return Size.fromHeight(searchBarHeight + 1);
  }
}
