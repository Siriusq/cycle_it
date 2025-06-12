import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            Text('选择图标', style: titleTextStyle),
            SizedBox(height: spacingMD),
            Container(
              height: 200,
              // Fixed height for scrollable icon grid
              decoration: BoxDecoration(
                border: Border.all(color: kGrayColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int currentSvgIconAxisCount =
                      style.svgIconAxisCount;
                  return GridView.builder(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: currentSvgIconAxisCount,
                          // 这里会响应 Get.width 的变化
                          crossAxisSpacing: spacingSM,
                          mainAxisSpacing: spacingSM,
                        ),
                    padding: EdgeInsets.all(spacingSM),
                    itemCount: controller.svgIconPaths.length,
                    itemBuilder: (context, index) {
                      final iconPath = controller.svgIconPaths[index];
                      return Obx(() {
                        final isSelected =
                            controller.selectedIconPath.value ==
                            iconPath;
                        return GestureDetector(
                          onTap: () {
                            controller.selectedIconPath.value =
                                iconPath;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Get.theme.primaryColor
                                          .withOpacity(0.2)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Get.theme.primaryColor
                                        : Colors.grey[300]!,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              iconPath,
                              colorFilter: ColorFilter.mode(
                                controller.selectedIconColor.value,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

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
