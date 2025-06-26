import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTagDialog extends StatelessWidget {
  final _tagNameCtrl = TextEditingController();
  final Rx<Color> _selectedColor = Rx<Color>(kColorPalette.first);

  AddTagDialog({super.key});

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

    if (await tagCtrl.addTag(name, _selectedColor.value) == false) {
      Get.snackbar('error'.tr, 'tag_name_already_exists'.tr);
      return;
    }

    // Get.snackbar('success'.tr, 'tag_added_successfully'.tr);
    Get.back(
      result: {'success': true, 'message': '标签 $name 添加成功！'},
    ); // 关闭弹窗
  }

  @override
  Widget build(BuildContext context) {
    final tagCtrl = Get.find<TagController>();

    final style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;
    final TextStyle titleTextStyleLG = style.titleTextEX;
    final TextStyle bodyTextLG = style.bodyTextLG;

    return AlertDialog(
      backgroundColor: kPrimaryBgColor,
      title: Text('add_new_tag'.tr, style: titleTextStyleLG),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 设置对话框圆角
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      // 控制对话框与屏幕边缘的内边距
      clipBehavior: Clip.antiAlias,
      // 防止内容超出圆角
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标签名称
            TextFormField(
              controller: _tagNameCtrl,
              decoration: InputDecoration(
                labelText: 'tag_name'.tr,
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
              maxLength: 30,
            ),

            SizedBox(height: spacingMD),
            Obx(
              () => SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kGrayColor, width: 1),
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
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(
            minimumSize: Size(60, 0),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kSecondaryBgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kGrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Get.back(),
          icon: Icon(Icons.cancel_outlined, color: kTextColor),
          label: Text('cancel'.tr, style: bodyTextLG),
        ),

        TextButton.icon(
          style: TextButton.styleFrom(
            minimumSize: Size(90, 0),
            padding: EdgeInsets.all(spacingMD),
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _submit(tagCtrl),
          icon: Icon(Icons.check_circle_outline, color: kTextColor),
          label: Text('add'.tr, style: bodyTextLG),
        ),
      ],
    );
  }
}
