import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/tag_controller.dart';
import '../../../utils/responsive_style.dart';
import 'tag_option.dart';

class SideMenuTagSection extends StatelessWidget {
  const SideMenuTagSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TagController tagCtrl = Get.find<TagController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingLG = style.spacingLG;
    final double spacingMD = style.spacingMD;
    final TextStyle titleTextMD = style.titleTextMD;
    final double iconSizeMD = style.iconSizeMD;
    final double iconSizeLG = style.iconSizeLG;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingLG,
        vertical: spacingMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark_outline),
              const SizedBox(width: 5),
              Text('tags'.tr, style: titleTextMD),
              const Spacer(),
              SizedBox(
                height: iconSizeLG,
                width: iconSizeLG,
                child: IconButton(
                  iconSize: iconSizeMD,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Get.toNamed('/ManageTag');
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ),
            ],
          ),
          Obx(() {
            return Column(
              children:
                  tagCtrl.allTags.map((tag) {
                    return TagOption(
                      tagName: tag.name,
                      color: tag.color,
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
