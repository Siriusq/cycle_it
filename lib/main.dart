import 'package:cycle_it/bindings/add_edit_item_binding.dart';
import 'package:cycle_it/bindings/home_binding.dart';
import 'package:cycle_it/bindings/settings_binding.dart';
import 'package:cycle_it/controllers/language_controller.dart';
import 'package:cycle_it/controllers/theme_controller.dart';
import 'package:cycle_it/services/item_service.dart';
import 'package:cycle_it/services/notification_service.dart';
import 'package:cycle_it/utils/custom_scroll_behavior.dart';
import 'package:cycle_it/utils/i18n.dart';
import 'package:cycle_it/views/add_edit_item_page/add_edit_item_page.dart';
import 'package:cycle_it/views/details_page/details_page.dart';
import 'package:cycle_it/views/home_page/home_page.dart';
import 'package:cycle_it/views/manage_tag_page/manage_tag_page.dart';
import 'package:cycle_it/views/settings_page/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:window_manager/window_manager.dart';

Future<void> _configureLocalTimeZone() async {
  // 封装时区设置逻辑
  tz.initializeTimeZones();
  String timeZoneName;
  try {
    timeZoneName = await FlutterTimezone.getLocalTimezone();
  } catch (e) {
    if (kDebugMode) {
      print('Could not get local timezone: $e. Falling back to UTC.');
    }
    // Fallback to a default timezone if the plugin fails
    timeZoneName = 'Etc/UTC';
  }
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void main() async {
  debugProfileBuildsEnabled = true; // 跟踪Widget重建
  debugProfilePaintsEnabled = true; // 跟踪绘制操作

  WidgetsFlutterBinding.ensureInitialized();

  // 调用时区设置方法
  await _configureLocalTimeZone();

  if (GetPlatform.isWindows ||
      GetPlatform.isLinux ||
      GetPlatform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      //size: const Size(800, 600),
      minimumSize: const Size(320, 300),
      //center: true,
      title: 'Cycle It',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // 初始化并绑定通知服务
  final notificationService = await NotificationService().init();
  Get.put<NotificationService>(notificationService, permanent: true);

  // 同步绑定所有永久性依赖
  HomeBinding().dependencies();
  // 确保 ThemeController 完成了异步主题加载
  final themeController = Get.find<ThemeController>();
  await themeController.themeInitializationFuture;

  // -------------------- 仅测试用 --------------------
  // 使用/lib/test/mock_data.dart中的数据初始化数据库数据，需要在热重启后生效
  if (kDebugMode) {
    final itemService = Get.find<ItemService>();
    await itemService.initializeData();
  }

  // 设置流监听器，用于处理所有（包括冷启动和后续）通知点击
  notificationService.configureSelectNotificationSubject();

  runApp(const MyApp());

  // 在 App 启动后，并且第一帧已经渲染完毕后，再处理冷启动时的通知，避免dialog无法触发
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notificationService.handleInitialNotification();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Obx(() {
      final ThemeController themeController = Get.find();

      return GetMaterialApp(
        //useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        // 动画主题
        //defaultTransition: Transition.cupertino,
        transitionDuration: Duration(milliseconds: 300),
        // 应用自定义的滚动行为
        scrollBehavior: CustomScrollBehavior(),
        // 多语言文件
        translations: MultiLanguage(),
        locale: languageController.currentLocale ?? Get.deviceLocale,
        // 添加一个回调语言选项，以备上面指定的语言翻译不存在
        fallbackLocale: Locale('en', 'US'),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => HomePage()),
          GetPage(
            name: '/Settings',
            page: () => SettingsPage(),
            binding: SettingsBinding(),
          ),
          GetPage(name: '/Details', page: () => DetailsPage()),
          GetPage(
            name: '/AddEditItem',
            page: () => AddEditItemPage(),
            binding: AddEditItemBinding(),
          ),
          GetPage(name: '/ManageTag', page: () => ManageTagPage()),
        ],
        title: 'Cycle It',
        theme: themeController.currentThemeData,
      );
    });
  }
}
