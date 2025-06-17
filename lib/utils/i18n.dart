import 'package:get/get.dart';

class MultiLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      'languageSettingsText': '语言设置',
      'themeSettingsText': '主题设置',
      'databaseSettingsText': '数据设置',
      'itemNameText': '物品名称',
      'select_color': '选择颜色',
      'shades_and_tones': '阴影和色调',
      'pick_color_wheel': '选择颜色',
      'recent_color': '最近颜色',
      'cancel': '取消',
      'confirm': '确认',
    },
    'en_US': {
      'languageSettingsText': 'Language Settings',
      'select_color': 'Select Color',
      'shades_and_tones': 'Shades and Tones',
      'pick_color_wheel': 'Pick a Color',
      'recent_color': 'Recent Color',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
    },
  };
}
