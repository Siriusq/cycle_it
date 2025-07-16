import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showDeleteConfirmDialog({
  required String deleteTargetName,
}) async {
  final style = ResponsiveStyle.to;
  final TextStyle bodyTextLG = style.bodyTextLG;

  return await Get.dialog<bool?>(
    AlertDialog(
      title: Text('delete_confirm'.tr),
      content: Text(
        'are_you_sure_to_delete'.trParams({
          'target': deleteTargetName,
        }),
        style: bodyTextLG,
      ),
      actions: <Widget>[
        // 取消按钮
        TextButton.icon(
          onPressed: () {
            Get.back(result: false);
          },
          icon: const Icon(Icons.cancel),
          label: Text('cancel'.tr, style: bodyTextLG),
        ),
        // 删除按钮
        TextButton.icon(
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          label: Text(
            'delete'.tr,
            style: bodyTextLG.copyWith(color: Colors.red),
          ),
        ),
      ],
      // 应用圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  );
}
