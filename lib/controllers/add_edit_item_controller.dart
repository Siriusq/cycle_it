import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import 'item_controller.dart'; // To refresh the main item list
import 'tag_controller.dart'; // To get available tags

class AddEditItemController extends GetxController {
  final ItemController _itemController = Get.find<ItemController>();
  final TagController _tagController = Get.find<TagController>();

  // Form Field Controllers
  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController usageCommentController =
      TextEditingController();

  // 用于物品名称输入框的错误信息
  final RxString nameErrorText = ''.obs;

  // Reactive Variables for Icon and Color selection
  final RxString selectedEmoji;
  final Rx<Color> selectedIconColor; // Default color

  // Reactive Variable for Notification Toggle
  final RxBool notifyBeforeNextUse = false.obs;

  // Reactive List for Selected Tags
  final RxList<TagModel> selectedTags = <TagModel>[].obs;

  // All available tags from TagController
  List<TagModel> get allAvailableTags => _tagController.allTags;

  // Item being edited (null for adding new item)
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
      // Populate fields if we're editing an existing item
      nameController.text = _initialItem.name;
      usageCommentController.text = _initialItem.usageComment ?? '';
      selectedEmoji.value = _initialItem.emoji; // <--- 设置 Emoji
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
    // Find if a tag with the same ID already exists in selectedTags
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
      final ItemModel itemToSave;

      if (isEditing) {
        // When editing, use the original ID
        itemToSave = ItemModel(
          id: _initialItem!.id,
          // Use the existing ID
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          emoji: selectedEmoji.value,
          iconColor: selectedIconColor.value,
          usageRecords: _initialItem.usageRecords,
          // Preserve existing records
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
        await _itemController.updateItem(itemToSave);
      } else {
        // When adding, don't provide an ID, let Drift auto-generate
        itemToSave = ItemModel(
          id: null,
          // <--- Key change: Pass null for ID for new items
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          emoji: selectedEmoji.value,
          // <--- Use selectedIconData.value
          iconColor: selectedIconColor.value,
          usageRecords: [],
          // New item has no records initially
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
        await _itemController.addNewItem(itemToSave);
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
