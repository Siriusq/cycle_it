import 'package:flutter/material.dart';

class ResponsiveComponentGroup extends StatelessWidget {
  final double minComponentWidth;
  final List<Widget> children;
  final double spacing;

  const ResponsiveComponentGroup({
    super.key,
    required this.minComponentWidth,
    required this.children,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;

        // 计算每行最多显示多少个组件（考虑间距）
        final crossAxisCount = ((parentWidth + spacing) / (minComponentWidth + spacing)).floor();
        final validCount = crossAxisCount.clamp(1, children.length);

        // 计算实际子项宽度
        final childWidth = (parentWidth - (validCount - 1) * spacing) / validCount;

        return GridView.builder(
          shrinkWrap: true, // 高度自适应内容
          physics: const NeverScrollableScrollPhysics(), // 禁止滚动
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: validCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 3 / 2, // 根据实际需求调整宽高比
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => SizedBox(width: childWidth, child: children[index]),
        );
      },
    );
  }
}
