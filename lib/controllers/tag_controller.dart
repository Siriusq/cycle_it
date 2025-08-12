import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/models/tag_model.dart';
import 'package:cycle_it/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // 检查标签名是否已存在，不区分大小写
    if (allTags.any(
      (tag) => tag.name.toLowerCase() == name.toLowerCase(),
    )) {
      return false; // 标签已存在
    }
    final newTagId = await _itemService.saveTag(
      TagModel(id: 0, name: name, color: color),
    ); // id=0 是占位符，Drift 会生成
    final newTag = TagModel(id: newTagId, name: name, color: color);
    allTags.add(newTag);
    return true;
  }

  // 更新标签
  Future<bool> updateTag(
    TagModel originalTag,
    String newName,
    Color newColor,
  ) async {
    // 如果名称改变了，检查新名称是否与其他现有标签冲突（除了自身）
    if (originalTag.name.toLowerCase() != newName.toLowerCase() &&
        allTags.any(
          (tag) => tag.name.toLowerCase() == newName.toLowerCase(),
        )) {
      return false; // 新标签名已存在
    }

    final updatedTag = TagModel(
      id: originalTag.id,
      name: newName,
      color: newColor,
    );

    final success = await _itemService.updateTag(updatedTag);
    if (success) {
      final index = allTags.indexWhere(
        (tag) => tag.id == originalTag.id,
      );
      if (index != -1) {
        allTags[index] = updatedTag; // 更新RxList中的标签
        // 如果标签名改变了，也需要更新selectedTags中的名称
        if (originalTag.name != newName &&
            selectedTags.contains(originalTag.name)) {
          selectedTags.remove(originalTag.name);
          selectedTags.add(newName);
        }
      }
      return true;
    }
    return false;
  }

  // 移除标签
  Future<void> removeTag(int id) async {
    final tagToRemove = allTags.firstWhereOrNull(
      (tag) => tag.id == id,
    );
    if (tagToRemove == null) return;

    await _itemService.deleteTag(id);
    allTags.removeWhere((tag) => tag.id == id);
    // 如果被删除的标签在 selectedTags 中，也要移除
    selectedTags.removeWhere(
      (tagName) => tagName == tagToRemove.name,
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
