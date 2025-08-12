import 'package:cycle_it/utils/i18n.dart'; // 导入 MultiLanguage 类
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // 用于日期格式化数据
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  // 用于存储当前选定的语言环境。如果为null，表示跟随系统语言。
  final _currentLocale = Rx<Locale?>(null);

  // SharedPreferences 实例
  late SharedPreferences _prefs;
  static const _languageKey = 'languageCode';
  static const _countryKey = 'countryCode';
  static const _followSystemKey = 'followSystemLanguage';

  // 公开的当前语言环境，通过Obx监听
  Locale? get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    // 异步初始化 SharedPreferences
    _initSharedPreferences();
  }

  // 初始化 SharedPreferences 并加载已保存的语言设置
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLanguage(); // 等待语言加载完成
  }

  // 加载已保存的语言设置
  Future<void> _loadSavedLanguage() async {
    final bool followSystem =
        _prefs.getBool(_followSystemKey) ?? true;

    if (followSystem) {
      _currentLocale.value = null; // 设置为null表示跟随系统
      // 立即应用系统语言，并等待日期格式化数据初始化
      await _updateGetXLocale(Get.deviceLocale);
    } else {
      final String? languageCode = _prefs.getString(_languageKey);
      final String? countryCode = _prefs.getString(_countryKey);

      if (languageCode != null) {
        final savedLocale = Locale(languageCode, countryCode);
        _currentLocale.value = savedLocale;
        // 应用保存的语言，并等待日期格式化数据初始化
        await _updateGetXLocale(savedLocale);
      } else {
        // 如果没有保存的语言，默认跟随系统语言
        _currentLocale.value = null;
        // 立即应用系统语言，并等待日期格式化数据初始化
        await _updateGetXLocale(Get.deviceLocale);
      }
    }
  }

  // 切换语言
  Future<void> changeLanguage(
    String languageCode, {
    String? countryCode,
  }) async {
    final newLocale = Locale(languageCode, countryCode);
    _currentLocale.value = newLocale;
    _prefs.setString(_languageKey, languageCode);
    if (countryCode != null) {
      _prefs.setString(_countryKey, countryCode);
    } else {
      _prefs.remove(_countryKey);
    }
    _prefs.setBool(_followSystemKey, false); // 不再跟随系统
    // 应用新选择的语言，并等待日期格式化数据初始化
    await _updateGetXLocale(newLocale);
  }

  // 设置为跟随系统语言
  Future<void> setFollowSystemLanguage() async {
    _currentLocale.value = null; // 设置为null表示跟随系统
    _prefs.remove(_languageKey);
    _prefs.remove(_countryKey);
    _prefs.setBool(_followSystemKey, true); // 标记为跟随系统
    // 立即应用系统语言，并等待日期格式化数据初始化
    await _updateGetXLocale(Get.deviceLocale);
  }

  // 获取当前是否跟随系统语言
  bool isFollowingSystemLanguage() {
    return _prefs.getBool(_followSystemKey) ?? true;
  }

  // 更新GetX的语言环境
  Future<void> _updateGetXLocale(Locale? locale) async {
    Locale targetLocale;

    if (locale == null) {
      // 如果是跟随系统，并且系统语言不在支持列表中，则回落到英文
      if (!_isSupportedLocale(Get.deviceLocale)) {
        targetLocale = const Locale('en', 'US');
      } else {
        targetLocale = Get.deviceLocale!;
      }
    } else {
      // 如果是手动选择的语言，直接应用
      targetLocale = locale;
    }

    // 在更新GetX语言环境之前，初始化该语言环境的日期格式数据
    await initializeDateFormatting(
      targetLocale.languageCode,
      targetLocale.countryCode,
    );

    Get.updateLocale(targetLocale);
  }

  // 检查给定的语言环境是否在支持列表中
  bool _isSupportedLocale(Locale? locale) {
    if (locale == null) return false;
    final supportedLocales = MultiLanguage.supportedLocales;
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        // 对于中文，需要额外检查国家代码
        if (locale.languageCode == 'zh') {
          if (supportedLocale.countryCode == locale.countryCode) {
            return true;
          }
        } else {
          return true;
        }
      }
    }
    return false;
  }
}
