import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:cycle_it/views/shared_widgets/time_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationOptionsSection extends StatelessWidget {
  const NotificationOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();
    final TextStyle titleMD =
        Theme.of(
          context,
        ).textTheme.titleMedium!.useSystemChineseFont();
    final TextStyle bodyLG =
        Theme.of(context).textTheme.bodyLarge!.useSystemChineseFont();

    return Obx(() {
      final isEnabled = controller.notifyBeforeNextUse.value;
      final time = controller.notificationTime.value;
      final displayText = time?.format(context) ?? 'select_time'.tr;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('notification'.tr, style: titleMD),
          // 1. 通知开关
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'enable_notify'.tr,
                  style: bodyLG,
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
                            style: bodyLG,
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: bodyLG.copyWith(
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
