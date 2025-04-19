import 'dart:ui' as ui;

import 'package:cycle_it/bindings/home_binding.dart';
import 'package:cycle_it/views/details_page.dart';
import 'package:cycle_it/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/i18n.dart';
import 'views/home_page.dart';

void main() {
  //Get.put(LayoutController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
      // 多语言文件
      translations: MultiLanguage(),
      // 自动设置语言
      locale: ui.window.locale,
      // 添加一个回调语言选项，以备上面指定的语言翻译不存在
      fallbackLocale: Locale('en', 'US'),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/Settings', page: () => SettingsPage()),
        GetPage(name: '/Details', page: () => DetailsPage()),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //home: HomePage(),
    );
  }
}
