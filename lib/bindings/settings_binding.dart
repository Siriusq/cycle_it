import 'package:get/get.dart';

import '../controllers/database_management_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseManagementController>(
      () => DatabaseManagementController(),
    );
  }
}
