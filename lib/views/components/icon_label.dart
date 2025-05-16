import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const IconLabel({super.key, required this.icon, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final style = context.responsiveStyle().tagStyle;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: style.spacing * 2, vertical: style.spacing * 0.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: style.iconSize, color: iconColor),
            SizedBox(width: style.spacing * 0.5),
            Text(label, style: TextStyle(color: kTextColor, fontSize: style.fontSize, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
