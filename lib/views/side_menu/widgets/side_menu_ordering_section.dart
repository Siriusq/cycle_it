import 'package:flutter/material.dart';

import '../../../controllers/item_list_order_controller.dart';
import '../../../utils/responsive_style.dart';
import 'order_by_option.dart';

class SideMenuOrderingSection extends StatelessWidget {
  const SideMenuOrderingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingXS = style.spacingXS;
    final double spacingLG = style.spacingLG;
    final TextStyle titleTextMD = style.titleTextMD;

    return Padding(
      padding: EdgeInsets.all(spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sort),
              const SizedBox(width: 5),
              Text("Order By", style: titleTextMD),
            ],
          ),
          SizedBox(height: spacingXS),
          OrderByOption(
            orderType: OrderType.name,
            icon: Icons.sort_by_alpha,
            title: "Names",
          ),
          OrderByOption(
            orderType: OrderType.lastUsed,
            icon: Icons.event,
            title: "Recent Used",
          ),
          OrderByOption(
            orderType: OrderType.frequency,
            icon: Icons.equalizer,
            title: "Frequency",
          ),
        ],
      ),
    );
  }
}
