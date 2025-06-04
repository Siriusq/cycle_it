import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../services/item_service.dart';

class TagController extends GetxController {
  final ItemService _itemService = Get.find<ItemService>();

  // 所有标签
  final RxList<TagModel> allTags = <TagModel>[].obs;

  // 当前已选中的标签列表
  final RxSet<String> selectedTags = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTagsFromDatabase();
  }

  // 从数据库加载所有标签
  Future<void> _loadTagsFromDatabase() async {
    final loadedTags = await _itemService.getAllTags();
    allTags.assignAll(loadedTags);
  }

  // 添加新标签
  Future<bool> addTag(String name, Color color) async {
    if (allTags.any((tag) => tag.name == name)) {
      return false; // 标签已存在
    }
    final newTagId = await _itemService.saveTag(
      TagModel(id: 0, name: name, color: color),
    ); // id=0 是占位符，Drift 会生成
    final newTag = TagModel(id: newTagId, name: name, color: color);
    allTags.add(newTag);
    return true;
  }

  // 移除标签
  Future<void> removeTag(int id) async {
    await _itemService.deleteTag(id);
    allTags.removeWhere((tag) => tag.id == id);
    // 如果被删除的标签在 selectedTags 中，也要移除
    selectedTags.removeWhere(
      (tagName) =>
          tagName ==
          allTags.firstWhereOrNull((tag) => tag.id == id)?.name,
    );
  }

  // 切换标签选择状态
  void toggleTag(String tagName) {
    if (selectedTags.contains(tagName)) {
      selectedTags.remove(tagName);
    } else {
      selectedTags.add(tagName);
    }
  }

  // 根据标签筛选物品
  List<ItemModel> filterItems(List<ItemModel> allItems) {
    if (selectedTags.isEmpty) return allItems;
    return allItems.where((item) {
      return item.tags.any((tag) => selectedTags.contains(tag.name));
    }).toList();
  }
}
