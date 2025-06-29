import 'package:cycle_it/views/components/dialog/item_tag_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_edit_item_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_style.dart';
import 'components/dialog/color_picker_dialog.dart';
import 'components/dialog/emoji_picker_dialog.dart';
import 'components/icon_label.dart';

class AddEditItemPage extends StatelessWidget {
  const AddEditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注入控制器，使用 Get.put 确保它在页面生命周期内可用，并在页面关闭时自动销毁
    final AddEditItemController controller = Get.put(
      AddEditItemController(initialItem: Get.arguments),
      permanent: false, // 设置为 false，当不再使用时自动销毁
    );

    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double maxFormWidth = style.desktopFormMaxWidth;
    final bool isMobileDevice = style.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: _buildAppBar(
            style: style,
            isMobileDevice: isMobileDevice,
            controller: controller,
          ),

          backgroundColor: kPrimaryBgColor,
          body: SafeArea(
            child:
                isMobileDevice
                    ? _buildMainContent(controller, style, context)
                    : Center(
                      child: SingleChildScrollView(
                        // 在这里添加 SingleChildScrollView
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxFormWidth,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: kBorderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacingSM,
                                    vertical: spacingMD,
                                  ),
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
                                            controller.isEditing
                                                ? "编辑物品"
                                                : "添加物品",
                                            style:
                                                largeTitleTextStyle,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.save_outlined,
                                        ), // 添加按钮
                                        onPressed: () async {
                                          await controller.saveItem();
                                          final String savedItemName =
                                              controller
                                                  .nameController
                                                  .text
                                                  .trim();
                                          final String actionText =
                                              controller.isEditing
                                                  ? '更新'
                                                  : '添加';

                                          Get.back(
                                            result: {
                                              'success': true,
                                              'message':
                                                  '$savedItemName $actionText成功！',
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // 分割线
                                Container(
                                  color: kBorderColor, // 分割线的颜色
                                  height: 2.0, // 高度
                                ),
                                _buildMainContent(
                                  controller,
                                  style,
                                  context,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
          ),
        );
      },
    );
  }

  AppBar? _buildAppBar({
    required ResponsiveStyle style,
    required bool isMobileDevice,
    required AddEditItemController controller,
  }) {
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final double spacingSM = style.spacingSM;

    if (!isMobileDevice) {
      return null; // 在宽屏幕上不显示默认AppBar
    }

    return AppBar(
      title: Center(
        child: Text(
          controller.isEditing ? "编辑物品" : "添加物品",
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
      // 保存按钮
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () async {
            await controller.saveItem();
            final String savedItemName =
                controller.nameController.text.trim();
            final String actionText =
                controller.isEditing ? '更新' : '添加';

            Get.back(
              result: {
                'success': true,
                'message': '$savedItemName $actionText成功！',
              },
            );
          },
        ),
        SizedBox(width: spacingSM),
      ],
    );
  }

  Widget _buildMainContent(
    AddEditItemController controller,
    ResponsiveStyle style,
    BuildContext context,
  ) {
    final double spacingMD = style.spacingMD;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacingMD,
        vertical: spacingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. 图标与颜色选择器 ---
          _buildEmojiEdit(controller, style, context),
          SizedBox(height: spacingMD * 2),

          // --- 2. 名称和注释输入 ---
          _buildTitleCommentEdit(controller, style),
          SizedBox(height: spacingMD),

          // --- 3. 标签 ---
          _buildTagEdit(controller, style, context),
          SizedBox(height: spacingMD),

          // --- 4. 是否开启通知功能 ---
          _buildNotifySwitch(controller, bodyTextStyle, context),
        ],
      ),
    );
  }

  Widget _buildTitleCommentEdit(
    AddEditItemController controller,
    ResponsiveStyle style,
  ) {
    final double spacingMD = style.spacingMD;
    final TextStyle bodyTextLG = style.bodyTextLG;

    return Column(
      children: [
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: '物品名称',
            labelStyle: bodyTextLG,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: kSelectedBorderColor,
                width: 2.0,
              ),
            ),
          ),
          maxLength: 50,
        ),
        SizedBox(height: spacingMD),
        TextFormField(
          controller: controller.usageCommentController,
          decoration: InputDecoration(
            labelText: '使用注释 (可选)',
            labelStyle: bodyTextLG,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: kSelectedBorderColor,
                width: 2.0,
              ),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildEmojiEdit(
    AddEditItemController controller,
    ResponsiveStyle style,
    BuildContext context,
  ) {
    final double spacingMD = style.spacingMD;
    final double emojiEditIconWidth = style.emojiEditIconWidth;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Row(
      children: [
        // 预览
        Obx(
          () => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color:
                  controller.selectedIconColor.value, // <--- 使用颜色作为背景
              borderRadius: BorderRadius.circular(16), // 圆角矩形
            ),
            alignment: Alignment.center,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  4.0,
                ), // Padding around the emoji
                child: FittedBox(
                  fit: BoxFit.contain,
                  // Ensures the emoji is fully visible
                  child: Text(
                    controller.selectedEmoji.value,
                    style: const TextStyle(
                      fontSize: 100,
                    ), // Start with a large size
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: spacingMD),

        Column(
          children: [
            // 选择emoji
            TextButton.icon(
              onPressed: () {
                showEmojiPickerDialog();
              },
              style: TextButton.styleFrom(
                fixedSize: Size(emojiEditIconWidth, 40),
                padding: EdgeInsets.all(spacingMD),
                backgroundColor: kSecondaryBgColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: kGrayColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: kTextColor,
              ),
              label: Text("选择 emoji", style: bodyTextStyle),
            ),

            SizedBox(height: spacingMD),
            // 选择颜色
            TextButton.icon(
              style: TextButton.styleFrom(
                fixedSize: Size(emojiEditIconWidth, 40),
                padding: EdgeInsets.all(spacingMD),
                backgroundColor: kSecondaryBgColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: kGrayColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final result = await showCustomColorPickerDialog(
                  controller.selectedIconColor.value,
                );
                if (result != null) {
                  controller.selectedIconColor.value = result;
                }
              },
              icon: Icon(
                Icons.color_lens_outlined,
                color: kTextColor,
              ),
              label: Text("选择背景色", style: bodyTextStyle),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagEdit(
    AddEditItemController controller,
    ResponsiveStyle style,
    BuildContext context,
  ) {
    final TextStyle titleTextStyle = style.titleTextMD;
    final double topSpacing =
        style.isMobileDevice ? style.spacingMD : style.spacingXS;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标签', style: titleTextStyle),
        SizedBox(height: topSpacing),
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final List<Widget> tagWidgets =
                controller.selectedTags.map((tag) {
                  return SizedBox(
                    child: IconLabel(
                      icon: Icons.bookmark,
                      label: tag.name,
                      iconColor: tag.color,
                      isLarge: true,
                    ),
                  );
                }).toList();

            // 添加“选择标签”按钮作为最后一个元素
            tagWidgets.add(
              SizedBox(
                child: InkWell(
                  onTap: () {
                    showItemTagPickerDialog();
                  },
                  child: IconLabel(
                    icon: Icons.bookmark_add_outlined,
                    label: "选择标签",
                    iconColor: kTextColor,
                    isLarge: true,
                  ),
                ),
              ),
            );

            return Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: tagWidgets,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNotifySwitch(
    AddEditItemController controller,
    TextStyle bodyTextStyle,
    BuildContext context,
  ) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '开启下次使用通知',
              style: bodyTextStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          Switch.adaptive(
            value: controller.notifyBeforeNextUse.value,
            onChanged: (newValue) {
              controller.notifyBeforeNextUse.value = newValue;
            },
            activeColor: itemIconColor,
            inactiveThumbColor: kSelectedBorderColor,
            inactiveTrackColor: kBorderColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveIcon(
    AddEditItemController controller,
    ResponsiveStyle style,
    BuildContext context,
  ) {
    final double spacingMD = style.spacingMD;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: spacingMD,
      children: [
        // 取消按钮
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Get.back(),
          icon: Icon(Icons.cancel_outlined, color: kTextColor),
          label: Text('cancel'.tr, style: bodyTextStyle),
        ),

        // 保存按钮
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            final msg = await controller.saveItem();
            if (msg == '') {
              final String savedItemName =
                  controller.nameController.text.trim();
              final String actionText =
                  controller.isEditing ? '更新' : '添加';

              Get.back(
                result: {
                  'success': true,
                  'message': '$savedItemName $actionText成功！',
                },
              );
            } else if (msg == 'item_name_empty') {
              Get.snackbar('错误', '物品名称不能为空');
            } else if (msg == 'item_name_too_long') {
              Get.snackbar('错误', '物品名称过长');
            } else if (msg == 'emoji_empty') {
              Get.snackbar('错误', '请选择一个表情符号');
            } else {
              Get.snackbar('错误', msg);
            }
          },
          icon: Icon(Icons.save_outlined, color: kTextColor),
          label: Text('confirm'.tr, style: bodyTextStyle),
        ),
      ],
    );
  }
}
