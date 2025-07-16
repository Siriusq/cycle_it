import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/responsive_style.dart';

class NotifySwitchSection extends StatelessWidget {
  const NotifySwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyTextStyle = style.bodyTextLG;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'enable_notify'.tr,
            style: bodyTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Obx(() {
          return Switch.adaptive(
            value: controller.notifyBeforeNextUse.value,
            onChanged: (newValue) {
              controller.notifyBeforeNextUse.value = newValue;
            },
            activeColor: Theme.of(context).colorScheme.primary,
          );
        }),
      ],
    );
  }
}
