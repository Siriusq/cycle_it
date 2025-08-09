import 'package:flutter/material.dart';

// 标签组件
class IconLabel extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isLarge;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = isLarge ? 18 : 14;
    final TextStyle labelStyle =
        isLarge
            ? Theme.of(context).textTheme.bodyMedium!
            : Theme.of(context).textTheme.bodySmall!;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 2,
          children: [
            Icon(icon, size: iconSize, color: iconColor),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
