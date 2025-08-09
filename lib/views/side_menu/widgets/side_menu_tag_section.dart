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

    final double spacingSM = ResponsiveStyle.to.spacingSM;
    final double spacingLG = ResponsiveStyle.to.spacingLG;
    final TextStyle titleMD =
        Theme.of(context).textTheme.titleMedium!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingLG,
        vertical: spacingSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark_outline),
              const SizedBox(width: 5),
              Text('tags'.tr, style: titleMD),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.toNamed('/ManageTag');
                },
                icon: const Icon(Icons.more_horiz),
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
