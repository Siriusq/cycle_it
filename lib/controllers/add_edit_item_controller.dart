import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import 'item_controller.dart';
import 'tag_controller.dart';

class AddEditItemController extends GetxController {
  final ItemController _itemController = Get.find<ItemController>();
  final TagController _tagController = Get.find<TagController>();

  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController usageCommentController =
      TextEditingController();

  // 用于物品名称输入框的错误信息
  final RxString nameErrorText = ''.obs;

  final RxString selectedEmoji;
  final Rx<Color> selectedIconColor;

  final RxBool notifyBeforeNextUse = false.obs;

  final RxList<TagModel> selectedTags = <TagModel>[].obs;

  // 所有的标签
  List<TagModel> get allAvailableTags => _tagController.allTags;

  // 被编辑的物品，添加时为空
  final ItemModel? _initialItem;

  bool get isEditing => _initialItem != null;

  AddEditItemController({ItemModel? initialItem})
    : _initialItem = initialItem,
      selectedEmoji = RxString(initialItem?.emoji ?? '📦'),
      // 默认给一个Emoji
      selectedIconColor = Rx<Color>(
        initialItem?.iconColor ??
            Get.theme.colorScheme.surfaceContainerHighest,
      );

  @override
  void onInit() {
    super.onInit();
    if (_initialItem != null) {
      // 编辑时，自动填充被编辑物品的信息
      nameController.text = _initialItem.name;
      usageCommentController.text = _initialItem.usageComment ?? '';
      selectedEmoji.value = _initialItem.emoji;
      selectedIconColor.value = _initialItem.iconColor;
      notifyBeforeNextUse.value = _initialItem.notifyBeforeNextUse;
      selectedTags.assignAll(_initialItem.tags);
    } else {
      selectedEmoji.value = '📦';
      selectedIconColor.value =
          Get.theme.colorScheme.surfaceContainerHighest;
    }
  }

  void toggleTag(TagModel tag) {
    // 判断tag是否已存在于物品上
    final existingTagIndex = selectedTags.indexWhere(
      (t) => t.id == tag.id,
    );
    if (existingTagIndex != -1) {
      selectedTags.removeAt(existingTagIndex);
    } else {
      selectedTags.add(tag);
    }
  }

  // 方法来选择 emoji (供 emoji_picker_flutter 调用)
  void chooseEmoji(String emoji) {
    selectedEmoji.value = emoji;
  }

  Future<String?> saveItem() async {
    // 每次保存前清除之前的名称错误信息
    nameErrorText.value = '';

    if (nameController.text.trim().isEmpty) {
      nameErrorText.value = 'item_name_empty'.tr; // 设置名称错误信息
      return 'item_name_empty'; // 返回错误类型，供 AppBar 判断
    }

    if (nameController.text.trim().length > 50) {
      nameErrorText.value = 'item_name_too_long'.tr; // 设置名称错误信息
      return 'item_name_too_long'; // 返回错误类型，供 AppBar 判断
    }

    if (selectedEmoji.value.isEmpty) {
      // Emoji 错误
      return 'emoji_empty';
    }

    try {
      if (isEditing) {
        // 编辑时，创建一个不包含使用记录的 ItemModel，并调用安全的更新方法
        final itemToUpdate = ItemModel(
          id: _initialItem!.id,
          // Use the existing ID
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          emoji: selectedEmoji.value,
          iconColor: selectedIconColor.value,
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
          usageCount: _initialItem.usageCount,
          lastUsedDate: _initialItem.lastUsedDate,
          avgInterval: _initialItem.avgInterval,
          firstUsedDate: _initialItem.firstUsedDate,
        );
        await _itemController.updateItemDetails(itemToUpdate);
      } else {
        // 添加时不指定ID，让Drift自己生成
        final itemToAdd = ItemModel(
          id: null,
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          emoji: selectedEmoji.value,
          iconColor: selectedIconColor.value,
          usageRecords: [],
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
        await _itemController.addNewItem(itemToAdd);
      }
    } catch (e) {
      return 'Fatal Error: $e';
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    usageCommentController.dispose();
    super.onClose();
  }
}
