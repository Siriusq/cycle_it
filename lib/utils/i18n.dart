import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiLanguage extends Translations {
  // 定义所有支持的语言环境
  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('zh', 'CN'), // Simplified Chinese
    const Locale('zh', 'TW'), // Traditional Chinese
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      'cycle': '循',
      // 详情页
      'please_select_an_item': '请选择物品',
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
      'delete': '删除',
      'add': '添加',
      'edit': '编辑',
      'save': '保存',
      'tag_name': '标签名称',
      'add_new_tag': '添加新标签',
      'edit_tag': '编辑标签',
      'error': '错误',
      'success': '成功',
      'tag_name_cannot_be_empty': '标签名称不能为空',
      'tag_name_too_long': '标签名称不能过长',
      'tag_name_already_exists': '标签名称已存在',
      'tag_added_successfully': '已成功添加标签',
      'tag_management': '标签管理',
      'date_format_error': '日期格式错误',
      'date_invalid_error': '日期不可用',
      'date_input_hint': '日日/月月/年年年年',
      'date_input_label': '输入日期',
      'date_help': '选择日期',
      //设置
      'settings': '设置',
      'language': '语言',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
      'follow_system': '系统',
      'theme': '主题',
      'light_theme': '亮色',
      'dark_theme': '暗色',
      'system_theme': '系统',
    },
    'en_US': {
      'cycle': 'Cycle It',
      // 详情页
      'please_select_an_item': 'Please select an item',
      'languageSettingsText': 'Language Settings',
      'select_color': 'Select Color',
      'shades_and_tones': 'Shades and Tones',
      'pick_color_wheel': 'Pick a Color',
      'recent_color': 'Recent Color',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'add': 'Add',
      'edit': 'Edit',
      'save': 'Save',
      'tag_name': 'Tag Name',
      'add_new_tag': 'Add New Tag',
      'edit_tag': 'Edit Tag',
      'error': 'Error',
      'success': 'Success',
      'tag_name_cannot_be_empty': 'Tag name cannot be empty',
      'tag_name_too_long': 'Tag name too long',
      'tag_name_already_exists': 'Tag name already exists',
      'tag_added_successfully': 'Tag Added Successfully',
      'tag_management': 'Tag Management',
      'date_format_error': 'Invalid format',
      'date_invalid_error': 'Invalid date',
      'date_input_hint': 'mm/dd/yyyy',
      'date_input_label': 'Enter date',
      'date_help': 'Select date',
      //设置
      'settings': 'Settings',
      'language': 'Language',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁体中文',
      'english': 'English',
      'follow_system': 'System',
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
    },
    'zh_TW': {
      // 详情页
      'please_select_an_item': '請選擇物品',
      // 设置
      'settings': '設定',
      'language': '語言',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
      'follow_system': '系統',
      'theme': '主題',
      'light_theme': '亮色',
      'dark_theme': '暗色',
      'system_theme': '系統',
      // ... 其他繁体中文翻译
    },
  };
}
