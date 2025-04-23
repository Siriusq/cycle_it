import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/item_list_tag_controller.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // 当进入 HomePage 时，才会实例化 ItemController
    Get.lazyPut<ItemController>(() => ItemController());
    Get.lazyPut<ItemListOrderController>(() => ItemListOrderController());
    Get.lazyPut<ItemListTagController>(() => ItemListTagController());
  }
}
