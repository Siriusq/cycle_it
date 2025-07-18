import 'package:flutter/material.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../utils/responsive_style.dart';
import '../../shared_widgets/icon_label.dart';

class DetailsItemTags extends StatelessWidget {
  const DetailsItemTags({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingXS = style.spacingXS;

    return Padding(
      padding: EdgeInsets.only(top: spacingXS, left: 2),
      child: Obx(() {
        final ItemModel? currentItem = itemCtrl.currentItem.value;
        if (currentItem == null) {
          return const SizedBox.shrink(); // 如果物品为空，不显示此部分
        }

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 5,
            children:
                currentItem.tags.map((tag) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                    ),
                    child: IconLabel(
                      icon: Icons.bookmark,
                      label: tag.name,
                      iconColor: tag.color,
                      isLarge: true,
                    ),
                  );
                }).toList(),
          ),
        );
      }),
    );
  }
}
