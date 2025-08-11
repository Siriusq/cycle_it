import 'package:cycle_it/views/manage_tag_page/widgets/manage_tag_desktop_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';
import 'tag_list_view.dart';

class ManageTagDesktopBody extends StatelessWidget {
  final VoidCallback onAddTag;

  const ManageTagDesktopBody({super.key, required this.onAddTag});

  @override
  Widget build(BuildContext context) {
    final double maxFormWidth =
        ResponsiveStyle.to.desktopFormMaxWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxFormWidth,
          maxHeight: Get.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 模拟AppBar
              ManageTagDesktopHeader(
                onAddTag: onAddTag, // 传递添加标签的回调
              ),

              // 标签列表
              const Expanded(child: TagListView()),
            ],
          ),
        ),
      ),
    );
  }
}
