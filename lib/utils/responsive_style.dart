import 'package:flutter/material.dart';

import 'constants.dart';

// 响应式断点定义
class Breakpoints {
  static const double mobile = 480; // 手机
  static const double tablet = 768; // 平板
  static const double desktop = 1350; // 桌面
}

// 主响应式样式类
class ResponsiveStyle {
  final double screenWidth;

  // 构造器私有化
  ResponsiveStyle._(this.screenWidth);

  // 工厂方法
  factory ResponsiveStyle.of(
    BuildContext context, [
    double? containerWidth,
  ]) {
    final mediaQuery = MediaQuery.of(context);
    final width = containerWidth ?? mediaQuery.size.width;
    return ResponsiveStyle._(width);
  }

  // 文本样式
  // 加粗大标题
  TextStyle get titleTextEX => TextStyle(
    color: kTitleTextColor,
    fontSize: _getValue(mobile: 14, tablet: 16, desktop: 18),
    fontWeight: FontWeight.bold,
  );

  // 大标题
  TextStyle get titleTextLG => TextStyle(
    color: kTitleTextColor,
    fontSize: _getValue(mobile: 14, tablet: 16, desktop: 18),
    fontWeight: FontWeight.w600,
  );

  // 标题
  TextStyle get titleTextMD => TextStyle(
    color: kTitleTextColor,
    fontSize: _getValue(mobile: 12, tablet: 14, desktop: 16),
    fontWeight: FontWeight.w500,
  );

  // 标题
  double get titleTextFontMD =>
      _getValue(mobile: 12, tablet: 14, desktop: 14);

  // 文本
  TextStyle get bodyText => TextStyle(
    color: kTextColor,
    fontSize: _getValue(mobile: 10, tablet: 12, desktop: 14),
    height: _getValue(mobile: 1.2, tablet: 1.3, desktop: 1.4),
  );

  // 小文本
  TextStyle get bodyTextSM => TextStyle(
    color: kTextColor,
    fontSize: _getValue(mobile: 8, tablet: 10, desktop: 12),
    height: _getValue(mobile: 1.0, tablet: 1.1, desktop: 1.2),
  );

  // 间距系统
  double get spacingXS => _getValue(mobile: 2, tablet: 4, desktop: 6);

  double get spacingSM =>
      _getValue(mobile: 6, tablet: 8, desktop: 10);

  double get spacingMD =>
      _getValue(mobile: 8, tablet: 12, desktop: 14);

  double get spacingLG =>
      _getValue(mobile: 8, tablet: 14, desktop: 20);

  // 图标样式
  double get iconSizeMD =>
      _getValue(mobile: 24, tablet: 26, desktop: 26);

  double get iconSizeSM =>
      _getValue(mobile: 12, tablet: 16, desktop: 20);

  double get iconSizeLG =>
      _getValue(mobile: 32, tablet: 36, desktop: 40);

  // 顶栏高度
  double get topBarHeight =>
      _getValue(mobile: 32, tablet: 36, desktop: 48);

  // 响应卡片最小宽度
  double get minComponentWidth =>
      _getValue(mobile: 120, tablet: 140, desktop: 160);

  // 组件样式
  TagStyle get tagStyle => TagStyle(
    fontSize: _getValue(mobile: 8, tablet: 10, desktop: 12),
    iconSize: _getValue(mobile: 10, tablet: 12, desktop: 16),
    spacing: _getValue(mobile: 1, tablet: 2, desktop: 4),
    // 其他参数...
  );

  // 响应式值计算
  double _getValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (screenWidth >= Breakpoints.desktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (screenWidth >= Breakpoints.tablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

// 标签样式子类
class TagStyle {
  final double fontSize;
  final double iconSize;
  final double spacing;

  const TagStyle({
    required this.fontSize,
    required this.iconSize,
    required this.spacing,
  });
}

// 快捷访问扩展
extension ResponsiveStyleExtension on BuildContext {
  ResponsiveStyle responsiveStyle([double? containerWidth]) {
    return ResponsiveStyle.of(this, containerWidth);
  }
}
