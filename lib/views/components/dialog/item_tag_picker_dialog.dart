import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

void showItemTagPickerDialog() {
  final AddEditItemController controller =
      Get.find<AddEditItemController>();
  final ResponsiveStyle style = ResponsiveStyle.to;
  final TextStyle titleTextStyleLG = style.titleTextLG;
  final double spacingMD = style.spacingMD;
  final TextStyle bodyTextStyle = style.bodyText;

  Get.dialog(
    AlertDialog(
      backgroundColor: kPrimaryBgColor,
      title: Text('选择标签', style: titleTextStyleLG),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 设置对话框圆角
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      // 控制对话框与屏幕边缘的内边距
      clipBehavior: Clip.antiAlias,
      // 防止内容超出圆角
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        height: Get.height * 0.7, // 占据屏幕高度的 70% 作为示例
        width: style.dialogWidth, // 占据屏幕宽度的 90%
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child:
              controller.allAvailableTags.isEmpty
                  ? const Center(child: Text('没有可用标签，请先添加标签。'))
                  : ListView.builder(
                    shrinkWrap: true, // 允许ListView根据内容调整大小
                    itemCount: controller.allAvailableTags.length,
                    itemBuilder: (context, index) {
                      final tag = controller.allAvailableTags[index];

                      return Obx(() {
                        final isSelected = controller.selectedTags
                            .any(
                              (selectedTag) =>
                                  selectedTag.id == tag.id,
                            );
                        return CheckboxListTile(
                          checkColor: kIconColor,
                          activeColor: itemIconColor,
                          title: Row(
                            children: [
                              Icon(Icons.bookmark, color: tag.color),
                              SizedBox(width: spacingMD),
                              Expanded(
                                child: Text(
                                  tag.name,
                                  style: bodyTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          tileColor:
                              isSelected
                                  ? tag.color.withOpacity(0.1)
                                  : null,
                          value: isSelected,
                          onChanged: (bool? value) {
                            controller.toggleTag(tag);
                          },
                        );
                      });
                    },
                  ),
        ),
      ),

      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(
            //fixedSize: Size(emojiEditIconWidth, 40),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.check_circle_outline, color: kTextColor),
          label: Text('confirm'.tr, style: bodyTextStyle),
        ),
      ],
    ),
  );
}
