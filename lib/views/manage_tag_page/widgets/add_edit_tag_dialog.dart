import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/models/tag_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditTagDialog extends StatelessWidget {
  final TagModel? tagToEdit; // 用于编辑的标签，如果为null则表示添加
  final _tagNameCtrl = TextEditingController();
  late final Rx<Color> _selectedColor;

  // 用于显示输入框错误信息的响应式变量
  final RxString _nameErrorText = ''.obs;

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

    // 清除之前的错误信息
    _nameErrorText.value = '';

    if (name.isEmpty) {
      _nameErrorText.value = 'tag_name_cannot_be_empty'.tr;
      return;
    }

    // 最大长度为50
    if (name.length > 30) {
      _nameErrorText.value = 'tag_name_too_long'.tr;
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
        message = 'tag_updated_successfully'.trParams({'name': name});
      } else {
        _nameErrorText.value = 'tag_name_already_exists'.tr;
        return; // 返回，不关闭弹窗
      }
    } else {
      // 添加模式
      success = await tagCtrl.addTag(name, _selectedColor.value);
      if (success) {
        message = 'tag_added_successfully'.trParams({'name': name});
      } else {
        _nameErrorText.value = 'tag_name_already_exists'.tr;
        return; // 返回，不关闭弹窗
      }
    }

    if (success) {
      Get.back(
        result: {'success': true, 'message': message},
      ); // 关闭弹窗并返回结果
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagCtrl = Get.find<TagController>();
    final isEditing = tagToEdit != null;

    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();
    final TextStyle bodyLG =
        Theme.of(context).textTheme.bodyLarge!.useSystemChineseFont();

    return AlertDialog(
      title: Text(
        isEditing ? 'edit_tag'.tr : 'add_new_tag'.tr,
        style: titleLG,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 12,
          children: [
            // 需要调整的输入框
            Obx(() {
              return TextFormField(
                controller: _tagNameCtrl,
                decoration: InputDecoration(
                  labelText: 'tag_name'.tr,
                  labelStyle: bodyLG,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.outlineVariant,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2.0,
                    ),
                  ),
                  errorText:
                      _nameErrorText.value.isEmpty
                          ? null
                          : _nameErrorText.value,
                ),
                maxLength: 30,
                onChanged: (_) {
                  if (_nameErrorText.value.isNotEmpty) {
                    _nameErrorText.value = '';
                  }
                },
              );
            }),

            // 标签颜色选择
            Obx(() {
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 12, // 水平间距
                    runSpacing: 12, // 如果换行，垂直间距
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
          icon: const Icon(Icons.cancel),
          label: Text('cancel'.tr),
        ),

        TextButton.icon(
          onPressed: () => _submit(tagCtrl),
          icon: const Icon(Icons.check),
          label: Text(isEditing ? 'save'.tr : 'add'.tr),
        ),
      ],
    );
  }
}
