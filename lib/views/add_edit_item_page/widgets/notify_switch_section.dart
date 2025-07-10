import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

class NotifySwitchSection extends StatelessWidget {
  const NotifySwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Obx(
      () => Row(
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
            activeColor: itemIconColor,
            inactiveThumbColor: kSelectedBorderColor,
            inactiveTrackColor: kBorderColor.withValues(
              alpha: 0.5,
            ), // 使用 withOpacity
          ),
        ],
      ),
    );
  }
}
