import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/constants.dart';
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
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: '物品名称',
            labelStyle: bodyTextLG,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: kSelectedBorderColor,
                width: 2.0,
              ),
            ),
          ),
          maxLength: 50,
        ),
        SizedBox(height: spacingMD),
        TextFormField(
          controller: controller.usageCommentController,
          decoration: InputDecoration(
            labelText: '使用注释 (可选)',
            labelStyle: bodyTextLG,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: kSelectedBorderColor,
                width: 2.0,
              ),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
