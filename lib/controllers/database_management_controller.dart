import 'dart:io';

import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/database/database.dart';
import 'package:cycle_it/services/notification_service.dart';
import 'package:cycle_it/views/settings_page/widgets/restart_required_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManagementController extends GetxController {
  late MyDatabase _db;
  late ItemController _itemController;
  late NotificationService _notificationService;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<MyDatabase>();
    _itemController = Get.find<ItemController>();
    _notificationService = Get.find<NotificationService>();
  }

  // 导出数据库
  Future<void> exportDatabase() async {
    _itemController.isListLoading.value = true; // 设置为加载状态
    try {
      await _db.exportDatabase();
    } catch (e) {
      Get.snackbar('database_export_failed'.tr, '$e');
    } finally {
      _itemController.isListLoading.value = false;
    }
  }

  // 导入数据库
  Future<void> importDatabase() async {
    _itemController.isListLoading.value = true; // 设置为加载状态
    String restartMessage = ''; // 用于存储传递给重启页面的消息

    try {
      //使用 file_picker 选择数据库文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['sqlite'],
      );

      if (result == null || result.files.single.path == null) {
        Get.snackbar(
          'database_import_failed'.tr,
          'database_import_canceled_error'.tr,
        );
        _itemController.isListLoading.value = false;
        return;
      }

      final selectedFile = File(result.files.single.path!);
      if (!await selectedFile.exists()) {
        Get.snackbar(
          'database_import_failed'.tr,
          'database_import_file_error'.tr,
        );
        _itemController.isListLoading.value = false;
        return;
      }

      // 关闭当前数据库连接
      await _db.close();

      // 添加一个短暂的延迟，以允许操作系统和任何后台 Isolate 释放文件句柄。
      // 这可以有效缓解 Windows/macOS 上的 PathAccessException 问题。
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // 增加延迟时间

      // 执行文件替换操作 (重命名旧文件，复制新文件)
      final bool fileOpsSuccess = await _db.importDatabase(
        selectedFile,
      );

      if (fileOpsSuccess) {
        restartMessage = 'database_imported'.tr;
        // 在弹出要求重启的页面前，取消所有已有的计划通知
        await _notificationService.cancelAllNotifications();
        // 导入成功后，设置标志位，以便在下次启动时重新注册通知
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
          'reschedule_notifications_after_import',
          true,
        );
      } else {
        restartMessage = 'database_import_failed'.tr;
      }

      Get.offAll(
        () => RestartRequiredPage(
          succeed: fileOpsSuccess,
          message: restartMessage,
        ),
      );
    } catch (e) {
      Get.offAll(
        () => RestartRequiredPage(
          succeed: false,
          message: e.toString(),
        ),
      );
    } finally {
      _itemController.isListLoading.value = false;
    }
  }
}
