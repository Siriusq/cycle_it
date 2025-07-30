import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/responsive_style.dart';
import '../../shared_widgets/time_picker_helper.dart';

class NotificationOptionsSection extends StatelessWidget {
  const NotificationOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextLG = style.bodyTextLG;
    final double topSpacing =
        style.isMobileDevice ? style.spacingMD : style.spacingXS;

    return Obx(() {
      final isEnabled = controller.notifyBeforeNextUse.value;
      final time = controller.notificationTime.value;
      print("time: $time");
      final displayText = time?.format(context) ?? 'select_time'.tr;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('notification'.tr, style: titleTextStyle),
          SizedBox(height: topSpacing),
          // 1. 通知开关
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'enable_notify'.tr,
                  style: bodyTextLG,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Switch.adaptive(
                value: controller.notifyBeforeNextUse.value,
                onChanged: (newValue) {
                  controller.notifyBeforeNextUse.value = newValue;
                  // 如果开启通知但时间未设置，则设置一个默认时间
                  if (newValue &&
                      controller.notificationTime.value == null) {
                    controller
                        .notificationTime
                        .value = const TimeOfDay(hour: 9, minute: 0);
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),

          // 2. 时间选择
          AnimatedSize(
            duration: const Duration(milliseconds: 300), // 动画持续时间
            curve: Curves.easeInOut, // 动画曲线
            child: Visibility(
              visible: isEnabled, // 根据 isEnabled 决定是否显示
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    final pickedTime = await promptForNotifyTime(
                      time ?? const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (pickedTime != null) {
                      controller.notificationTime.value = pickedTime;
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'notification_time_title'.tr,
                            style: bodyTextLG,
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: bodyTextLG.copyWith(
                            color:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(displayText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
