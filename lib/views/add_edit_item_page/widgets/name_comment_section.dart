import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/responsive_style.dart';

class NameCommentSection extends StatelessWidget {
  const NameCommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingMD = style.spacingMD;
    final TextStyle bodyTextLG = style.bodyTextLG;

    return Column(
      children: [
        // 需要修改的文本输入框
        Obx(() {
          return TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'item_name'.tr,
              labelStyle: bodyTextLG,
              border: const OutlineInputBorder(),
              errorText:
                  controller.nameErrorText.value.isEmpty
                      ? null
                      : controller.nameErrorText.value,
            ),
            maxLength: 50,
            onChanged: (_) {
              if (controller.nameErrorText.value.isNotEmpty) {
                controller.nameErrorText.value = '';
              }
            },
          );
        }),
        SizedBox(height: spacingMD),
        TextFormField(
          controller: controller.usageCommentController,
          decoration: InputDecoration(
            labelText: 'item_comment'.tr,
            labelStyle: bodyTextLG,
            border: const OutlineInputBorder(),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
