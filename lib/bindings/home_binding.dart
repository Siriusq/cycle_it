import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/responsive_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';
import '../controllers/search_bar_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ItemController>(ItemController(), permanent: true);
    Get.put<ItemListOrderController>(
      ItemListOrderController(),
      permanent: true,
    );
    Get.put<TagController>(TagController(), permanent: true);
    Get.put<SearchBarController>(
      SearchBarController(),
      permanent: true,
    );
    Get.put<ResponsiveController>(
      ResponsiveController(),
      permanent: true,
    );
    //Get.lazyPut<responsiveCtrl>(() => ItemController());
    //Get.lazyPut<ItemListOrderController>(() => ItemListOrderController());
    //Get.lazyPut<TagController>(() => TagController());
  }
}
