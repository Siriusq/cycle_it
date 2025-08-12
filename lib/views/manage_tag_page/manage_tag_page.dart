import 'package:cycle_it/models/tag_model.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/add_edit_tag_dialog.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/manage_tag_desktop_body.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/manage_tag_mobile_app_bar.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/tag_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageTagPage extends StatelessWidget {
  const ManageTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 判断宽窄布局
    final bool isNarrowLayout = ResponsiveLayout.isNarrowLayout(
      context,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return isNarrowLayout
            ? Scaffold(
              appBar: ManageTagMobileAppBar(
                onAddTag: _showAddEditTagDialog,
              ),
              body: SizedBox(
                child: SafeArea(child: const TagListView()),
              ),
            )
            : Scaffold(
              body: SizedBox(
                child: SafeArea(
                  child: ManageTagDesktopBody(
                    onAddTag: _showAddEditTagDialog,
                  ),
                ),
              ),
            );
      },
    );
  }

  // 显示添加/编辑标签对话框
  void _showAddEditTagDialog({TagModel? tag}) {
    Get.dialog(AddEditTagDialog(tagToEdit: tag)).then((result) {
      if (result != null && result['success'] == true) {
        Get.snackbar(
          'success'.tr, // 成功提示
          result['message'], // 消息内容
          duration: const Duration(seconds: 1),
        );
      }
    });
  }
}
