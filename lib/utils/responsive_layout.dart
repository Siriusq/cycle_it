import 'package:cycle_it/controllers/responsive_controller.dart';
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

  static int mobileBreakPoint = 768;
  static int desktopBreakPoint = 1350;

  static bool isSingleCol(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakPoint;

  static bool isDoubleCol(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopBreakPoint &&
      MediaQuery.of(context).size.width >= mobileBreakPoint;

  static bool isTripleCol(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakPoint;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    final responsiveCtrl = Get.find<ResponsiveController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 处理布局切换时的状态同步
        bool isSingle = isSingleCol(context);
        // 大屏转小屏时，如果有选中的物品，则切换到详情页
        if (isSingle && itemCtrl.currentItem.value != null) {
          if (responsiveCtrl.shouldJumpToDetails.value == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!Get.isRegistered<PageRoute>(tag: '/Details') &&
                  Get.currentRoute == '/') {
                Get.toNamed('/Details');
              }
            });
            responsiveCtrl.hadJumped();
          }
        }
        if (!isSingle &&
            responsiveCtrl.shouldJumpToDetails.value == false) {
          responsiveCtrl.resetShouldJumpStates();
        }

        //切换时关闭抽屉
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (constraints.maxWidth > desktopBreakPoint) {
            // 关闭可能打开的抽屉
            if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
              scaffoldKey.currentState!.closeDrawer();
            }
          }
        });

        if (constraints.maxWidth >= desktopBreakPoint) {
          return desktop;
        } else if (constraints.maxWidth >= mobileBreakPoint) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
