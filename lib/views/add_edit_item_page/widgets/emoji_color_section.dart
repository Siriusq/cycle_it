import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import 'color_picker_dialog.dart';
import 'emoji_picker_dialog.dart';

class EmojiColorSection extends StatelessWidget {
  const EmojiColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    return Row(
      spacing: 12,
      children: [
        // 预览区域
        Obx(
          () => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: controller.selectedIconColor.value,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    controller.selectedEmoji.value,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
              ),
            ),
          ),
        ),
        // 按钮区域
        Expanded(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPickerButton(
                context: context,
                icon: Icons.emoji_emotions_outlined,
                label: 'select_emoji'.tr,
                onPressed: () {
                  showEmojiPickerDialog();
                },
              ),
              _buildPickerButton(
                context: context,
                icon: Icons.color_lens_outlined,
                label: 'select_background_color'.tr,
                onPressed: () async {
                  final result = await showCustomColorPickerDialog(
                    controller.selectedIconColor.value,
                    context,
                  );
                  if (result != null) {
                    controller.selectedIconColor.value = result;
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 按钮
  Widget _buildPickerButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // 设置最小尺寸以保证足够的点击区域和视觉高度，宽度设为0使其可以自由伸缩。
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          Expanded(child: Text(label, softWrap: true)),
        ],
      ),
    );
  }
}
