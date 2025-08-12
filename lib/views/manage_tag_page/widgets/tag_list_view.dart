import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/tag_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 标签列表
class TagListView extends StatelessWidget {
  const TagListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TagController controller = Get.find<TagController>();

    final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;
    final double spacingMD = ResponsiveStyle.to.spacingMD;
    final double spacingLG = ResponsiveStyle.to.spacingLG;

    return Obx(() {
      if (controller.allTags.isEmpty) {
        return Center(child: Text('add_tag_hint'.tr, style: bodyMD));
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: spacingLG,
          vertical: spacingMD,
        ),
        itemCount: controller.allTags.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.allTags.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text('reached_end_hint'.tr, style: bodyMD),
              ),
            );
          }
          final tag = controller.allTags[index];
          return TagCard(tag: tag); // 使用新的 TagCard Widget
        },
      );
    });
  }
}
