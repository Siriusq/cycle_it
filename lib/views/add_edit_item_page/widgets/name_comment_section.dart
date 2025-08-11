import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';

class NameCommentSection extends StatelessWidget {
  const NameCommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final TextStyle bodyLG =
        Theme.of(context).textTheme.bodyLarge!.useSystemChineseFont();

    return Column(
      spacing: 12,
      children: [
        // 物品名称
        Obx(() {
          return TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'item_name'.tr,
              labelStyle: bodyLG,
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
        // 注释
        TextFormField(
          controller: controller.usageCommentController,
          decoration: InputDecoration(
            labelText: 'item_comment'.tr,
            labelStyle: bodyLG,
            border: const OutlineInputBorder(),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
