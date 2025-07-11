import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
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
      setTheme(savedOption); // 应用保存的主题
    } else {
      setTheme(ThemeModeOption.system); // 如果没有保存，则应用系统主题
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
    switch (option) {
      case ThemeModeOption.light:
        newThemeData = await _loadJsonTheme(
          'assets/themes/light_theme.json',
        );
        break;
      case ThemeModeOption.dark:
        newThemeData = await _loadJsonTheme(
          'assets/themes/dark_theme.json',
        );
        break;
      case ThemeModeOption.system:
        final Brightness systemBrightness =
            Get.mediaQuery.platformBrightness;
        if (systemBrightness == Brightness.dark) {
          newThemeData = await _loadJsonTheme(
            'assets/themes/dark_theme.json',
          );
        } else {
          newThemeData = await _loadJsonTheme(
            'assets/themes/light_theme.json',
          );
        }
        break;
    }
    _currentThemeData.value = newThemeData;
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
      print('加载主题文件失败: $e');
      return ThemeData.light(); // 发生错误时返回默认亮色主题
    }
  }

  // 监听系统主题变化（仅当当前模式为“跟随系统”时才需要）
  @override
  void onReady() {
    super.onReady();
    // 监听系统亮度变化，仅当主题模式为“跟随系统”时才更新
    ever(Get.mediaQuery.obs, (_) {
      if (_currentThemeModeOption.value == ThemeModeOption.system) {
        _applyThemeData(ThemeModeOption.system);
      }
    });
  }
}
