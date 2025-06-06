import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddTagDialog extends StatelessWidget {
  final _tagNameCtrl = TextEditingController();
  final Rx<Color> _selectedColor = Rx<Color>(kColorPalette.first);
  final RxString _errorText = RxString('');

  AddTagDialog({super.key});

  Future<void> _submit(TagController tagCtrl) async {
    final name = _tagNameCtrl.text.trim();

    if (name.isEmpty) {
      _errorText.value = "Tag name cannot be empty";
      return;
    }

    if (await tagCtrl.addTag(name, _selectedColor.value) == false) {
      _errorText.value = "Tag name already exists";
      return;
    }

    Get.back(); // 关闭弹窗
  }

  @override
  Widget build(BuildContext context) {
    final tagCtrl = Get.find<TagController>();

    final style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;
    final TextStyle largeTitleTextStyle = style.titleTextEX;
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          _submit(tagCtrl);
        } else if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Get.back();
        }
      },
      focusNode: FocusNode(), // 监听键盘事件
      child: AlertDialog(
        title: Text("Add New Tag", style: largeTitleTextStyle),
        backgroundColor: kPrimaryBgColor,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tag Name", style: titleTextStyle),
              SizedBox(height: spacingMD),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _tagNameCtrl,
                      style: bodyTextStyle,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: spacingMD,
                        ),
                        hintText: "Tag",
                        hintStyle: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w200,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: kSelectedBorderColor,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: kGrayColor,
                            width: 1.0,
                          ),
                        ),
                        errorText: null,
                      ),
                      onChanged: (_) => _errorText.value = '',
                    ),

                    if (_errorText.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: spacingMD,
                          top: 4,
                        ),
                        child: Text(
                          _errorText.value,
                          style: bodyTextStyle.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                  ],
                );
              }),

              SizedBox(height: spacingMD * 1.5),
              Text("Tag Color", style: titleTextStyle),
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
                              onTap:
                                  () => _selectedColor.value = color,
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
            label: Text("Cancel", style: bodyTextStyle),
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
            label: Text("Add", style: bodyTextStyle),
          ),
        ],
      ),
    );
  }
}
