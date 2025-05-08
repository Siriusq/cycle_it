import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    //final ctrl = Get.find<ItemController>();

    // 窗口布局切换时进行路由切换
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMobile(context) && Get.currentRoute == '/Details') {
        Get.offAllNamed('/');
      }

      if (isMobile(context)) {}

      // if (!isMobile(context) && Get.currentRoute == '/Details') {
      //   Get.toNamed("/");
      // } else if (isMobile(context) && Get.currentRoute == '/') {
      //   if (ctrl.selectedItem.value != null) {
      //     Get.toNamed("/Details");
      //   } else {
      //     //ctrl.clearSelection();
      //     Get.toNamed("/");
      //   }
      // }
      print(Get.currentRoute);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
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
