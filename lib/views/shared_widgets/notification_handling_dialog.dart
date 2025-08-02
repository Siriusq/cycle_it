import 'package:cycle_it/controllers/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/notification_service.dart';
import '../../utils/responsive_style.dart';

class NotificationHandlingDialog extends StatelessWidget {
  final int itemId;
  final String itemName;

  const NotificationHandlingDialog({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final NotificationService notificationService =
        Get.find<NotificationService>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextStyleLG = style.titleTextLG;

    return AlertDialog(
      title: Center(
        child: Text(
          'item_usage_reminder'.tr,
          style: titleTextStyleLG.copyWith(fontSize: 18),
          overflow: TextOverflow.visible,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias,
      contentPadding: const EdgeInsets.all(16.0),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'item_usage_reminder_details'.trParams({
                        'itemName': itemName,
                      }),
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4),

              // 快速添加使用记录
              ElevatedButton(
                onPressed: () {
                  //controller.addUsageRecordFast(itemId);
                  final DateTime currDate = DateTime.now().copyWith(
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                    microsecond: 0,
                  );
                  itemController.addUsageRecordFast(itemId, currDate);
                  Get.back();
                  Future.delayed(Duration(milliseconds: 300), () {
                    Get.snackbar(
                      'success'.tr,
                      'usage_record_added_hint'.trParams({
                        'record': DateFormat(
                          'yyyy-MM-dd',
                        ).format(currDate),
                        'item': itemName,
                      }),
                      duration: const Duration(seconds: 1),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'cycle'.tr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // 推迟1小时
              ElevatedButton(
                onPressed: () {
                  notificationService.delayNotificationForItem(
                    itemId,
                    itemName,
                    DateTime.now().add(Duration(hours: 1)),
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: Row(
                  children: [
                    Icon(Icons.more_time),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'notify_delay_one_hour'.tr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // 推迟1天
              ElevatedButton(
                onPressed: () {
                  notificationService.delayNotificationForItem(
                    itemId,
                    itemName,
                    DateTime.now().add(Duration(days: 1)),
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: Row(
                  children: [
                    Icon(Icons.today),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'notify_delay_one_day'.tr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // 自定义推迟时间
              ElevatedButton(
                onPressed: () async {
                  notificationService.delayNotificationForItem(
                    itemId,
                    itemName,
                    DateTime.now().add(Duration(seconds: 5)),
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_notifications),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'notify_delay_custom'.tr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
