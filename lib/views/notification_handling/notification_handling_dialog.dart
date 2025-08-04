import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/views/notification_handling/custom_delay_time_picker.dart';
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
            spacing: 16,
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

              // 快速添加使用记录
              _buildActionButton(
                context: context,
                icon: Icons.refresh,
                label: 'cycle'.tr,
                isPrimary: true,
                onPressed: _handleCycleItNow,
              ),

              // 推迟1小时
              _buildActionButton(
                context: context,
                icon: Icons.more_time,
                label: 'notify_delay_one_hour'.tr,
                onPressed: () => _handleDelay(Duration(hours: 1)),
              ),

              // 推迟1天
              _buildActionButton(
                context: context,
                icon: Icons.more_time,
                label: 'notify_delay_one_day'.tr,
                onPressed: () => _handleDelay(Duration(days: 1)),
              ),

              // 自定义推迟时间
              _buildActionButton(
                context: context,
                icon: Icons.edit_notifications,
                label: 'notify_delay_custom'.tr,
                onPressed: () => _handleCustomDelay(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 复用按钮
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final style = ElevatedButton.styleFrom(
      foregroundColor:
          isPrimary
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
      backgroundColor:
          isPrimary
              ? colorScheme.primaryContainer
              : colorScheme.surface,
    );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // 处理点击
  // 快速添加使用记录
  void _handleCycleItNow() {
    final itemController = Get.find<ItemController>();
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
          'record': DateFormat('yyyy-MM-dd').format(currDate),
          'item': itemName,
        }),
        duration: const Duration(seconds: 1),
      );
    });
  }

  // 快速推迟
  void _handleDelay(Duration duration) {
    final notificationService = Get.find<NotificationService>();
    final DateTime newTime = DateTime.now().add(duration);
    notificationService.delayNotificationForItem(
      itemId,
      itemName,
      newTime,
    );
    Get.back();
  }

  // 自定义推迟
  Future<void> _handleCustomDelay(BuildContext context) async {
    final notificationService = Get.find<NotificationService>();

    final DateTime? selectedDateTime =
        await promptForCustomDelayTime();
    // 未选中延迟时间
    if (selectedDateTime == null) {
      Get.snackbar(
        'selection_cancel'.tr,
        'notify_delay_custom_cancel'.tr,
        duration: const Duration(seconds: 1),
      );
    }
    // 选中的时间早于当前时间
    else if (selectedDateTime.isBefore(DateTime.now())) {
      Get.snackbar(
        'selection_invalid'.tr,
        'notify_delay_custom_invalid'.tr,
        duration: const Duration(seconds: 1),
      );
    }
    // 添加新通知
    else {
      notificationService.delayNotificationForItem(
        itemId,
        itemName,
        selectedDateTime,
      );
      Get.back();
      Get.snackbar(
        'success'.tr,
        'notify_delay_custom_success'.trParams({
          'time': DateFormat(
            'yyyy-MM-dd HH:mm',
          ).format(selectedDateTime),
        }),
        duration: const Duration(seconds: 1),
      );
    }
  }
}
