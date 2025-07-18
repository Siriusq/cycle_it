import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 定义主题模式枚举
enum ThemeModeOption { light, dark, system }

// GetX控制器，用于管理主题状态和逻辑
class ThemeController extends GetxController {
  // 当前选定的主题模式，可观察
  final Rx<ThemeModeOption> _currentThemeModeOption =
      ThemeModeOption.system.obs;

  // 当前应用的主题数据，可观察
  final Rx<ThemeData> _currentThemeData = ThemeData.light().obs;

  ThemeModeOption get currentThemeModeOption =>
      _currentThemeModeOption.value;

  ThemeData get currentThemeData => _currentThemeData.value;

  // SharedPreferences 实例
  late SharedPreferences _prefs;

  // 添加 Completer 来表示 ThemeController 的异步初始化是否完成
  final Completer<void> _themeInitCompleter = Completer<void>();

  Future<void> get themeInitializationFuture =>
      _themeInitCompleter.future; // 暴露一个 Future 让外部等待

  @override
  void onInit() {
    super.onInit();
    // 调用异步初始化，并在其完成后标记 Completer 完成
    _initSharedPreferences()
        .then((_) {
          if (!_themeInitCompleter.isCompleted) {
            _themeInitCompleter.complete();
          }
        })
        .catchError((error) {
          if (!_themeInitCompleter.isCompleted) {
            _themeInitCompleter.completeError(error);
          }
        });
  }

  // 初始化 SharedPreferences 并加载保存的主题设置
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadThemeFromPrefs();
  }

  // 从 SharedPreferences 加载主题设置
  Future<void> _loadThemeFromPrefs() async {
    final String? themeOptionString = _prefs.getString(
      'themeModeOption',
    );
    if (themeOptionString != null) {
      final ThemeModeOption savedOption = ThemeModeOption.values
          .firstWhere(
            (e) =>
                e.toString() == 'ThemeModeOption.$themeOptionString',
            orElse: () => ThemeModeOption.system,
          );
      await setTheme(savedOption); // 应用保存的主题
    } else {
      await setTheme(ThemeModeOption.system); // 如果没有保存，则应用系统主题
    }
  }

  // 设置主题并保存到 SharedPreferences
  Future<void> setTheme(ThemeModeOption option) async {
    _currentThemeModeOption.value = option;
    await _prefs.setString('themeModeOption', option.name);
    await _applyThemeData(option);
  }

  // 根据选定的主题模式应用实际的 ThemeData
  Future<void> _applyThemeData(ThemeModeOption option) async {
    ThemeData newThemeData;

    if (option == ThemeModeOption.light) {
      newThemeData = await _loadJsonTheme(
        'assets/themes/light_theme.json',
      );
    } else if (option == ThemeModeOption.dark) {
      newThemeData = await _loadJsonTheme(
        'assets/themes/dark_theme.json',
      );
    } else {
      // option == ThemeModeOption.system
      // **尝试在最早阶段通过 WidgetsBinding.instance.window.platformBrightness 获取系统亮度**
      final Brightness initialSystemBrightness =
          PlatformDispatcher.instance.platformBrightness;

      if (initialSystemBrightness == Brightness.dark) {
        newThemeData = await _loadJsonTheme(
          'assets/themes/dark_theme.json',
        );
      } else {
        newThemeData = await _loadJsonTheme(
          'assets/themes/light_theme.json',
        );
      }
    }

    _currentThemeData.value = newThemeData; // 设置当前的主题
  }

  // 从 JSON 文件加载 ThemeData
  Future<ThemeData> _loadJsonTheme(String path) async {
    try {
      final String themeJsonString = await rootBundle.loadString(
        path,
      );
      final Map<String, dynamic> themeJson = json.decode(
        themeJsonString,
      );
      final ThemeData? theme = ThemeDecoder.decodeThemeData(
        themeJson,
      );
      return theme ?? ThemeData.light(); // 如果解码失败，返回默认亮色主题
    } catch (e) {
      return ThemeData.light(); // 发生错误时返回默认亮色主题
    }
  }

  // 监听系统主题变化（仅当当前模式为“跟随系统”时才需要）
  @override
  void onReady() {
    super.onReady();
    // 使用 addPostFrameCallback 确保在 GetMaterialApp 及其 MediaQuery 准备好之后再监听
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(Get.mediaQuery.obs, (_) {
        if (_currentThemeModeOption.value == ThemeModeOption.system) {
          _applyThemeData(ThemeModeOption.system);
        }
      });
    });
  }
}
