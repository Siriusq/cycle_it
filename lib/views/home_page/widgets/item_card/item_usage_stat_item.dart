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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 图标部分
            Icon(icon, size: 18),
            const SizedBox(width: 6),

            // 文字部分
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, height: 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 数值
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      letterSpacing: -0.3,
                    ),
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
