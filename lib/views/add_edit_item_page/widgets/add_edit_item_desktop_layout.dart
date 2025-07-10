import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

class AddEditItemDesktopLayout extends StatelessWidget {
  final Widget mainContent; // 主要内容 Widget

  const AddEditItemDesktopLayout({
    super.key,
    required this.mainContent,
  });

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double maxFormWidth = style.desktopFormMaxWidth;

    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxFormWidth),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: kBorderColor, width: 1),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacingSM,
                    vertical: spacingMD,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: kTextColor,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            controller.isEditing ? "编辑物品" : "添加物品",
                            style: largeTitleTextStyle,
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
                Container(color: kBorderColor, height: 2.0),
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
}
