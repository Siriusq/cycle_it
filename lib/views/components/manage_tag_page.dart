import 'package:cycle_it/controllers/tag_controller.dart';
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

    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double spacingMD = style.spacingMD;
    final double spacingSM = style.spacingSM;
    final double maxFormWidth =
        style.desktopFormMaxWidth; // 桌面端最大表单宽度
    final bool isMobileDevice = style.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: _buildAppBar(
            style: style,
            isMobileDevice: isMobileDevice,
          ),
          backgroundColor: kPrimaryBgColor, // 背景颜色

          body: Obx(() {
            // 根据屏幕宽度调整布局
            if (isMobileDevice) {
              // 窄屏幕
              return _buildTagListContent(
                controller: controller,
                style: style,
                isMobileDevice: isMobileDevice,
              );
            } else {
              // 宽屏幕
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
                        color: kBorderColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 模拟AppBar
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacingSM,
                            vertical: spacingMD,
                          ), // 间距
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: kTextColor,
                                ), // 返回按钮
                                onPressed: () => Get.back(),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'tag_management'.tr, // 标签管理标题
                                    style: largeTitleTextStyle,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add), // 添加按钮
                                onPressed:
                                    () => _showAddEditTagDialog(),
                              ),
                            ],
                          ),
                        ),
                        // 分割线
                        Container(
                          color: kBorderColor, // 分割线的颜色
                          height: 2.0, // 高度
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacingMD,
                            ),
                            child: _buildTagListContent(
                              // 调用提取的方法
                              controller: controller,
                              style: style,
                              isMobileDevice: isMobileDevice,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        );
      },
    );
  }

  // 显示添加/编辑标签对话框
  void _showAddEditTagDialog({TagModel? tag}) {
    Get.dialog(
      AddEditTagDialog(tagToEdit: tag),
      //barrierDismissible: false, // 不允许点击外部关闭
    ).then((result) {
      if (result != null && result['success'] == true) {
        Get.snackbar(
          'success'.tr, // 成功提示
          result['message'], // 消息内容
          duration: Duration(seconds: 1),
        );
      }
    });
  }

  // 提取AppBar构建逻辑
  AppBar? _buildAppBar({
    required ResponsiveStyle style,
    required bool isMobileDevice,
  }) {
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double spacingSM = style.spacingSM;

    if (!isMobileDevice) {
      return null; // 在宽屏幕上不显示默认AppBar
    }

    return AppBar(
      title: Center(
        child: Text(
          'tag_management'.tr, // 标签管理标题
          style: largeTitleTextStyle.copyWith(
            color: kTitleTextColor, // 确保标题颜色正确
          ),
        ),
      ),
      // AppBar底部的分割线
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
        onPressed: () => Get.back(), // 返回上一页
      ),
      // 添加按钮
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add), // 添加图标
          onPressed: () => _showAddEditTagDialog(), // 点击加号添加新标签
        ),
        SizedBox(width: spacingSM), // 右侧间距
      ],
    );
  }

  // 提取列表内容构建逻辑
  Widget _buildTagListContent({
    required TagController controller,
    required ResponsiveStyle style,
    required bool isMobileDevice,
  }) {
    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final double horizontalSpacing = isMobileDevice ? spacingSM : 0;
    final double iconSizeMD = style.iconSizeMD;

    if (controller.allTags.isEmpty) {
      return Center(
        child: Text(
          '暂无标签，点击右上角添加新标签。', // 无标签提示
          style: bodyTextStyle,
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        horizontalSpacing,
        spacingSM,
        horizontalSpacing,
        0,
      ),
      itemCount: controller.allTags.length + 1, // 标签数量
      itemBuilder: (context, index) {
        if (index == controller.allTags.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: spacingMD),
            child: Center(
              child: Text(
                '—— 已经到底了 ——',
                style: bodyTextStyle.copyWith(color: Colors.grey),
              ),
            ),
          );
        }
        final tag = controller.allTags[index];
        return Card(
          color: kSecondaryBgColor,
          margin: EdgeInsets.symmetric(vertical: spacingSM * 0.5),
          // 垂直间距
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: kBorderColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(
              spacingMD,
              0,
              spacingSM,
              0,
            ),
            leading: Icon(
              Icons.bookmark,
              color: tag.color,
              size: iconSizeMD,
            ),
            title: Text(tag.name, style: bodyTextStyle), // 标签名称
            trailing: PopupMenuButton<String>(
              color: kSecondaryBgColor,
              tooltip: 'More Action',
              icon: Icon(
                Icons.more_vert,
                color: kTextColor,
                size: iconSizeMD,
              ),
              // 更多操作图标
              onSelected: (value) async {
                if (value == 'edit') {
                  _showAddEditTagDialog(tag: tag); // 编辑标签
                } else if (value == 'delete') {
                  final bool? confirmed =
                      await showDeleteConfirmDialog(
                        deleteTargetName: tag.name, // 删除目标名称
                      );
                  final String confirmMessage =
                      '标签 ${tag.name} 已删除！'; // 删除确认消息
                  if (confirmed == true) {
                    await controller.removeTag(tag.id); // 调用删除方法
                    Get.snackbar('删除成功', confirmMessage); // 弹出删除成功提示
                  }
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: kTextColor), // 编辑图标
                          SizedBox(width: spacingSM), // 间距
                          Text(
                            '编辑', // 编辑文本
                            style: bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ), // 删除图标
                          SizedBox(width: spacingSM), // 间距
                          Text(
                            '删除', // 删除文本
                            style: bodyTextStyle.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}
