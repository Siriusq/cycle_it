import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_list_order_controller.dart';
import '../../../utils/responsive_style.dart';
import 'order_by_option.dart';

class SideMenuOrderingSection extends StatelessWidget {
  const SideMenuOrderingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double spacingLG = ResponsiveStyle.to.spacingLG;
    final TextStyle titleMD =
        Theme.of(context).textTheme.titleMedium!;

    return Padding(
      padding: EdgeInsets.all(spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sort),
              const SizedBox(width: 5),
              Text('order_by'.tr, style: titleMD),
            ],
          ),
          const SizedBox(height: 4),
          OrderByOption(
            orderType: OrderType.name,
            icon: Icons.sort_by_alpha,
            title: 'order_by_names'.tr,
          ),
          OrderByOption(
            orderType: OrderType.lastUsed,
            icon: Icons.event,
            title: 'order_by_recent_used_time'.tr,
          ),
          OrderByOption(
            orderType: OrderType.frequency,
            icon: Icons.equalizer,
            title: 'order_by_frequency'.tr,
          ),
        ],
      ),
    );
  }
}
