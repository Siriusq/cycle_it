import 'package:cycle_it/controllers/database_management_controller.dart';
import 'package:get/get.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseManagementController>(
      () => DatabaseManagementController(),
    );
  }
}
