import 'package:get/get.dart';

enum OrderType { name, lastUsed, frequency }

class ItemListOrderController extends GetxController {
  var selectedOrderOption = OrderType.name.obs;
  var isAscending = true.obs; // 排序方向

  void changeOrderOption(OrderType option) {
    if (selectedOrderOption.value == option) {
      isAscending.toggle(); // 如果点击相同选项，切换排序方向
    } else {
      selectedOrderOption.value = option;
      isAscending.value = true; // 切换不同选项时默认升序
    }
  }
}
