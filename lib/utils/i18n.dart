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
      'itemNameText': '物品名称',

      'cycle_it': '物循 · Cycle It',
      // 通用
      'cancel': '取消',
      'confirm': '确认',
      'delete': '删除',
      'add': '添加',
      'edit': '编辑',
      'update': '更新',
      'save': '保存',
      'error': '错误',
      'success': '成功',
      'more_action': '更多操作',
      'deleted_successfully': '删除成功',
      'reached_end_hint': '—— 已经到底了 ——',

      // 侧边栏
      // 排序
      'order_by': '排序',
      'order_by_names': '物品名称',
      'order_by_recent_used_time': '最后使用时间',
      'order_by_frequency': '使用频率',
      // 标签
      'tags': '标签',

      // 物品列表页
      // 菜单栏
      'search': '搜索',
      // 列表
      'please_add_an_item': '您的物品库是空的，请添加物品',
      'no_matched_item': '没有符合条件的物品',
      // 物品卡片
      'cycle': '循物',
      'usage_record_added_hint': '已成功添加使用记录@record到@item',
      'usage_cycle_brief': '使用周期：@freq天/次',
      'usage_cycle_brief_data_not_enough': '使用周期：数据不足',
      'usage_cycle_brief_data': '@freq天/次',
      'last_used_at_brief': '上次使用：@date',
      'last_used_at_brief_data_not_enough': '上次使用：数据不足',
      'last_used_at_brief_data': '@date',
      'usage_count_brief_data': '@count次',
      'est_next_use_date_data': '@date',
      // 进度条
      'est_timer': '使用周期进度预测',
      'est_timer_brief': '预计下次使用：@date',

      // 详情页
      'please_select_an_item': '请选择物品',
      // 使用记录
      'usage_record': '使用记录',
      'index': '序号',
      'used_at': '使用日期',
      'interval_since_last_use': '间隔天数',
      'actions': '操作',
      'usage_record_deleted_hint': '已成功删除使用记录@record',
      'loading_usage_record': '加载使用记录中...',
      // 基础信息
      'no_usage_records': '暂无使用记录',
      'data_not_enough': '数据不足',
      'usage_count': '使用次数',
      'usage_count_comment': '自@date起',
      'usage_cycle': '使用周期',
      'usage_cycle_comment': '天/次',
      'last_used_at': '上次使用',
      'last_used_at_comment': '天前，@date',
      'est_next_use_date': '下次使用预测',
      'est_next_use_date_comment': '@trend，@date',
      'days_later': '天后',
      'days_ago': '天前',
      // 柱状图
      'monthly_usage_count': '每月使用次数',
      'no_usage_record_in_the_past_year': '过去一年内无使用记录',
      'Jan': '1月',
      'Feb': '2月',
      'Mar': '3月',
      'Apr': '4月',
      'May': '5月',
      'Jun': '6月',
      'Jul': '7月',
      'Aug': '8月',
      'Sep': '9月',
      'Oct': '10月',
      'Nov': '11月',
      'Dec': '12月',
      // 热点图
      'usage_record_hot_map': '使用记录热点图',
      'less': '少',
      'more': '多',

      // 物品管理页
      'item_name': '物品名称',
      'item_comment': '使用注释 (可选)',
      'add_new_item': '添加物品',
      'edit_item': '编辑物品',
      'item_changed_successfully': '已成功@action@name',
      'enable_notify': '开启下次使用通知',
      'item_name_empty': '物品名称不能为空',
      'item_name_too_long': '物品名称过长',

      // 标签管理页
      'tag_management': '标签管理',
      'add_tag_hint': '暂无标签，点击右上角添加新标签',
      // 添加标签弹窗
      'tag_name': '标签名称',
      'add_new_tag': '添加标签',
      'edit_tag': '编辑标签',
      'tag_name_cannot_be_empty': '标签名称不能为空',
      'tag_name_too_long': '标签名称过长',
      'tag_name_already_exists': '标签名称已存在',
      'tag_added_successfully': '已成功添加标签@name',
      'tag_updated_successfully': '已成功更新标签@name',
      'tag_deleted_successfully': '已成功删除标签@name',

      // 删除确认弹窗
      'delete_confirm': '删除确认',
      'are_you_sure_to_delete': '确定要删除',
      // 日期选择弹窗
      'date_format_error': '日期格式错误',
      'date_invalid_error': '日期不可用',
      'date_input_hint': '日日/月月/年年年年',
      'date_input_label': '输入日期',
      'date_help': '选择日期',
      // 颜色选择弹窗
      'select_color': '选择颜色',
      'shades_and_tones': '阴影和色调',
      'pick_color_wheel': '选择颜色',
      'recent_color': '最近颜色',
      // emoji选择弹窗
      'select_emoji': '选择 emoji',
      'select_background_color': '选择背景色',
      'search_emoji': '搜索 emoji',
      'no_recent_used_emoji': '无最近使用',
      // 标签选择弹窗
      'select_tag': '选择标签',
      'no_tag_hint': '没有可用标签，请先添加标签',

      // 设置
      'settings': '设置',
      'follow_system': '系统',
      // 主题设置
      'theme': '主题',
      'light_theme': '亮色',
      'dark_theme': '暗色',
      // 语言设置
      'language': '语言',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
      // 数据库导入导出
      'database': '数据管理',
      'data_export': '导出数据',
      'data_import': '导入数据',
      'data_clear': '清除数据',
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
      'search_emoji': 'Search emoji',

      // 侧边栏
      'cycle_it': '物·循',
      // 排序

      // 标签

      //设置
      'settings': 'Settings',
      'follow_system': 'System',
      // 主题设置
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      // 语言设置
      'language': 'Language',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁体中文',
      'english': 'English',
    },
    'zh_TW': {
      // 详情页
      'please_select_an_item': '請選擇物品',

      // 设置
      'settings': '設定',
      'follow_system': '系統',
      // 主题设置
      'theme': '主題',
      'light_theme': '亮色',
      'dark_theme': '暗色',
      // 语言设置
      'language': '語言',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
    },
  };
}
