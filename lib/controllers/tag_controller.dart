import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../test/mock_data.dart';

class TagController extends GetxController {
  // 所有标签
  final RxList<TagModel> allTags = <TagModel>[].obs;

  late int _nextId;

  // 当前已选中的标签列表
  final RxSet<String> selectedTags = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: mock数据替换为从数据库读取
    // 初始化 mock 数据
    allTags.assignAll(allTagsFromMock); // 避免名字冲突改名为 allTagsFromMock
    _initializeNextId();
  }

  // 初始化id
  void _initializeNextId() {
    if (allTags.isEmpty) {
      _nextId = 1;
    } else {
      // 获取当前 mockTags 中最大的 id，加 1
      _nextId = allTags.map((tag) => tag.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  // 添加新标签
  bool addTag(String name, Color color) {
    // 阻止重复添加
    if (allTags.any((tag) => tag.name == name)) return false;

    final newTag = TagModel(id: _nextId++, name: name, color: color);
    allTags.add(newTag);
    return true;
  }

  // 移除标签
  void removeTag(int id) {
    allTags.removeWhere((tag) => tag.id == id);
  }

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
