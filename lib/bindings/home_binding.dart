import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/responsive_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:get/get.dart';

import '../controllers/item_controller.dart';
import '../controllers/search_bar_controller.dart';
import '../database/database.dart';
import '../services/item_service.dart';
import '../utils/responsive_style.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // 绑定 Drift 数据库
    Get.put(MyDatabase(), permanent: true);

    // 绑定服务
    Get.put(ItemService(Get.find<MyDatabase>()), permanent: true);

    Get.put<ResponsiveStyle>(ResponsiveStyle(), permanent: true);

    Get.put<ItemListOrderController>(
      ItemListOrderController(),
      permanent: true,
    );

    Get.put<TagController>(TagController(), permanent: true);

    Get.put<SearchBarController>(
      SearchBarController(),
      permanent: true,
    );

    Get.put<ItemController>(ItemController(), permanent: true);

    Get.put<ResponsiveController>(
      ResponsiveController(),
      permanent: true,
    );
  }
}
