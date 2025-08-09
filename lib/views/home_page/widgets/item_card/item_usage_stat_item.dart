import 'package:flutter/material.dart';

class ItemUsageStatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ItemUsageStatItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle bodySM = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(height: 1.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            // 图标部分
            Icon(icon, size: 18),

            // 文字部分
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  // 标题
                  Text(
                    title,
                    style: bodySM,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),

                  // 数值
                  Text(
                    value,
                    style: bodySM,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
