import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showDeleteConfirmDialog({
  required String deleteTargetName,
}) async {
  final TextStyle titleLG =
      Theme.of(
        Get.context!,
      ).textTheme.titleLarge!.useSystemChineseFont();
  final TextStyle bodyLG =
      Theme.of(
        Get.context!,
      ).textTheme.bodyLarge!.useSystemChineseFont();

  return await Get.dialog<bool?>(
    AlertDialog(
      title: Text(
        'delete_confirm'.tr,
        style: titleLG,
        overflow: TextOverflow.visible,
      ),
      content: Text(
        'are_you_sure_to_delete'.trParams({
          'target': deleteTargetName,
        }),
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        // 取消按钮
        TextButton.icon(
          onPressed: () {
            Get.back(result: false);
          },
          icon: const Icon(Icons.cancel),
          label: Text('cancel'.tr, style: bodyLG),
        ),
        // 删除按钮
        TextButton.icon(
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          label: Text(
            'delete'.tr,
            style: bodyLG.copyWith(color: Colors.red),
          ),
        ),
      ],
      // 应用圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );
}
