import 'package:get/get.dart';

class MultiLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      'languageSettingsText': '语言设置',
      'themeSettingsText': '主题设置',
      'databaseSettingsText': '数据设置',
      'itemNameText': '物品名称',
    },
    'en_US': {'languageSettingsText': 'Language Settings'},
  };
}
