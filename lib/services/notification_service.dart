import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/item_model.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // 1. Android 初始化设置
    const AndroidInitializationSettings
    initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // 2. Darwin (iOS, macOS) 初始化设置
    //    这里的 onDidReceiveLocalNotification 仍然是为了兼容旧版 iOS，但主要逻辑已迁移
    final DarwinInitializationSettings
    initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // 当应用在前台时收到通知的回调 (iOS < 10.0)
      // onDidReceiveLocalNotification: (id, title, body, payload) {
      //   // 可以选择显示一个对话框或不执行任何操作
      // },
    );

    // 3. Linux 初始化设置
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open');

    final WindowsInitializationSettings
    initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'Flutter Local Notifications Example',
      appUserModelId:
          'Com.Dexterous.FlutterLocalNotificationsExample',
      // Search online for GUID generators to make your own
      guid: '56d804df-4bf8-4a95-990a-8574d1f770dd',
    );

    // 4. 组合成总的初始化设置
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
          windows: initializationSettingsWindows,
        );

    // 5. 初始化插件
    //    onDidReceiveNotificationResponse: 用户点击通知时触发（应用在后台或已终止）
    //    onDidReceiveBackgroundNotificationResponse: 应用在后台时，用户与通知交互时触发
    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // 6. 请求权限
    await _requestPermissions();

    return this;
  }

  /// 内部方法：请求各平台权限
  Future<void> _requestPermissions() async {
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      // 为 iOS 和 macOS 请求权限
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (GetPlatform.isAndroid) {
      // 为 Android (API 33+) 请求权限
      final AndroidFlutterLocalNotificationsPlugin?
      androidImplementation =
          _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted =
          await androidImplementation
              ?.requestNotificationsPermission();
      if (granted == false) {
        Get.snackbar(
          'permission_denied'.tr,
          'notification_permission_denied_message'.tr,
        );
      }
    }
  }

  /// 核心方法：根据物品状态更新通知（计划或取消）
  Future<void> updateNotificationForItem(ItemModel item) async {
    if (item.id == null) return;

    // 检查是否满足所有通知条件
    if (item.notifyBeforeNextUse &&
        item.nextExpectedUse != null &&
        item.notificationTime != null) {
      await _scheduleNotification(item);
    } else {
      // 任何一个条件不满足，都取消已有的通知
      await cancelNotification(item.id!);
    }
  }

  /// 内部方法：计划一个具体的通知
  Future<void> _scheduleNotification(ItemModel item) async {
    // 再次确认所有必需数据都存在
    if (item.id == null ||
        item.nextExpectedUse == null ||
        item.notificationTime == null) {
      return;
    }

    final expectedDate = item.nextExpectedUse!;
    final scheduledTime = item.notificationTime!;

    final scheduledDateTime = DateTime(
      expectedDate.year,
      expectedDate.month,
      expectedDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // 如果计划时间已过，则取消并返回
    if (scheduledDateTime.isBefore(DateTime.now())) {
      await cancelNotification(item.id!);
      if (kDebugMode) {
        print('Time already passed');
      }
      return;
    }

    // 使用 TZDateTime 来确保时区正确
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDateTime,
      tz.local,
    );

    await _plugin.zonedSchedule(
      item.id!,
      'item_usage_reminder'.tr,
      'item_usage_reminder_body'.trParams({'itemName': item.name}),
      tzScheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'cycle_it_reminders_channel',
          'Item Reminders', // Channel Name
          channelDescription:
              'Reminders for item usage cycles.', // Channel Description
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        windows: WindowsNotificationDetails(),
      ),
      // 使用新的 matchDateTimeComponents 参数
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: item.id.toString(),
    );
    if (kDebugMode) {
      print('Notification Added');
    }
  }

  /// 取消单个通知
  Future<void> cancelNotification(int itemId) async {
    await _plugin.cancel(itemId);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  /// 重新计划所有物品的通知
  Future<void> rescheduleAllNotifications(
    List<ItemModel> items,
  ) async {
    if (kDebugMode) {
      print(
        'NotificationService received ${items.length} items to reschedule.',
      );
    }

    for (final item in items) {
      await updateNotificationForItem(item);
    }
  }
}

/// 这是一个顶层函数或静态方法，用于处理后台通知响应
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
  NotificationResponse response,
) {
  // 在这里处理后台逻辑
  if (kDebugMode) {
    print('Background notification payload: ${response.payload}');
  }
}

/// 处理前台和后台的通知点击事件
void onDidReceiveNotificationResponse(NotificationResponse response) {
  if (response.payload != null) {
    if (kDebugMode) {
      print('Notification payload: ${response.payload}');
    }
    // 示例：可以根据 payload 跳转到详情页
    // final itemId = int.tryParse(response.payload!);
    // if (itemId != null) {
    //   Get.toNamed('/Details', arguments: itemId);
    // }
  }
}
