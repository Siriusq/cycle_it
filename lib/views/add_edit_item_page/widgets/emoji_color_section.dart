import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';
import 'color_picker_dialog.dart';
import 'emoji_picker_dialog.dart';

class EmojiColorSection extends StatelessWidget {
  const EmojiColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double spacingMD = style.spacingMD;
    final double emojiEditIconWidth = style.emojiEditIconWidth;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Row(
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
        SizedBox(width: spacingMD),
        // 按钮区域
        Column(
          children: [
            _buildEmojiButton(
              context: context,
              emojiEditIconWidth: emojiEditIconWidth,
              spacingMD: spacingMD,
              bodyTextStyle: bodyTextStyle,
            ),
            SizedBox(height: spacingMD),
            _buildColorButton(
              context: context,
              controller: controller,
              emojiEditIconWidth: emojiEditIconWidth,
              spacingMD: spacingMD,
              bodyTextStyle: bodyTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmojiButton({
    required BuildContext context,
    required double emojiEditIconWidth,
    required double spacingMD,
    required TextStyle bodyTextStyle,
  }) {
    return TextButton.icon(
      onPressed: () {
        showEmojiPickerDialog();
      },
      style: TextButton.styleFrom(
        fixedSize: Size(emojiEditIconWidth, 40),
        padding: EdgeInsets.all(spacingMD),
        backgroundColor: kSecondaryBgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kGrayColor, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(Icons.emoji_emotions_outlined, color: kTextColor),
      label: Text("选择 emoji", style: bodyTextStyle),
    );
  }

  Widget _buildColorButton({
    required BuildContext context,
    required AddEditItemController controller,
    required double emojiEditIconWidth,
    required double spacingMD,
    required TextStyle bodyTextStyle,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        fixedSize: Size(emojiEditIconWidth, 40),
        padding: EdgeInsets.all(spacingMD),
        backgroundColor: kSecondaryBgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kGrayColor, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        final result = await showCustomColorPickerDialog(
          controller.selectedIconColor.value,
        );
        if (result != null) {
          controller.selectedIconColor.value = result;
        }
      },
      icon: Icon(Icons.color_lens_outlined, color: kTextColor),
      label: Text("选择背景色", style: bodyTextStyle),
    );
  }
}
