import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_edit_item_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_style.dart';
import 'components/dialog/color_picker_dialog.dart';
import 'components/dialog/emoji_picker_dialog.dart';

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

    final double spacingMD = style.spacingMD;
    final double spacingSM = style.spacingSM;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Scaffold(
      appBar: AppBar(
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
      ),

      backgroundColor: kPrimaryBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: spacingMD,
            vertical: spacingSM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacingMD),
              // --- 1. 图标与颜色选择器 ---
              _buildEmojiEdit(controller, style, context),
              SizedBox(height: spacingMD * 2),

              // --- 2. 名称和注释输入 ---
              _buildTitleCommentEdit(controller, style),
              SizedBox(height: spacingMD),

              // --- 4. 是否开启通知功能 ---
              Obx(
                () => SwitchListTile(
                  title: Text(
                    '开启下次使用通知',
                    style: bodyTextStyle, // 应用响应式样式
                  ),
                  value: controller.notifyBeforeNextUse.value,
                  onChanged: (newValue) {
                    controller.notifyBeforeNextUse.value = newValue;
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // --- 5. 标签选择器 ---
              Text('选择标签', style: titleTextStyle),
              const SizedBox(height: 8.0),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                ), // Max height for scrollable tags
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Obx(
                  () =>
                      controller.allAvailableTags.isEmpty
                          ? const Center(child: Text('没有可用标签，请先添加标签。'))
                          : ListView.builder(
                            itemCount:
                                controller.allAvailableTags.length,
                            itemBuilder: (context, index) {
                              final tag =
                                  controller.allAvailableTags[index];
                              return Obx(() {
                                final isSelected = controller
                                    .selectedTags
                                    .contains(tag);
                                return CheckboxListTile(
                                  title: Text(
                                    tag.name,
                                    style: bodyTextStyle,
                                  ), // 应用响应式样式
                                  tileColor:
                                      isSelected
                                          ? tag.color.withOpacity(0.1)
                                          : null,
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    controller.toggleTag(tag);
                                  },
                                );
                              });
                            },
                          ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
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
}
