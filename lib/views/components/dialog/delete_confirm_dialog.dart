import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmDialog({
  required BuildContext context,
  required String deleteTargetName,
}) async {
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
          TextButton(
            onPressed: () {
              // 关闭对话框并返回false，表示取消删除
              Navigator.of(dialogContext).pop(false);
            },
            child: Text(
              '取消',
              style: TextStyle(color: kTextColor), // 取消按钮文本颜色
            ),
          ),
          // 删除按钮
          TextButton(
            onPressed: () {
              // 关闭对话框并返回true，表示确认删除
              Navigator.of(dialogContext).pop(true);
            },
            style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor, // 删除按钮的背景颜色
            ),
            child: const Text(
              '删除',
              style: TextStyle(color: kTextColor), // 删除按钮文本颜色
            ),
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
