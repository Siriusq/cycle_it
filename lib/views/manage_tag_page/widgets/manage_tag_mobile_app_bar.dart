import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';

class ManageTagMobileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onAddTag; // 用于触发添加标签对话框的回调

  const ManageTagMobileAppBar({super.key, required this.onAddTag});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;

    return AppBar(
      title: Center(
        child: Text(
          'tag_management'.tr, // 标签管理标题
          style: style.titleTextEX,
        ),
      ),
      // AppBar底部的分割线
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Divider(),
      ),
      // 返回按钮
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      // 添加按钮
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAddTag, // 调用传入的回调
        ),
        SizedBox(width: style.spacingSM),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 1.0); // 加上 bottom 的高度
}
