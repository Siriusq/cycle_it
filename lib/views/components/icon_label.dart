import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const IconLabel({super.key, required this.icon, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 16, color: iconColor),
            SizedBox(width: 4),
            Text(label, style: TextStyle(color: kTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
