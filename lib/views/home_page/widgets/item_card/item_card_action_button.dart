import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/item_controller.dart';
import '../../../../models/item_model.dart';
import '../../../shared_widgets/date_picker_helper.dart';
import '../../../shared_widgets/delete_confirm_dialog.dart';

class ItemCardActionButton extends StatelessWidget {
  final ItemModel item;

  const ItemCardActionButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();

    final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;

    return PopupMenuButton<String>(
      tooltip: 'more_action'.tr,
      onSelected:
          (value) => _handleAction(context, value, itemCtrl, item),
      itemBuilder:
          (_) => [
            PopupMenuItem(
              value: 'cycle',
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.refresh),
                  Text('cycle'.tr, style: bodyMD),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                spacing: 8,
                children: [
                  const Icon(Icons.edit),
                  Text('edit'.tr, style: bodyMD),
                ],
              ),
            ),
            PopupMenuItem(
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

  Future<void> _handleAction(
    BuildContext context,
    String value,
    ItemController itemCtrl,
    ItemModel item,
  ) async {
    if (value == 'cycle') {
      final DateTime? pickedDate = await promptForDateSelection(
        DateTime.now(),
      );
      if (pickedDate != null) {
        itemCtrl.addUsageRecordFast(item.id!, pickedDate);
        Get.snackbar(
          'success'.tr,
          'usage_record_added_hint'.trParams({
            'record': DateFormat('yyyy-MM-dd').format(pickedDate),
            'item': item.name,
          }),
          duration: const Duration(seconds: 1),
        );
      }
    } else if (value == 'edit') {
      final result = await Get.toNamed(
        '/AddEditItem',
        arguments: item,
      );
      if (result != null && result['success']) {
        Get.snackbar(
          'success'.tr,
          '${result['message']}',
          duration: const Duration(seconds: 1),
        );
      }
    } else if (value == 'delete') {
      final bool? confirmed = await showDeleteConfirmDialog(
        deleteTargetName: item.name,
      );
      final String confirmMessage = 'item_changed_successfully'
          .trParams({'name': item.name, 'action': 'delete'.tr});
      if (confirmed == true) {
        itemCtrl.deleteItem(item.id!);
        Get.snackbar(
          'success'.tr,
          confirmMessage,
          duration: const Duration(seconds: 1),
        );
      }
    }
  }
}
