import 'package:get/get.dart';

import '../models/item_model.dart';
import '../utils/responsive_layout.dart';

class ItemController extends GetxController {
  final selectedItem = Rxn<ItemModel>();

  void selectItem(ItemModel item) {
    selectedItem.value = item;
    // 移动端需要路由跳转
    if (ResponsiveLayout.isSingleCol(Get.context!)) {
      Get.toNamed('/Details');
    }
  }

  void clearSelection() {
    selectedItem.value = null;

    // 移动端需要路由返回
    // if (ResponsiveLayout.isSingleCol(Get.context!)) {
    //   if (Get.currentRoute == '/Details') {
    //     Get.back();
    //     Future.delayed(const Duration(milliseconds: 300), () {
    //       selectedItem.value = null; // 动画结束后再清空，防止出现页面提前销毁导致的黑屏闪烁
    //     });
    //   }
    // } else {
    //   selectedItem.value = null;
    // }
  }
}
