import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/tag_controller.dart';
import '../../../models/tag_model.dart';
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

    final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;

    return PopupMenuButton<String>(
      tooltip: 'more_action'.tr,
      icon: Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'edit') {
          _showAddEditTagDialog(tag: tag); // 编辑标签
        } else if (value == 'delete') {
          final bool? confirmed = await showDeleteConfirmDialog(
            deleteTargetName: tag.name,
          );
          final String confirmMessage = 'tag_deleted_successfully'
              .trParams({'name': tag.name}); // 删除确认消息
          if (confirmed == true) {
            await controller.removeTag(tag.id); // 调用删除方法
            Get.snackbar(
              'deleted_successfully'.tr,
              confirmMessage,
              duration: const Duration(seconds: 1),
            ); // 弹出删除成功提示
          }
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.edit),
                  Text('edit'.tr, style: bodyMD),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  Text(
                    'delete'.tr,
                    style: bodyMD.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
