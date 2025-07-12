import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/tag_controller.dart';
import '../../../utils/responsive_style.dart';
import 'tag_card.dart';

class TagListView extends StatelessWidget {
  const TagListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TagController controller = Get.find<TagController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingMD = style.spacingMD;
    final double spacingSM = style.spacingSM;
    final bool isMobileDevice = style.isMobileDevice;
    final double horizontalPadding =
        isMobileDevice ? spacingSM : 0; // 移动端有横向padding

    return Obx(() {
      if (controller.allTags.isEmpty) {
        return Center(
          child: Text('暂无标签，点击右上角添加新标签。', style: bodyTextStyle),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          spacingSM,
          horizontalPadding,
          0,
        ),
        itemCount: controller.allTags.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.allTags.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: spacingMD),
              child: Center(
                child: Text('—— 已经到底了 ——', style: bodyTextStyle),
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
