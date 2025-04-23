import 'package:get/get.dart';

class ItemListOrderController extends GetxController {
  var selectedOrderOption = OrderType.name.obs;

  void changeOrderOption(OrderType option) {
    selectedOrderOption.value = option;
  }
}

enum OrderType { name, lastUsed, frequency }
