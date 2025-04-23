import 'package:get/get.dart';

import '../models/item_model.dart';

class ItemListTagController extends GetxController {
  // 当前已选中的标签列表
  RxSet<String> selectedTags = <String>{}.obs;

  // 切换标签选择状态
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // 根据标签筛选后的项目列表
  List<ItemModel> filterItems(List<ItemModel> allItems) {
    if (selectedTags.isEmpty) return allItems;

    return allItems.where((item) {
      return item.tags.any((tag) => selectedTags.contains(tag));
    }).toList();
  }
}
