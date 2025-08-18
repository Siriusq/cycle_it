import 'dart:async';

import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/views/notification_handling/notification_handling_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 存储从终止状态启动 App 时的通知响应
  NotificationResponse? _initialNotificationResponse;

  Future<NotificationService> init() async {
    // 1. Android 初始化设置
    const AndroidInitializationSettings
    initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // 2. Darwin (iOS, macOS) 初始化设置
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // 3. Linux 初始化设置
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open');

    // 4. Windows 初始化设置
    final WindowsInitializationSettings
    initializationSettingsWindows = WindowsInitializationSettings(
      appName: 'Cycle It',
      appUserModelId: 'Top.Siriusq.CycleIt',
      // Search online for GUID generators to make your own
      guid: '56d804df-4bf8-4a95-990a-8574d1f770dd',
      iconPath: 'assets/images/app_icon_windows.png',
    );

    // 5. 组合成总的初始化设置
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
          windows: initializationSettingsWindows,
        );

    // 6. 初始化插件
    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    // 7. 检查 APP 是否由通知拉起，如果是，则暂存该通知响应，而不是立即处理
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        GetPlatform.isLinux
            ? null
            : await _plugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ??
        false) {
      _initialNotificationResponse =
          notificationAppLaunchDetails!.notificationResponse;
      if (kDebugMode) {
        print('App由通知启动，已暂存负载');
      }
    } else {
      if (kDebugMode) {
        print("未由通知启动（didNotificationLaunchApp = false）");
      }
    }

    // 8. 请求权限
    await _requestPermissions();

    return this;
  }

  // 在 UI 准备好后处理初始通知
  void handleInitialNotification() async {
    // 通用方法
    if (_initialNotificationResponse != null) {
      selectNotificationStream.add(
        _initialNotificationResponse!.payload,
      );
      return;
    }

    // 解决 Windows 平台时序冲突导致 UI 不显示
    if (GetPlatform.isWindows) {
      // 重新获取通知细节
      final notificationAppLaunchDetails =
          await _plugin.getNotificationAppLaunchDetails();

      if (notificationAppLaunchDetails?.didNotificationLaunchApp ??
          false) {
        final response =
            notificationAppLaunchDetails!.notificationResponse;
        // 延迟500ms
        if (response?.payload != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            selectNotificationStream.add(response!.payload);
          });
        }
      } else {
        if (kDebugMode) {
          print("没有可用的启动通知。");
        }
      }
    }
  }

  // 通知后的动作
  void configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      if (payload != null) {
        final int divideIdx = payload.indexOf(' ');
        final int? itemId = int.tryParse(
          payload.substring(0, divideIdx),
        );
        final String itemName = payload.substring(divideIdx + 1);

        if (itemId != null) {
          if (kDebugMode) {
            print('App launched by notification with $itemId');
          }
          Get.dialog(
            NotificationHandlingDialog(
              itemId: itemId,
              itemName: itemName,
            ),
          );
        }
      }
    });
  }

  /// 请求各平台权限
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

  /// 根据物品状态更新通知（计划或取消）
  Future<void> updateNotificationForItem(ItemModel item) async {
    if (item.id == null || GetPlatform.isLinux) return;

    // 检查是否满足所有通知条件
    if (item.notifyBeforeNextUse &&
        item.nextExpectedUse != null &&
        item.notificationTime != null) {
      // 拼装通知时间
      final expectedDate = item.nextExpectedUse!;
      final scheduledTime = item.notificationTime!;
      final scheduledDateTime = DateTime(
        expectedDate.year,
        expectedDate.month,
        expectedDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
      // 计划通知
      await _scheduleNotification(
        item.id!,
        item.name,
        scheduledDateTime,
      );
    } else {
      // 任何一个条件不满足，都取消已有的通知
      await cancelNotification(item.id!);
    }
  }

  // 推迟通知
  Future<void> delayNotificationForItem(
    int itemId,
    String itemName,
    DateTime scheduledDateTime,
  ) async {
    _scheduleNotification(itemId, itemName, scheduledDateTime);
  }

  // 计划一个通知
  Future<void> _scheduleNotification(
    int itemId,
    String itemName,
    DateTime scheduledDateTime,
  ) async {
    // Linux 不支持计划通知
    if (GetPlatform.isLinux) {
      return;
    }

    // 如果计划时间已过，则取消并返回
    if (scheduledDateTime.isBefore(DateTime.now())) {
      await cancelNotification(itemId);
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
      itemId,
      'item_usage_reminder'.tr,
      'item_usage_reminder_body'.trParams({'itemName': itemName}),
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: "$itemId $itemName",
    );
    if (kDebugMode) {
      print('Notification Added');
    }
  }

  /// 取消单个通知
  Future<void> cancelNotification(int itemId) async {
    // Linux 不支持计划通知
    if (GetPlatform.isLinux) {
      return;
    }
    await _plugin.cancel(itemId);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    // Linux 不支持计划通知
    if (GetPlatform.isLinux) {
      return;
    }
    await _plugin.cancelAll();
  }

  /// 重新计划所有物品的通知
  Future<void> rescheduleAllNotifications(
    List<ItemModel> items,
  ) async {
    // Linux 不支持计划通知
    if (GetPlatform.isLinux) {
      return;
    }

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

/// 顶层函数或静态方法，用于处理后台通知响应
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
void onDidReceiveNotificationResponse(
  NotificationResponse response,
) async {
  if (response.payload != null) {
    selectNotificationStream.add(response.payload);
  }
}
