import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_edit_item_controller.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_style.dart';

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
    final TextStyle bodyTextLG = style.bodyTextLG;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? "编辑物品" : "添加物品",
          style: largeTitleTextStyle.copyWith(
            color: kTitleTextColor,
          ), // 确保标题颜色正确
        ),
        backgroundColor: kPrimaryBgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: kPrimaryBgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: spacingMD,
          vertical: spacingSM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacingMD),
            // --- 1. 名称和注释输入 ---
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
              maxLines: 3,
            ),
            const SizedBox(height: 24.0),

            // --- 2. 图标选择器 ---
            Text('选择表情符号和背景色', style: titleTextStyle),
            SizedBox(height: spacingMD),

            // 显示当前选中的 Emoji 和背景色
            Obx(
              () => Container(
                width: 80,
                // 与图标大小一致
                height: 80,
                decoration: BoxDecoration(
                  color:
                      controller
                          .selectedIconColor
                          .value, // <--- 使用颜色作为背景
                  borderRadius: BorderRadius.circular(16), // 圆角矩形
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.selectedEmoji.value,
                  // <--- 显示选中的 Emoji
                  style: const TextStyle(
                    fontSize: 50, // 调整 Emoji 大小以适应 Container
                  ),
                ),
              ),
            ),
            SizedBox(height: spacingMD),

            // 打开 Emoji 选择器按钮
            ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  // 使用 Get.bottomSheet 显示 EmojiPicker
                  SizedBox(
                    height: Get.height * 0.8, // 占据屏幕高度的 80%
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        controller.chooseEmoji(
                          emoji.emoji,
                        ); // 调用控制器的方法更新选中的 emoji
                        Get.back(); // 关闭底部工作表
                      },
                      config: Config(
                        checkPlatformCompatibility: true,
                        categoryViewConfig: CategoryViewConfig(
                          initCategory: Category.RECENT,
                          // 默认显示最近使用的表情
                          iconColor: Colors.grey,
                          // 图标颜色
                          iconColorSelected:
                              Theme.of(context).primaryColor,
                          // 选中图标颜色
                          tabIndicatorAnimDuration:
                              kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          // 默认分类图标
                        ),
                        skinToneConfig: SkinToneConfig(
                          indicatorColor:
                              Theme.of(context).primaryColor,
                        ),
                        bottomActionBarConfig:
                            BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                        emojiViewConfig: EmojiViewConfig(
                          columns: 7,
                          backgroundColor: kBgDarkColor,
                          emojiSizeMax:
                              32.0 *
                              (defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          recentsLimit: 28,
                          // 最近使用数量
                          noRecents: const Text(
                            '无最近使用',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black26,
                            ),
                          ),

                          buttonMode: ButtonMode.MATERIAL, // 按钮样式
                        ),
                      ),
                    ),
                  ),
                  isScrollControlled: true, // 允许底部工作表占据更多高度
                  backgroundColor:
                      Colors
                          .transparent, // 背景透明，以便 EmojiPicker 自身的背景生效
                );
              },
              child: const Text('选择表情符号'),
            ),
            SizedBox(height: spacingMD),

            // --- 3. 颜色选择器 ---
            Text('选择图标颜色', style: titleTextStyle),
            const SizedBox(height: 8.0),
            Obx(
              () => ColorPicker(
                color: controller.selectedIconColor.value,
                onColorChanged: (color) {
                  controller.selectedIconColor.value = color;
                },
                width: 44,
                height: 44,
                borderRadius: 22,
                heading: Text(
                  '选择颜色',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subheading: Text(
                  '阴影和色调',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                wheelSubheading: Text(
                  '选择颜色',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                showMaterialName: true,
                showColorName: true,
                showColorCode: true,
                copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                  copyButton: true,
                  pasteButton: true,
                  longPressMenu: true,
                ),
                enableShadesSelection: true,
                enableTonalPalette: true,
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
                  ColorPickerType.custom: false,
                },
              ),
            ),
            const SizedBox(height: 24.0),

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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacingMD),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: const Size(60, 0),
                padding: EdgeInsets.all(spacingMD),
                backgroundColor: kSecondaryBgColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: kGrayColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.back(),
              icon: Icon(Icons.cancel_outlined, color: kTextColor),
              label: Text("取消", style: bodyTextStyle),
            ),
            SizedBox(width: spacingMD),
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: const Size(90, 0),
                padding: EdgeInsets.all(spacingMD),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: kPrimaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              icon: Icon(
                Icons.check_circle_outline,
                color: kTextColor,
              ),
              label: Text(
                controller.isEditing ? "保存" : "添加",
                style: bodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 定义一个自定义的 ScrollBehavior，用于禁用默认滚动条
class NoDefaultScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails scrollableDetails,
  ) {
    return child;
  }
}
