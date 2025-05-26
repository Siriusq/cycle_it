import 'package:get/get.dart';

import '../models/item_model.dart';

class ItemController extends GetxController {
  final selectedItem = Rxn<ItemModel>();

  void selectItem(ItemModel item) {
    selectedItem.value = item;
  }

  void clearSelection() {
    selectedItem.value = null;
  }
}
