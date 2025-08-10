import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 响应式断点定义
class Breakpoints {
  static const double mobile = 480.0; // 手机
  static const double tablet = 768.0; // 平板
  static const double desktop = 1350.0; // 桌面
}

// 主响应式样式类
class ResponsiveStyle extends GetxController {
  // 静态 getter
  static ResponsiveStyle get to => Get.find<ResponsiveStyle>();

  // 平台判断
  final bool isMobileDevice =
      GetPlatform.isIOS || GetPlatform.isAndroid;

  // 最大表单宽度
  final double desktopFormMaxWidth = 700.0;

  // 响应式值计算，直接使用 Get.width 获取当前宽度，本身就是响应式的
  double _getValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final currentWidth = Get.width;
    if (currentWidth >= Breakpoints.desktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (currentWidth >= Breakpoints.tablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  // 文本样式
  // 加粗大标题
  TextStyle get titleTextEX => TextStyle(
    fontSize: _getValue(mobile: 20, tablet: 20, desktop: 20),
    fontWeight: FontWeight.bold,
  );

  // 大标题
  TextStyle get titleTextLG => TextStyle(
    fontSize: _getValue(mobile: 18, tablet: 18, desktop: 18),
    fontWeight: FontWeight.w600,
  );

  // 标题
  TextStyle get titleTextMD => TextStyle(
    fontSize: _getValue(mobile: 16, tablet: 16, desktop: 16),
    fontWeight: FontWeight.w500,
  );

  // 标题
  double get optionFontSize =>
      _getValue(mobile: 14, tablet: 14, desktop: 14);

  // 文本
  TextStyle get bodyTextLG => TextStyle(
    fontSize: _getValue(mobile: 16, tablet: 16, desktop: 16),
    //height: _getValue(mobile: 1.2, tablet: 1.3, desktop: 1.4),
  );

  TextStyle get bodyText => TextStyle(
    fontSize: _getValue(mobile: 14, tablet: 14, desktop: 14),
    //height: _getValue(mobile: 1.2, tablet: 1.3, desktop: 1.4),
  );

  // 详情页物品图标大小
  double get itemCardIconSize =>
      _getValue(mobile: 40, tablet: 44, desktop: 48);

  double get detailsIconSize =>
      _getValue(mobile: 60, tablet: 72, desktop: 80);

  // 间距系统
  double get spacingXS => _getValue(mobile: 2, tablet: 4, desktop: 4);

  double get spacingSM => _getValue(mobile: 4, tablet: 8, desktop: 8);

  double get spacingMD =>
      _getValue(mobile: 8, tablet: 12, desktop: 12);

  double get spacingLG =>
      _getValue(mobile: 8, tablet: 16, desktop: 16);

  double get spacingSideMenuOption =>
      _getValue(mobile: 6, tablet: 8, desktop: 8);

  // 图标样式
  double get iconSizeMD =>
      _getValue(mobile: 24, tablet: 26, desktop: 26);

  double get iconSizeLG =>
      _getValue(mobile: 32, tablet: 36, desktop: 40);

  // 侧边栏应用图标
  double get appIconSize => isMobileDevice ? 32 : 40; // 静态值，不随窗口拖动改变

  // 搜索栏样式
  double get searchBarHeight => isMobileDevice ? 40 : 48;

  double get searchBarIconSize => isMobileDevice ? 20 : 24;

  double get searchBarButtonSize => isMobileDevice ? 26 : 40;

  TextStyle get searchBarHintStyle =>
      isMobileDevice
          ? const TextStyle(fontSize: 12)
          : const TextStyle(fontSize: 16);

  // 导航栏高度 = 搜索栏高度 + 上下spacing，手机为MD，PC为LG
  double get appBarHeight => isMobileDevice ? 56 : 80;

  // 每行的emoji个数
  int get emojiColCount =>
      _getValue(mobile: 5, tablet: 10, desktop: 10).toInt();

  // 编辑emoji按钮的大小
  double get emojiEditIconWidth =>
      _getValue(mobile: 140, tablet: 170, desktop: 200);

  // Dialog 最大宽度
  double get dialogWidth =>
      _getValue(mobile: Get.width * 0.9, tablet: 600, desktop: 600);

  // 表格高度
  double get tableHeight => max(Get.height * 0.8, 520);

  // 热点日历格子大小
  double get heatmapCellSize =>
      _getValue(mobile: 16, tablet: 18, desktop: 18);

  // 热点日历参照指示格子大小
  double get heatmapTipCellSize =>
      _getValue(mobile: 12, tablet: 14, desktop: 14);

  // 热点日历参照指示格子大小
  double get heatmapCellSpaceBetween =>
      _getValue(mobile: 2, tablet: 4, desktop: 4);

  // 热点日历高度
  double get heatmapHeight =>
      _getValue(mobile: 168, tablet: 196, desktop: 196);
}
