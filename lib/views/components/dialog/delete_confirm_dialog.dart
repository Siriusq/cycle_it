import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';

// 确认删除对话框。
Future<bool?> showDeleteConfirmDialog({
  required String deleteTargetName,
}) async {
  // 获取响应式样式实例
  final style = ResponsiveStyle.to;
  final double spacingMD = style.spacingMD;
  final TextStyle bodyTextLG = style.bodyTextLG;

  return await Get.dialog<bool?>(
    AlertDialog(
      // 对话框的背景颜色
      backgroundColor: kPrimaryBgColor,
      // 对话框的内容
      content: Text('确定要删除 $deleteTargetName 吗？', style: bodyTextLG),
      // 对话框底部的操作按钮
      actions: <Widget>[
        // 取消按钮
        TextButton.icon(
          onPressed: () {
            // 关闭对话框并返回false，表示取消删除
            Get.back(result: false);
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(60, 0),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.cancel_outlined, color: kTextColor),
          label: Text('cancel'.tr, style: bodyTextLG),
        ),
        // 删除按钮
        TextButton.icon(
          onPressed: () {
            // 关闭对话框并返回true，表示确认删除
            Get.back(result: true);
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(60, 0),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: kPrimaryColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.delete, color: kTextColor),
          label: Text('delete'.tr, style: bodyTextLG),
        ),
      ],
      // 应用圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );
}
