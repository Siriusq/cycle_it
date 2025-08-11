import 'package:cycle_it/views/manage_tag_page/widgets/manage_tag_desktop_body.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/manage_tag_mobile_app_bar.dart';
import 'package:cycle_it/views/manage_tag_page/widgets/tag_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/tag_model.dart';
import '../../utils/responsive_style.dart';
import 'widgets/add_edit_tag_dialog.dart';

class ManageTagPage extends StatelessWidget {
  const ManageTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobileDevice = ResponsiveStyle.to.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // 在宽屏幕上不显示默认AppBar
          appBar:
              isMobileDevice
                  ? ManageTagMobileAppBar(
                    onAddTag: _showAddEditTagDialog,
                  )
                  : null,

          body: SizedBox(
            child: SafeArea(
              child:
                  isMobileDevice
                      ? const TagListView()
                      : ManageTagDesktopBody(
                        onAddTag: _showAddEditTagDialog,
                      ),
            ),
          ),

          // 宽屏幕
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
