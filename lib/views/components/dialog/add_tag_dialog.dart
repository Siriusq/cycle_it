import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'color_picker_dialog.dart';

class AddTagDialog extends StatelessWidget {
  final _tagNameCtrl = TextEditingController();
  final Rx<Color> _selectedColor = Rx<Color>(Colors.blue);
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
        title: Text("Add New Tag"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return TextField(
                controller: _tagNameCtrl,
                decoration: InputDecoration(
                  labelText: "Tag Name",
                  errorText: _errorText.value.isEmpty ? null : _errorText.value,
                ),
                onChanged: (_) => _errorText.value = '',
              );
            }),
            const SizedBox(height: 15),
            Row(
              children: [
                Text("Color:"),
                const SizedBox(width: 8),
                Obx(() => CircleAvatar(backgroundColor: _selectedColor.value, radius: 12)),
                Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showDialog<Color>(
                      context: context,
                      builder: (context) => const ColorPickerDialog(),
                    );
                    if (picked != null) _selectedColor.value = picked;
                  },
                  icon: Icon(Icons.color_lens),
                  label: Text("Choose"),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(onPressed: () => _submit(tagCtrl), child: Text("Add")),
        ],
      ),
    );
  }
}
