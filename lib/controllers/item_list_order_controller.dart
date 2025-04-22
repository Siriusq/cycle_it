import 'package:get/get.dart';

class ItemListOrderController extends GetxController {
  var selectedOrderOption = 1.obs;

  void changeOrderOption(int option) {
    selectedOrderOption.value = option;
  }
}
