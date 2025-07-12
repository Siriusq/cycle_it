import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../utils/responsive_style.dart';

class NotifySwitchSection extends StatelessWidget {
  const NotifySwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Obx(() {
      final ThemeData currentTheme = themeController.currentThemeData;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '开启下次使用通知',
              style: bodyTextStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Switch.adaptive(
            value: controller.notifyBeforeNextUse.value,
            onChanged: (newValue) {
              controller.notifyBeforeNextUse.value = newValue;
            },
            activeColor: currentTheme.colorScheme.primary,
          ),
        ],
      );
    });
  }
}
