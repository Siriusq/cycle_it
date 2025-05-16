import 'package:flutter/material.dart';

import 'constants.dart';

// 响应式断点定义
class Breakpoints {
  static const double mobile = 480; // 手机
  static const double tablet = 768; // 平板
  static const double desktop = 1024; // 桌面
}

// 主响应式样式类
class ResponsiveStyle {
  final double screenWidth;

  // 构造器私有化
  ResponsiveStyle._(this.screenWidth);

  // 工厂方法
  factory ResponsiveStyle.of(BuildContext context, [double? containerWidth]) {
    final mediaQuery = MediaQuery.of(context);
    final width = containerWidth ?? mediaQuery.size.width;
    return ResponsiveStyle._(width);
  }

  // 文本样式
  TextStyle get titleLarge => TextStyle(
    color: kTitleTextColor,
    fontSize: _getValue(mobile: 14, tablet: 16, desktop: 18),
    fontWeight: FontWeight.w600,
  );

  TextStyle get bodyText => TextStyle(fontSize: _getValue(mobile: 14, tablet: 16, desktop: 18), height: 1.4);

  // 间距系统
  double get spacingXS => _getValue(mobile: 4, tablet: 6, desktop: 8);

  double get spacingSM => _getValue(mobile: 8, tablet: 12, desktop: 16);

  double get spacingMD => _getValue(mobile: 12, tablet: 16, desktop: 20);

  // 组件样式
  TagStyle get tagStyle => TagStyle(
    fontSize: _getValue(mobile: 8, tablet: 10, desktop: 12),
    iconSize: _getValue(mobile: 10, tablet: 12, desktop: 16),
    spacing: _getValue(mobile: 1, tablet: 2, desktop: 4),
    // 其他参数...
  );

  // 响应式值计算
  double _getValue({required double mobile, double? tablet, double? desktop}) {
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

  const TagStyle({required this.fontSize, required this.iconSize, required this.spacing});
}

// 快捷访问扩展
extension ResponsiveStyleExtension on BuildContext {
  ResponsiveStyle responsiveStyle([double? containerWidth]) {
    return ResponsiveStyle.of(this, containerWidth);
  }
}
