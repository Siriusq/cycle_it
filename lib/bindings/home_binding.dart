import 'package:get/get.dart';

import '../controllers/item_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // 当进入 HomePage 时，才会实例化 ItemController
    Get.lazyPut<ItemController>(() => ItemController());
  }
}
