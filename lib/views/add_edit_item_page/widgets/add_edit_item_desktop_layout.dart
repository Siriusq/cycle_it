import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/responsive_style.dart';

class AddEditItemDesktopLayout extends StatelessWidget {
  final Widget mainContent; // 主要内容 Widget

  const AddEditItemDesktopLayout({
    super.key,
    required this.mainContent,
  });

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final double maxFormWidth =
        ResponsiveStyle.to.desktopFormMaxWidth;
    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxFormWidth),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(15),
              color:
                  Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            controller.isEditing
                                ? 'edit_item'.tr
                                : 'add_new_item'.tr,
                            style: titleLG,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_outlined),
                        onPressed:
                            () => _saveAndGoBack(controller), // 保存
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                mainContent, // 主要内容 Widget
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 保存物品并返回
  Future<void> _saveAndGoBack(
    AddEditItemController controller,
  ) async {
    final String? message = await controller.saveItem();
    if (message == null) {
      // 成功保存
      final String savedItemName =
          controller.nameController.text.trim();
      final String actionText =
          controller.isEditing ? 'update'.tr : 'add'.tr;
      Get.back(
        result: {
          'success': true,
          'message': 'item_changed_successfully'.trParams({
            'name': savedItemName,
            'action': actionText,
          }),
        },
      );
    } else {
      // 存在错误
      // 如果是名称相关的错误（已在 TextFormField 中显示），则不显示 Snack bar
      if (message == 'item_name_empty' ||
          message == 'item_name_too_long') {
        return;
      } else {
        // 其他类型的错误（例如 emoji_empty 或通用操作失败）
        Get.snackbar('error'.tr, message);
      }
    }
  }
}
