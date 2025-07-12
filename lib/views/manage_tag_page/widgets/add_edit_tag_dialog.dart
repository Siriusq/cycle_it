import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';
import '../../../models/tag_model.dart';

class AddEditTagDialog extends StatelessWidget {
  final TagModel? tagToEdit; // 用于编辑的标签，如果为null则表示添加
  final _tagNameCtrl = TextEditingController();
  late final Rx<Color> _selectedColor;

  AddEditTagDialog({super.key, this.tagToEdit}) {
    if (tagToEdit != null) {
      _tagNameCtrl.text = tagToEdit!.name;
      _selectedColor = Rx<Color>(tagToEdit!.color);
    } else {
      _selectedColor = Rx<Color>(kColorPalette.first);
    }
  }

  Future<void> _submit(TagController tagCtrl) async {
    final name = _tagNameCtrl.text.trim();

    if (name.isEmpty) {
      Get.snackbar('error'.tr, 'tag_name_cannot_be_empty'.tr);
      return;
    }

    if (name.length > 30) {
      Get.snackbar('error'.tr, 'tag_name_too_long'.tr);
      return;
    }

    bool success;
    String message;

    if (tagToEdit != null) {
      // 编辑模式
      success = await tagCtrl.updateTag(
        tagToEdit!,
        name,
        _selectedColor.value,
      );
      if (success) {
        message = 'tag_added_successfully: $name';
      } else {
        message = 'tag_name_already_exists'.tr;
      }
    } else {
      // 添加模式
      success = await tagCtrl.addTag(name, _selectedColor.value);
      if (success) {
        message = 'tag_added_successfully: $name';
      } else {
        message = 'tag_name_already_exists'.tr;
      }
    }

    if (success) {
      Get.back(
        result: {'success': true, 'message': message},
      ); // 关闭弹窗并返回结果
    } else {
      Get.snackbar('error'.tr, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final tagCtrl = Get.find<TagController>();
    final isEditing = tagToEdit != null;

    final style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;
    final TextStyle titleTextStyleLG = style.titleTextEX;
    final TextStyle bodyTextLG = style.bodyTextLG;

    return AlertDialog(
      title: Text(
        isEditing ? 'edit_tag'.tr : 'add_new_tag'.tr,
        style: titleTextStyleLG,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias,
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标签名称
            Obx(() {
              final ThemeData currentTheme =
                  themeController.currentThemeData;

              return TextFormField(
                controller: _tagNameCtrl,
                decoration: InputDecoration(
                  labelText: 'tag_name'.tr,
                  labelStyle: bodyTextLG,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: currentTheme.colorScheme.outlineVariant,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: currentTheme.colorScheme.outline,
                      width: 2.0,
                    ),
                  ),
                ),
                maxLength: 30,
              );
            }),

            SizedBox(height: spacingMD),
            Obx(() {
              final ThemeData currentTheme =
                  themeController.currentThemeData;
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentTheme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(spacingMD),
                  child: Wrap(
                    spacing: spacingMD, // 水平间距
                    runSpacing: spacingMD, // 如果换行，垂直间距
                    alignment: WrapAlignment.center,
                    children:
                        kColorPalette.map((color) {
                          final isSelected =
                              color == _selectedColor.value;
                          return GestureDetector(
                            onTap: () => _selectedColor.value = color,
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 28,
                                      )
                                      : null,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Get.back(),
          icon: Icon(Icons.cancel),
          label: Text('cancel'.tr, style: bodyTextLG),
        ),

        TextButton.icon(
          onPressed: () => _submit(tagCtrl),
          icon: Icon(Icons.check),
          label: Text(
            isEditing ? 'save'.tr : 'add'.tr,
            style: bodyTextLG,
          ),
        ),
      ],
    );
  }
}
