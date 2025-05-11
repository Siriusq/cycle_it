import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddTagDialog extends StatelessWidget {
  final _tagNameCtrl = TextEditingController();
  final Rx<Color> _selectedColor = Rx<Color>(kColorPalette.first);
  final RxString _errorText = RxString('');

  AddTagDialog({super.key});

  void _submit(TagController tagCtrl) {
    final name = _tagNameCtrl.text.trim();

    if (name.isEmpty) {
      _errorText.value = "Tag name cannot be empty";
      return;
    }

    if (!tagCtrl.addTag(name, _selectedColor.value)) {
      _errorText.value = "Tag name already exists";
      return;
    }

    Get.back(); // 关闭弹窗
  }

  @override
  Widget build(BuildContext context) {
    final tagCtrl = Get.find<TagController>();

    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          _submit(tagCtrl);
        } else if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Get.back();
        }
      },
      focusNode: FocusNode(), // 监听键盘事件
      child: AlertDialog(
        title: Text("Add New Tag", style: TextStyle(color: kTitleTextColor, fontWeight: FontWeight.w500, fontSize: 20)),
        backgroundColor: kPrimaryBgColor,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const SizedBox(height: kDefaultPadding / 2),
              Text("Tag Name", style: TextStyle(color: kTextColor)),
              const SizedBox(height: kDefaultPadding / 2),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _tagNameCtrl,
                      style: TextStyle(color: kTextColor),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12, right: 12),
                        hintText: "Tag",
                        hintStyle: TextStyle(color: kTextColor, fontWeight: FontWeight.w200),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: kSelectedBorderColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: kGrayColor, width: 1.0),
                        ),
                        errorText: null,
                      ),
                      onChanged: (_) => _errorText.value = '',
                    ),

                    if (_errorText.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          _errorText.value,
                          style: TextStyle(color: Colors.redAccent, fontSize: 12, height: 1.2),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: kDefaultPadding),
              Text("Tag Color", style: TextStyle(color: kTextColor)),
              const SizedBox(height: kDefaultPadding / 2),
              Obx(
                () => SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kGrayColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16, // 水平间距
                      runSpacing: 16, // 如果换行，垂直间距
                      alignment: WrapAlignment.center,
                      children:
                          kColorPalette.map((color) {
                            final isSelected = color == _selectedColor.value;
                            return GestureDetector(
                              onTap: () => _selectedColor.value = color,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 28) : null,
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
              padding: EdgeInsets.all(kDefaultPadding / 2),
              backgroundColor: kSecondaryBgColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: kGrayColor, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Get.back(),
            icon: Icon(Icons.cancel_outlined, color: kTextColor),
            label: Text("Cancel", style: TextStyle(color: kTextColor)),
          ),

          TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: Size(90, 0),
              padding: EdgeInsets.all(kDefaultPadding / 2),
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _submit(tagCtrl),
            icon: Icon(Icons.check_circle_outline, color: kTextColor),
            label: Text("Add", style: TextStyle(color: kTextColor)),
          ),
        ],
      ),
    );
  }
}
