import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiLanguage extends Translations {
  // 定义所有支持的语言环境
  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('zh', 'CN'), // 简体中文
    const Locale('zh', 'TW'), // 繁体中文
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
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
      // 加载报错
      'failed_to_load_item_details': '加载物品详情失败：@error',

      // 物品管理页
      'item_name': '物品名称',
      'item_comment': '使用注释 (可选)',
      'add_new_item': '添加物品',
      'edit_item': '编辑物品',
      'item_changed_successfully': '已成功@action@name',
      'enable_notify': '预计使用日期到达时通知提醒',
      'notification': '通知',
      'item_name_empty': '物品名称不能为空',
      'item_name_too_long': '物品名称过长',
      // 通知
      'permission_denied': '未取得权限',
      'notification_permission_denied_message': 'App 未取得通知权限，请检查系统设置',
      'item_usage_reminder': '预计使用日期到达',
      'item_usage_reminder_body': '@itemName 的预计使用日期已到达',

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
      // 时间选择弹窗
      'select_time': '选择时间',
      'time_help': '选择时间',
      'hour_label': '小时',
      'minute_label': '分钟',
      'time_invalid_error': '时间不可用',
      'notification_time_title': '通知时间',

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
      // 导出
      'database_export_successfully': '数据库导出成功',
      'database_export_to': '数据库已成功导出至 @filepath',
      'database_export_failed': '数据库导出失败',
      'database_export_permission_error': '权限错误：未授予存储权限，无法导出数据库',
      'database_export_file_error': '文件不存在：当前不存在可导出的数据库文件',
      'database_export_canceled_error': '操作取消：用户取消了文件选择',
      // 导入
      'database_import_successfully': '数据库导入成功',
      'database_imported': '数据库已成功导入',
      'database_import_failed': '数据库导入失败',
      'database_import_permission_error': '权限错误：未授予存储权限，无法导入数据库',
      'database_import_file_error': '文件不存在：未选择文件或选择的文件不存在',
      'database_import_canceled_error': '操作取消：用户取消了文件选择',
      // 重启
      'restart_hint': '为确保所有更改完全生效，请手动关闭并重新启动应用程序',
    },
    'en_US': {
      'cycle_it': 'Cycle It',
      // 通用
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'add': 'Add',
      'edit': 'Edit',
      'update': 'Update',
      'save': 'Save',
      'error': 'Error',
      'success': 'Success',
      'more_action': 'More Action',
      'deleted_successfully': 'Delete successfully',
      'reached_end_hint': '—— End of content ——',

      // 侧边栏
      // 排序
      'order_by': 'Order By',
      'order_by_names': 'Names',
      'order_by_recent_used_time': 'Last Used Time',
      'order_by_frequency': 'Usage Frequency',
      // 标签
      'tags': 'Tags',

      // 物品列表页
      // 菜单栏
      'search': 'Search',
      // 列表
      'please_add_an_item':
          'Your inventory is empty, please add items',
      'no_matched_item': 'No matching items found',
      // 物品卡片
      'cycle': 'Cycle It',
      'usage_record_added_hint':
          'Successfully added usage record @record to @item',
      'usage_cycle_brief': 'Usage Cycle: @freq days/time',
      'usage_cycle_brief_data_not_enough':
          'Usage Cycle: data not enough',
      'usage_cycle_brief_data': '@freq days/time',
      'last_used_at_brief': 'Last Used Date: @date',
      'last_used_at_brief_data_not_enough':
          'Last Used Date: data not enough',
      'last_used_at_brief_data': '@date',
      'usage_count_brief_data': '@count times',
      'est_next_use_date_data': '@date',
      // 进度条
      'est_timer': 'EST. Usage Cycle Progress',
      'est_timer_brief': 'EST. Next Use: @date',

      // 详情页
      'please_select_an_item': 'Please select an item',
      // 使用记录
      'usage_record': 'Usage Record',
      'index': 'ID',
      'used_at': 'Used At',
      'interval_since_last_use': 'Interval',
      'actions': 'Action',
      'usage_record_deleted_hint':
          'Successfully deleted the usage record @record',
      'loading_usage_record': 'Loading usage records...',
      // 基础信息
      'no_usage_records': 'No usage record',
      'data_not_enough': 'Data not enough',
      'usage_count': 'Usage Count',
      'usage_count_comment': 'from @date',
      'usage_cycle': 'Usage Cycle',
      'usage_cycle_comment': 'days/time',
      'last_used_at': 'Last Used',
      'last_used_at_comment': 'days ago at @date',
      'est_next_use_date': 'EST. Next Use',
      'est_next_use_date_comment': '@trend at @date',
      'days_later': 'days later',
      'days_ago': 'days ago',
      // 柱状图
      'monthly_usage_count': 'Monthly Usage Count',
      'no_usage_record_in_the_past_year':
          'No usage record in the past year',
      'Jan': 'Jan',
      'Feb': 'Feb',
      'Mar': 'Mar',
      'Apr': 'Apr',
      'May': 'May',
      'Jun': 'Jun',
      'Jul': 'Jul',
      'Aug': 'Aug',
      'Sep': 'Sep',
      'Oct': 'Oct',
      'Nov': 'Nov',
      'Dec': 'Dec',
      // 热点图
      'usage_record_hot_map': 'Usage Record Hot Map',
      'less': 'Less',
      'more': 'More',
      // 加载报错
      'failed_to_load_item_details':
          'Failed to load item details: @error',

      // 物品管理页
      'item_name': 'Item Name',
      'item_comment': 'Comment (optional)',
      'add_new_item': 'Add Item',
      'edit_item': 'Edit Item',
      'item_changed_successfully': 'Successfully @action @name',
      'enable_notify': 'Notify on Estimated Usage Date',
      'notification': 'Notification',
      'item_name_empty': 'Item name cannot be empty',
      'item_name_too_long': 'Item name is too long',
      // 通知
      // 通知
      'permission_denied': 'Permission Denied',
      'notification_permission_denied_message':
          'The app does not have notification permissions. Please check your system settings',
      'item_usage_reminder': 'Estimated date of use arrival',
      'item_usage_reminder_body':
          'The estimated date of use for @itemName has arrived.',

      // 标签管理页
      'tag_management': 'Tag Management',
      'add_tag_hint':
          'There is no tag yet. Click on the upper right corner to add a new tag.',
      // 添加标签弹窗
      'tag_name': 'Tag Name',
      'add_new_tag': 'Add Tag',
      'edit_tag': 'Edit Tag',
      'tag_name_cannot_be_empty': 'Tag name cannot be empty',
      'tag_name_too_long': 'Tag name is too long',
      'tag_name_already_exists': 'Tag name already exists',
      'tag_added_successfully': 'Successfully added tag @name',
      'tag_updated_successfully': 'Successfully updated tag @name',
      'tag_deleted_successfully': 'Successfully deleted tag @name',

      // 删除确认弹窗
      'delete_confirm': 'Delete Confirmation',
      'are_you_sure_to_delete': 'Are you sure to delete @target ?',
      // 日期选择弹窗
      'date_format_error': 'Date format error',
      'date_invalid_error': 'Date invalid',
      'date_input_hint': 'DD/MM/YYYY',
      'date_input_label': 'Enter date',
      'date_help': 'Select date',
      // 颜色选择弹窗
      'select_color': 'Select Color',
      'shades_and_tones': 'Shades and Tones',
      'pick_color_wheel': 'Pick a Color',
      'recent_color': 'Recent Color',
      // emoji选择弹窗
      'select_emoji': 'Select emoji',
      'select_background_color': 'Select Bg Color',
      'search_emoji': 'Search emoji',
      'no_recent_used_emoji': 'No recent use',
      // 标签选择弹窗
      'select_tag': 'Select Tag',
      'no_tag_hint': 'No tags available, please add tags first',
      // 时间选择弹窗
      'select_time': 'Select Time',
      'time_help': 'Select time',
      'hour_label': 'Hour',
      'minute_label': 'Minute',
      'time_invalid_error': 'Time invalid',
      'notification_time_title': 'Notification Time',

      // 设置
      'settings': 'Settings',
      'follow_system': 'System',
      // 主题设置
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      // 语言设置
      'language': 'Language',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
      // 数据库导入导出
      'database': 'Data Management',
      'data_export': 'Export',
      'data_import': 'Import',
      'data_clear': 'Clear',
      // Export
      'database_export_successfully': 'Database Export Successful',
      'database_export_to':
          'Database successfully exported to @filepath',
      'database_export_failed': 'Database Export Failed',
      'database_export_permission_error':
          'Permission error: Storage permission not granted, unable to export database',
      'database_export_file_error':
          'File not found: No database file available to export',
      'database_export_canceled_error':
          'Operation canceled: User canceled file selection',
      // Import
      'database_import_successfully': 'Database import successful',
      'database_imported': 'Database successfully imported',
      'database_import_failed': 'Database import failed',
      'database_import_permission_error':
          'Permission error: Storage permission not granted, unable to import database',
      'database_import_file_error':
          'File not found: No file selected or the selected file does not exist',
      'database_import_canceled_error':
          'Operation canceled: User canceled file selection',
      // Restart
      'restart_hint':
          'To ensure all changes take full effect, please manually close and restart the application',
    },
    'zh_TW': {
      'cycle_it': '物循 · Cycle It',
      // 通用
      'cancel': '取消',
      'confirm': '確認',
      'delete': '刪除',
      'add': '新增',
      'edit': '編輯',
      'update': '更新',
      'save': '儲存',
      'error': '錯誤',
      'success': '成功',
      'more_action': '更多操作',
      'deleted_successfully': '刪除成功',
      'reached_end_hint': '—— 已經到底了 ——',

      // 側邊欄
      // 排序
      'order_by': '排序',
      'order_by_names': '物品名稱',
      'order_by_recent_used_time': '最後使用時間',
      'order_by_frequency': '使用頻率',
      // 標籤
      'tags': '標籤',

      // 物品列表頁
      // 菜單欄
      'search': '搜尋',
      // 列表
      'please_add_an_item': '您的物品庫是空的，請新增物品',
      'no_matched_item': '沒有符合條件的物品',
      // 物品卡片
      'cycle': '循物',
      'usage_record_added_hint': '已成功新增使用紀錄@record到@item',
      'usage_cycle_brief': '使用週期：@freq天/次',
      'usage_cycle_brief_data_not_enough': '使用週期：資料不足',
      'usage_cycle_brief_data': '@freq天/次',
      'last_used_at_brief': '上次使用：@date',
      'last_used_at_brief_data_not_enough': '上次使用：資料不足',
      'last_used_at_brief_data': '@date',
      'usage_count_brief_data': '@count次',
      'est_next_use_date_data': '@date',
      // 進度條
      'est_timer': '使用週期進度預測',
      'est_timer_brief': '預計下次使用：@date',

      // 詳情頁
      'please_select_an_item': '請選擇物品',
      // 使用紀錄
      'usage_record': '使用紀錄',
      'index': '序號',
      'used_at': '使用日期',
      'interval_since_last_use': '間隔天數',
      'actions': '操作',
      'usage_record_deleted_hint': '已成功刪除使用紀錄@record',
      'loading_usage_record': '載入使用紀錄中...',
      // 基礎資訊
      'no_usage_records': '暫無使用紀錄',
      'data_not_enough': '資料不足',
      'usage_count': '使用次數',
      'usage_count_comment': '自@date起',
      'usage_cycle': '使用週期',
      'usage_cycle_comment': '天/次',
      'last_used_at': '上次使用',
      'last_used_at_comment': '天前，@date',
      'est_next_use_date': '下次使用預測',
      'est_next_use_date_comment': '@trend，@date',
      'days_later': '天後',
      'days_ago': '天前',
      // 柱狀圖
      'monthly_usage_count': '每月使用次數',
      'no_usage_record_in_the_past_year': '過去一年內無使用紀錄',
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
      // 熱點圖
      'usage_record_hot_map': '使用紀錄熱點圖',
      'less': '少',
      'more': '多',
      // 載入報錯
      'failed_to_load_item_details': '加載物品詳情失敗：@error',

      // 物品管理頁
      'item_name': '物品名稱',
      'item_comment': '使用註解（可選）',
      'add_new_item': '新增物品',
      'edit_item': '編輯物品',
      'item_changed_successfully': '已成功@action@name',
      'enable_notify': '預計使用日期到達時通知提醒',
      'notification': '通知',
      'item_name_empty': '物品名稱不能為空',
      'item_name_too_long': '物品名稱過長',
      // 通知
      'permission_denied': '未取得權限',
      'notification_permission_denied_message': 'App 未取得通知權限，請檢查系統設定',
      'item_usage_reminder': '預計使用日期已到',
      'item_usage_reminder_body': '@itemName 的預計使用日期已到',

      // 標籤管理頁
      'tag_management': '標籤管理',
      'add_tag_hint': '暫無標籤，點擊右上角新增標籤',
      // 新增標籤彈窗
      'tag_name': '標籤名稱',
      'add_new_tag': '新增標籤',
      'edit_tag': '編輯標籤',
      'tag_name_cannot_be_empty': '標籤名稱不能為空',
      'tag_name_too_long': '標籤名稱過長',
      'tag_name_already_exists': '標籤名稱已存在',
      'tag_added_successfully': '已成功新增標籤@name',
      'tag_updated_successfully': '已成功更新標籤@name',
      'tag_deleted_successfully': '已成功刪除標籤@name',

      // 刪除確認彈窗
      'delete_confirm': '刪除確認',
      'are_you_sure_to_delete': '確定要刪除',
      // 日期選擇彈窗
      'date_format_error': '日期格式錯誤',
      'date_invalid_error': '日期無效',
      'date_input_hint': '日日/月月/年年年年',
      'date_input_label': '輸入日期',
      'date_help': '選擇日期',
      // 顏色選擇彈窗
      'select_color': '選擇顏色',
      'shades_and_tones': '陰影與色調',
      'pick_color_wheel': '選擇顏色',
      'recent_color': '最近顏色',
      // emoji選擇彈窗
      'select_emoji': '選擇 emoji',
      'select_background_color': '選擇背景色',
      'search_emoji': '搜尋 emoji',
      'no_recent_used_emoji': '無最近使用',
      // 標籤選擇彈窗
      'select_tag': '選擇標籤',
      'no_tag_hint': '沒有可用標籤，請先新增標籤',
      // 時間選擇彈窗
      'select_time': '選擇時間',
      'time_help': '選擇時間',
      'hour_label': '小時',
      'minute_label': '分鐘',
      'time_invalid_error': '時間無效',
      'notification_time_title': '通知時間',

      // 設定
      'settings': '設定',
      'follow_system': '系統',
      // 主題設定
      'theme': '主題',
      'light_theme': '亮色',
      'dark_theme': '暗色',
      // 語言設定
      'language': '語言',
      'simplified_chinese': '简体中文',
      'traditional_chinese': '繁體中文',
      'english': 'English',
      // 資料庫導入導出
      'database': '資料管理',
      'data_export': '匯出資料',
      'data_import': '匯入資料',
      'data_clear': '清除資料',
      // 匯出
      'database_export_successfully': '資料庫匯出成功',
      'database_export_to': '資料庫已成功匯出至 @filepath',
      'database_export_failed': '資料庫匯出失敗',
      'database_export_permission_error': '權限錯誤：未授予儲存權限，無法匯出資料庫',
      'database_export_file_error': '檔案不存在：目前不存在可匯出的資料庫檔案',
      'database_export_canceled_error': '操作取消：使用者取消了檔案選擇',
      // 匯入
      'database_import_successfully': '資料庫匯入成功',
      'database_imported': '資料庫已成功匯入',
      'database_import_failed': '資料庫匯入失敗',
      'database_import_permission_error': '權限錯誤：未授予儲存權限，無法匯入資料庫',
      'database_import_file_error': '檔案不存在：未選擇檔案或選擇的檔案不存在',
      'database_import_canceled_error': '操作取消：使用者取消了檔案選擇',
      // 重啟
      'restart_hint': '為確保所有變更完全生效，請手動關閉並重新啟動應用程式',
    },
  };
}
