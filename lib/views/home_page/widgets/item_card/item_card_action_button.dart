import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/item_controller.dart';
import '../../../../models/item_model.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_style.dart';
import '../../../shared_widgets/date_picker_helper.dart';
import '../../../shared_widgets/delete_confirm_dialog.dart';

class ItemCardActionButton extends StatelessWidget {
  final ItemModel item;
  const ItemCardActionButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingSM = style.spacingSM;
    final TextStyle bodyTextStyle = style.bodyText;

    return PopupMenuButton<String>(
      color: kSecondaryBgColor,
      tooltip: 'More Action',
      onSelected:
          (value) => _handleAction(context, value, itemCtrl, item),
      itemBuilder:
          (_) => [
            PopupMenuItem(
              value: 'cycle',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: itemIconColor),
                  SizedBox(width: spacingSM),
                  Text(
                    'cycle'.tr,
                    style: bodyTextStyle.copyWith(
                      color: itemIconColor,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: kTextColor),
                  SizedBox(width: spacingSM),
                  Text('edit'.tr, style: bodyTextStyle),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: spacingSM),
                  Text(
                    'delete'.tr,
                    style: bodyTextStyle.copyWith(color: Colors.red),
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
      final DateTime? pickedDate = await promptForUsageDate(
        DateTime.now(),
      );
      if (pickedDate != null) {
        Get.back();
        itemCtrl.addUsageRecord(pickedDate);
        Get.snackbar(
          '添加成功',
          '添加使用记录 ${DateFormat('yyyy-MM-dd').format(pickedDate)} 到物品 ${item.name}',
        );
      }
    } else if (value == 'edit') {
      final result = await Get.toNamed(
        '/AddEditItem',
        arguments: item,
      );
      if (result != null && result['success']) {
        Get.snackbar('成功', '${result['message']}');
      }
    } else if (value == 'delete') {
      final bool? confirmed = await showDeleteConfirmDialog(
        deleteTargetName: item.name,
      );
      final String confirmMessage = '物品 ${item.name} 已删除！';
      if (confirmed == true) {
        itemCtrl.deleteItem(item.id!);
        Get.snackbar('删除成功', confirmMessage);
      }
    }
  }
}
