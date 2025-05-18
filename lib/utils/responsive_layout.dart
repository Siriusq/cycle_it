import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.scaffoldKey,
  });

  static bool isSingleCol(BuildContext context) => MediaQuery.of(context).size.width < 768;

  static bool isDoubleCol(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 && MediaQuery.of(context).size.width >= 768;

  static bool isTripleCol(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 处理布局切换时的状态同步
        if (constraints.maxWidth >= 650) {
          // 大屏模式强制清除路由栈
          if (Get.currentRoute == '/Details') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.until((route) => route.isFirst);
            });
          }
        } else {
          // 小屏模式同步选中状态
          if (itemCtrl.selectedItem.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!Get.isRegistered<PageRoute>(tag: '/Details')) {
                Get.toNamed('/Details');
              }
            });
          }
        }

        //切换时关闭抽屉
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (constraints.maxWidth >= 1100) {
            // 关闭可能打开的抽屉
            if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
              scaffoldKey.currentState!.closeDrawer();
            }
          }
        });

        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
