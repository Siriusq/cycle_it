import 'package:get/get.dart';

import '../models/item_model.dart';
import '../utils/responsive.dart';

class ItemController extends GetxController {
  final selectedItem = Rxn<ItemModel>();

  void selectItem(ItemModel item) {
    selectedItem.value = item;
    // 移动端需要路由跳转
    if (Responsive.isMobile(Get.context!)) {
      Get.toNamed('/Details');
    }
  }

  void clearSelection() {
    selectedItem.value = null;
    // 移动端需要路由返回
    if (Responsive.isMobile(Get.context!)) {
      if (Get.currentRoute == '/Details') {
        Get.back();
      }
    }
  }
}
