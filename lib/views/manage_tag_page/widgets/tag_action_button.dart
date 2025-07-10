import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/tag_controller.dart';
import '../../../models/tag_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';
import '../../shared_widgets/delete_confirm_dialog.dart';
import 'add_edit_tag_dialog.dart';

class TagActionButton extends StatelessWidget {
  final TagModel tag;

  const TagActionButton({super.key, required this.tag});

  void _showAddEditTagDialog({TagModel? tag}) {
    Get.dialog(AddEditTagDialog(tagToEdit: tag)).then((result) {
      if (result != null && result['success'] == true) {
        Get.snackbar(
          'success'.tr,
          result['message'],
          duration: const Duration(seconds: 1),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TagController controller = Get.find<TagController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingSM = style.spacingSM;
    final double iconSizeMD = style.iconSizeMD;
    final TextStyle bodyTextStyle = style.bodyText;

    return PopupMenuButton<String>(
      color: kSecondaryBgColor,
      tooltip: 'More Action',
      icon: Icon(
        Icons.more_vert,
        color: kTextColor,
        size: iconSizeMD,
      ),
      onSelected: (value) async {
        if (value == 'edit') {
          _showAddEditTagDialog(tag: tag); // 编辑标签
        } else if (value == 'delete') {
          final bool? confirmed = await showDeleteConfirmDialog(
            deleteTargetName: tag.name,
          );
          final String confirmMessage =
              '标签 ${tag.name} 已删除！'; // 删除确认消息
          if (confirmed == true) {
            await controller.removeTag(tag.id); // 调用删除方法
            Get.snackbar('删除成功', confirmMessage); // 弹出删除成功提示
          }
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: kTextColor),
                  SizedBox(width: spacingSM),
                  Text('编辑', style: bodyTextStyle),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: spacingSM),
                  Text(
                    '删除',
                    style: bodyTextStyle.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
