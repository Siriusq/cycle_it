import 'package:cycle_it/bindings/add_edit_item_binding.dart';
import 'package:cycle_it/bindings/home_binding.dart';
import 'package:cycle_it/services/item_service.dart';
import 'package:cycle_it/utils/custom_scroll_behavior.dart';
import 'package:cycle_it/views/add_edit_item_page/add_edit_item_page.dart';
import 'package:cycle_it/views/details_page/details_page.dart';
import 'package:cycle_it/views/manage_tag_page/manage_tag_page.dart';
import 'package:cycle_it/views/settings_page/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'bindings/settings_binding.dart';
import 'controllers/language_controller.dart';
import 'controllers/theme_controller.dart';
import 'utils/i18n.dart';
import 'views/home_page/home_page.dart';

void main() async {
  debugProfileBuildsEnabled = true; // 跟踪Widget重建
  debugProfilePaintsEnabled = true; // 跟踪绘制操作

  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isWindows ||
      GetPlatform.isLinux ||
      GetPlatform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: const Size(800, 600),
      minimumSize: const Size(320, 300),
      center: true,
      title: 'Cycle It',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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

  runApp(const MyApp());
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
