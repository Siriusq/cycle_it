import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({super.key, required this.mobile, required this.tablet, required this.desktop});

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    // 窗口布局切换时进行路由切换
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final currentRoute = Get.currentRoute;
    //   if (isMobile(context)) {
    //     if (itemCtrl.selectedItem.value != null && currentRoute != '/Details') {
    //       Get.toNamed('/Details');
    //     } else if (itemCtrl.selectedItem.value == null && currentRoute == '/Details') {
    //       Get.back();
    //     }
    //   } else {
    //     if (currentRoute == '/Details') {
    //       Get.offAllNamed('/');
    //     }
    //   }
    // });

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
