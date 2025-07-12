import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/responsive_style.dart';

class AddEditItemAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AddEditItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double spacingSM = style.spacingSM;

    return AppBar(
      title: Center(
        child: Text(
          controller.isEditing ? "编辑物品" : "添加物品",
          style: largeTitleTextStyle,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
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
        SizedBox(width: spacingSM),
      ],
    );
  }

  // 保存物品并返回
  Future<void> _saveAndGoBack(
    AddEditItemController controller,
  ) async {
    final message = await controller.saveItem();
    if (message == '') {
      final String savedItemName =
          controller.nameController.text.trim();
      final String actionText = controller.isEditing ? '更新' : '添加';
      Get.back(
        result: {
          'success': true,
          'message': '$savedItemName $actionText成功！',
        },
      );
    } else if (message == 'item_name_empty') {
      Get.snackbar('错误', '物品名称不能为空');
    } else if (message == 'item_name_too_long') {
      Get.snackbar('错误', '物品名称不能超过50个字符');
    } else if (message == 'emoji_empty') {
      Get.snackbar('错误', '物品图标不能为空');
    } else {
      Get.snackbar('错误', message);
    }
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 1.0); // AppBar 默认高度 + 分割线
}
