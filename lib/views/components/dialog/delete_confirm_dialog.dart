import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showDeleteConfirmDialog({
  required BuildContext context,
  required String deleteTargetName,
}) async {
  final style = ResponsiveStyle.to;
  final double spacingMD = style.spacingMD;
  final TextStyle bodyTextLG = style.bodyTextLG;

  return await showDialog<bool?>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // 对话框的背景颜色
        backgroundColor: kPrimaryBgColor,
        // 对话框的标题
        // title: const Text(
        //   '删除',
        //   style: TextStyle(color: kTextColor), // 标题文本颜色
        // ),
        // 对话框的内容
        content: Text(
          '确定要删除 $deleteTargetName 吗？',
          style: const TextStyle(color: kTextColor), // 内容文本颜色
        ),
        // 对话框底部的操作按钮
        actions: <Widget>[
          // 取消按钮
          TextButton.icon(
            onPressed: () {
              // 关闭对话框并返回false，表示取消删除
              Navigator.of(dialogContext).pop(false);
            },
            style: TextButton.styleFrom(
              minimumSize: Size(60, 0),
              padding: EdgeInsets.all(spacingMD),
              backgroundColor: kSecondaryBgColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: kGrayColor, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(Icons.cancel_outlined, color: kTextColor),
            label: Text('cancel'.tr, style: bodyTextLG),
          ),
          // 删除按钮
          TextButton.icon(
            onPressed: () {
              // 关闭对话框并返回true，表示确认删除
              Navigator.of(dialogContext).pop(true);
            },
            style: TextButton.styleFrom(
              minimumSize: Size(60, 0),
              padding: EdgeInsets.all(spacingMD),
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(Icons.delete, color: kTextColor),
            label: Text('delete'.tr, style: bodyTextLG),
          ),
        ],
        // 应用圆角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      );
    },
  );
}
