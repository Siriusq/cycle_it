import 'package:cycle_it/bindings/add_edit_item_binding.dart';
import 'package:cycle_it/bindings/home_binding.dart';
import 'package:cycle_it/services/item_service.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/custom_scroll_behavior.dart';
import 'package:cycle_it/views/add_edit_item_page/add_edit_item_page.dart';
import 'package:cycle_it/views/details_page/details_page.dart';
import 'package:cycle_it/views/manage_tag_page/manage_tag_page.dart';
import 'package:cycle_it/views/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

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

  // Manually run HomeBinding to put all permanent dependencies
  HomeBinding().dependencies();
  // Retrieve ItemService and call initializeData AFTER it's put by HomeBinding
  final itemService = Get.find<ItemService>();
  await itemService.initializeData(); // Call data initialization

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      // 动画主题
      //defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 300),
      // 应用自定义的滚动行为
      scrollBehavior: CustomScrollBehavior(),
      //initialBinding: HomeBinding(),
      // 多语言文件
      translations: MultiLanguage(),
      locale: Get.deviceLocale,
      // 添加一个回调语言选项，以备上面指定的语言翻译不存在
      fallbackLocale: Locale('en', 'US'),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/Settings', page: () => SettingsPage()),
        GetPage(name: '/Details', page: () => DetailsPage()),
        GetPage(
          name: '/AddEditItem',
          page: () => AddEditItemPage(),
          binding: AddEditItemBinding(),
        ),
        GetPage(name: '/ManageTag', page: () => ManageTagPage()),
      ],
      title: 'Cycle It',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryBgColor, // 默认的AppBar背景色
          surfaceTintColor: Colors.transparent, // 消除滚动时的表面色调
          shadowColor: Colors.transparent, // 消除滚动时的阴影
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color(0x33000000), // 选中内容的背景色
          cursorColor: kTextColor, // 光标颜色
          selectionHandleColor: kPrimaryColor, // 拖动选中控制柄颜色（移动端）
        ),
      ),
      //home: HomePage(),
    );
  }
}
