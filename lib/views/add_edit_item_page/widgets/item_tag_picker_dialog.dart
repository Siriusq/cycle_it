import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../manage_tag_page/widgets/add_edit_tag_dialog.dart';

void showItemTagPickerDialog(BuildContext context) {
  final AddEditItemController controller =
      Get.find<AddEditItemController>();
  final TextStyle titleLG =
      Theme.of(context).textTheme.titleLarge!.useSystemChineseFont();
  final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;

  Get.dialog(
    AlertDialog(
      title: Text('select_tag'.tr, style: titleLG),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias,
      contentPadding: const EdgeInsets.all(16.0),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: Get.height * 0.7, // 占据屏幕高度的 70%
            width: ResponsiveStyle.to.dialogWidth, // 占据屏幕宽度的 90%
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Obx(() {
                final bool noAvailableTags =
                    controller.allAvailableTags.isEmpty;

                if (noAvailableTags) {
                  // 当没有可用标签时，只显示“添加标签”按钮，并居中显示
                  return Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('no_tag_hint'.tr, style: bodyMD),
                      ),
                      _buildAddTagButton(context),
                    ],
                  );
                } else {
                  return Material(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8.0),
                    child: ListView.builder(
                      // itemCount 增加 1，用于“添加标签”行
                      itemCount:
                          controller.allAvailableTags.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // 第一行，用于“添加标签”
                          return _buildAddTagListTile(context);
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
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                width: 1,
                              ),
                              title: Row(
                                spacing: 8,
                                children: [
                                  Icon(
                                    Icons.bookmark,
                                    color: tag.color,
                                  ),
                                  Expanded(
                                    child: Text(
                                      tag.name,
                                      style: bodyMD,
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
          );
        },
      ),

      actions: [
        TextButton.icon(
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.back(); // 关闭当前显示的 SnackBar
            }
            Get.back();
          },
          icon: const Icon(Icons.check),
          label: Text('confirm'.tr),
        ),
      ],
    ),
  );
}

// 添加标签的 ListTile
Widget _buildAddTagListTile(BuildContext context) {
  final TextStyle titleMD =
      Theme.of(context).textTheme.titleMedium!.useSystemChineseFont();

  return ListTile(
    leading: Icon(
      Icons.bookmark_add,
      color: Theme.of(context).colorScheme.primary,
    ),
    // 添加图标
    title: Text(
      'add_new_tag'.tr,
      style: titleMD.copyWith(
        fontWeight: FontWeight.w500, // 可以加粗
      ),
    ),
    trailing: const Padding(
      padding: EdgeInsets.only(right: 6.0),
      child: Icon(Icons.arrow_forward_outlined),
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
  );
}

// 添加标签的按钮（用于没有可用标签时的空状态）
Widget _buildAddTagButton(BuildContext context) {
  final TextStyle bodyLG = Theme.of(context).textTheme.bodyLarge!;

  return ElevatedButton.icon(
    onPressed: () async {
      // 调用打开添加标签 Dialog 的方法
      final result = await Get.dialog(AddEditTagDialog());
      if (result != null && result['success']) {
        Get.snackbar(
          'success'.tr,
          '${result['message']}',
          duration: const Duration(seconds: 1),
        );
      }
    },
    icon: const Icon(Icons.bookmark_add_outlined),
    label: Text('add_new_tag'.tr, style: bodyLG),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
