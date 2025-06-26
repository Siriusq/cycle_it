import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/tag_model.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_style.dart';
import 'dialog/add_edit_tag_dialog.dart';
import 'dialog/delete_confirm_dialog.dart';

class ManageTagPage extends StatelessWidget {
  const ManageTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TagController controller = Get.find<TagController>();
    final ItemService itemService = Get.find<ItemService>();

    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextStyleLG = style.titleTextLG;
    final double spacingMD = style.spacingMD;
    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingSM = style.spacingSM;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double maxFormWidth = style.desktopFormMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'tag_management'.tr,
            style: largeTitleTextStyle.copyWith(
              color: kTitleTextColor,
            ), // 确保标题颜色正确
          ),
        ),
        // 分割线
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 分割线的高度
          child: Container(
            color: Colors.grey, // 分割线的颜色
            height: 1.0, // 再次指定高度，确保可见
          ),
        ),
        // 返回按钮
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Get.back(),
        ),
        // 添加按钮
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditTagDialog(), // 点击加号添加新标签
          ),
          SizedBox(width: spacingSM),
        ],
      ),

      backgroundColor: kPrimaryBgColor,

      body: Obx(() {
        if (controller.allTags.isEmpty) {
          return Center(
            child: Text(
              '暂无标签，点击右上角添加新标签。', // 使用中文
              style: bodyTextStyle,
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(spacingSM),
          itemCount: controller.allTags.length,
          itemBuilder: (context, index) {
            final tag = controller.allTags[index];
            return Card(
              color: kSecondaryBgColor,
              margin: EdgeInsets.symmetric(vertical: spacingSM / 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: spacingSM),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tag.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(tag.name, style: bodyTextStyle),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: kTextColor),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        _showAddEditTagDialog(tag: tag);
                      } else if (value == 'delete') {
                        final bool? confirmed =
                            await showDeleteConfirmDialog(
                              context: context,
                              deleteTargetName: tag.name,
                            );
                        final String confirmMessage =
                            '标签 ${tag.name} 已删除！';
                        if (confirmed == true) {
                          await controller.removeTag(
                            tag.id,
                          ); // 调用删除方法
                          Get.snackbar('删除成功', confirmMessage);
                        }
                      }
                    },
                    itemBuilder:
                        (
                          BuildContext context,
                        ) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: kTextColor),
                                SizedBox(width: spacingSM),
                                Text(
                                  '编辑',
                                  style: bodyTextStyle,
                                ), // 使用中文
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: spacingSM),
                                Text(
                                  '删除',
                                  style: bodyTextStyle.copyWith(
                                    color: Colors.red,
                                  ),
                                ), // 使用中文
                              ],
                            ),
                          ),
                        ],
                    color: kPrimaryBgColor,
                    // 设置弹出菜单的背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // 显示添加/编辑标签对话框
  void _showAddEditTagDialog({TagModel? tag}) {
    Get.dialog(
      AddEditTagDialog(tagToEdit: tag),
      barrierDismissible: false, // 不允许点击外部关闭
    ).then((result) {
      if (result != null && result['success'] == true) {
        Get.snackbar(
          'success'.tr, // 使用中文
          result['message'],
        );
      }
    });
  }
}
