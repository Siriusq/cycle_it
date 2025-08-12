import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditItemAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AddEditItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      titleSpacing: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
      // 标题
      title: Center(
        child: Text(
          controller.isEditing ? 'edit_item'.tr : 'add_new_item'.tr,
          style: titleLG,
        ),
      ),
      // AppBar底部的分割线
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 0),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () => _saveAndGoBack(controller), // 保存
        ),
        const SizedBox(width: 8),
      ],
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
      // 如果是名称相关的错误（已在 TextFormField 中显示），则不显示 Snackbar
      if (message == 'item_name_empty' ||
          message == 'item_name_too_long') {
        return;
      } else {
        // 其他类型的错误（例如 emoji_empty 或通用操作失败）
        Get.snackbar('错误'.tr, message);
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(57); // AppBar 默认高度 + 分割线
}
