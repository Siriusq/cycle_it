import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../models/item_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

class AddEditItemDialog extends StatelessWidget {
  final ItemModel?
  itemToEdit; // Null for adding, provided for editing

  const AddEditItemDialog({super.key, this.itemToEdit});

  @override
  Widget build(BuildContext context) {
    // Inject the controller based on whether we are adding or editing
    // Ensure this controller is disposed when the dialog is closed if it's not needed globally.
    // For a dialog, Get.put(..., permanent: false) is often a good choice,
    // or just let GetX handle it if it's only ever accessed once via Get.find() in the dialog.
    final AddEditItemController controller = Get.put(
      AddEditItemController(initialItem: itemToEdit),
      permanent: false,
    );

    final style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return AlertDialog(
      title: Text(
        controller.isEditing ? "编辑物品" : "添加物品",
        style: largeTitleTextStyle,
      ),
      backgroundColor: kPrimaryBgColor,
      // Wrap the content in a SizedBox to provide explicit dimensions for the AlertDialog's scrollable content
      content: SizedBox(
        width:
            MediaQuery.of(context).size.width *
            0.8, // Take 80% of screen width
        height:
            MediaQuery.of(context).size.height *
            0.7, // Take 70% of screen height
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Column(
            mainAxisSize:
                MainAxisSize
                    .min, // Now safe with a constrained parent
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. 名称和注释输入 ---
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: '物品名称',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.usageCommentController,
                decoration: const InputDecoration(
                  labelText: '使用注释 (可选)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24.0),

              // --- 2. 图标选择器 ---
              Text(
                '选择图标',
                style: titleTextStyle,
              ), // Using titleTextStyle from ResponsiveStyle
              const SizedBox(height: 8.0),
              // Live Preview of selected icon and color
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child:
                      controller.selectedIconPath.value.isNotEmpty
                          ? SvgPicture.asset(
                            controller.selectedIconPath.value,
                            width: 64,
                            height: 64,
                            colorFilter: ColorFilter.mode(
                              controller.selectedIconColor.value,
                              BlendMode.srcIn,
                            ),
                          )
                          : Container(
                            width: 64,
                            height: 64,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.help_outline,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 200, // Fixed height for scrollable icon grid
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6, // Adjust as needed
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: controller.svgIconPaths.length,
                  itemBuilder: (context, index) {
                    final iconPath = controller.svgIconPaths[index];
                    return Obx(
                      // <--- Obx moved inside itemBuilder
                      () {
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
                                // This also needs to react to color changes
                                controller.selectedIconColor.value,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // --- 3. 颜色选择器 ---
              Text(
                '选择图标颜色',
                style: titleTextStyle,
              ), // Using titleTextStyle from ResponsiveStyle
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
                  copyPasteBehavior:
                      const ColorPickerCopyPasteBehavior(
                        copyButton: true,
                        pasteButton: true,
                        longPressMenu: true,
                      ),
                  // pickerTypeWhenCompact: ColorPickerType.both,
                  // pickerType: ColorPickerType.both,
                  enableShadesSelection: true,
                  enableTonalPalette: true,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: false,
                    // Removed ColorPickerType.wheel: false,
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // --- 4. 是否开启通知功能 ---
              Obx(
                () => SwitchListTile(
                  title: const Text('开启下次使用通知'),
                  value: controller.notifyBeforeNextUse.value,
                  onChanged: (newValue) {
                    controller.notifyBeforeNextUse.value = newValue;
                  },
                ),
              ),
              const SizedBox(height: 24.0),

              // --- 5. 标签选择器 ---
              Text(
                '选择标签',
                style: titleTextStyle,
              ), // Using titleTextStyle from ResponsiveStyle
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
                  // This Obx is fine here to show/hide the "no tags" message
                  () =>
                      controller.allAvailableTags.isEmpty
                          ? const Center(
                            child: Text('没有可用标签，请先添加标签。'),
                          )
                          : ListView.builder(
                            itemCount:
                                controller.allAvailableTags.length,
                            itemBuilder: (context, index) {
                              final tag =
                                  controller.allAvailableTags[index];
                              return Obx(
                                // <--- Obx moved inside itemBuilder
                                () {
                                  final isSelected = controller
                                      .selectedTags
                                      .contains(tag);
                                  return CheckboxListTile(
                                    title: Text(tag.name),
                                    tileColor:
                                        isSelected
                                            ? tag.color.withOpacity(
                                              0.1,
                                            )
                                            : null,
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      controller.toggleTag(tag);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      actions: [
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
          label: Text(
            "取消",
            style: bodyTextStyle,
          ), // Changed to Chinese
        ),
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
            // 先保存物品，这会更新控制器内部的状态（如 nameController.text）
            await controller.saveItem(); // 确保 saveItem 完成

            // 获取保存后的物品名称，无论是新增还是编辑，都从 nameController 中取
            final String savedItemName =
                controller.nameController.text.trim();
            final String actionText =
                controller.isEditing ? '更新' : '添加';

            // 返回成功状态和消息
            Get.back(
              result: {
                'success': true,
                'message': '$savedItemName $actionText成功！',
              },
            );
          },
          icon: Icon(Icons.check_circle_outline, color: kTextColor),
          label: Text(
            controller.isEditing ? "保存" : "添加",
            style: bodyTextStyle, // Changed to Chinese
          ),
        ),
      ],
    );
  }
}
