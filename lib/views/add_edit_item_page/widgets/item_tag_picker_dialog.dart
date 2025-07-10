import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../manage_tag_page/widgets/add_edit_tag_dialog.dart';

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
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias,
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        height: Get.height * 0.7, // 占据屏幕高度的 70%
        width: style.dialogWidth, // 占据屏幕宽度的 90%
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() {
            final bool noAvailableTags =
                controller.allAvailableTags.isEmpty;

            if (noAvailableTags) {
              // 当没有可用标签时，只显示“添加标签”按钮，并居中显示
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(spacingMD),
                    child: Text(
                      '没有可用标签，请先添加标签。',
                      style: bodyTextStyle,
                    ),
                  ),
                  SizedBox(height: spacingMD),
                  _buildAddTagButton(style, controller),
                ],
              );
            } else {
              return Material(
                color: kPrimaryBgColor,
                borderRadius: BorderRadius.circular(8.0),
                child: ListView.builder(
                  // itemCount 增加 1，用于“添加标签”行
                  itemCount: controller.allAvailableTags.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 第一行，用于“添加标签”
                      return _buildAddTagListTile(
                        context,
                        style,
                        controller,
                      );
                    } else {
                      // 实际的标签项
                      final tag =
                          controller.allAvailableTags[index -
                              1]; // 索引偏移

                      return Obx(() {
                        final isSelected = controller.selectedTags
                            .any(
                              (selectedTag) =>
                                  selectedTag.id == tag.id,
                            );
                        return CheckboxListTile(
                          checkColor: tag.color,
                          activeColor: Colors.transparent,
                          side: BorderSide(
                            color: kGrayColor,
                            width: 1,
                          ),
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
                                  ? tag.color.withAlpha(10)
                                  : null,
                          value: isSelected,
                          onChanged: (bool? value) {
                            controller.toggleTag(tag);
                          },
                        );
                      });
                    }
                  },
                ),
              );
            }
          }),
        ),
      ),

      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.back(); // 关闭当前显示的 SnackBar
            }
            Get.back();
          },
          icon: Icon(Icons.check_circle_outline, color: kTextColor),
          label: Text('confirm'.tr, style: bodyTextStyle),
        ),
      ],
    ),
  );
}

// 添加标签的 ListTile
Widget _buildAddTagListTile(
  BuildContext context,
  ResponsiveStyle style,
  AddEditItemController controller,
) {
  final TextStyle bodyTextStyle = style.bodyText;

  return ListTile(
    leading: Icon(Icons.bookmark_add, color: kGrayColor),
    // 添加图标
    title: Text(
      '添加新标签',
      style: bodyTextStyle.copyWith(
        fontWeight: FontWeight.bold, // 可以加粗
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_outlined,
      color: kTextColor.withValues(alpha: 0.6),
    ),
    //    小箭头
    onTap: () async {
      // 调用打开添加标签 Dialog 的方法
      final result = await Get.dialog(AddEditTagDialog());
      if (result != null && result['success']) {
        Get.snackbar(
          'success'.tr,
          '${result['message']}',
          duration: Duration(seconds: 1),
        );
      }
    },
    tileColor: kGrayColor.withValues(alpha: 0.1),
  );
}

// 添加标签的按钮（用于没有可用标签时的空状态）
Widget _buildAddTagButton(
  ResponsiveStyle style,
  AddEditItemController controller,
) {
  final double spacingMD = style.spacingMD;
  final TextStyle bodyTextStyle = style.bodyTextLG;

  return ElevatedButton.icon(
    onPressed: () {
      Get.dialog(AddEditTagDialog());
    },
    icon: Icon(Icons.bookmark_add_outlined, color: kTextColor),
    label: Text('添加标签', style: bodyTextStyle),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(spacingMD),
      backgroundColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
