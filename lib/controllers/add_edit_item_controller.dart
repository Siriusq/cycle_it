import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../services/item_service.dart';
import '../utils/constants.dart';
import 'item_controller.dart'; // To refresh the main item list
import 'tag_controller.dart'; // To get available tags

class AddEditItemController extends GetxController {
  final ItemService _itemService = Get.find<ItemService>();
  final ItemController _itemController = Get.find<ItemController>();
  final TagController _tagController = Get.find<TagController>();

  // Form Field Controllers
  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController usageCommentController =
      TextEditingController();

  // Reactive Variables for Icon and Color selection
  final RxString selectedIconPath = ''.obs;
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

  // List of SVG icons
  final List<String> svgIconPaths = [
    'assets/item_icons/appliances/balance-0.svg',
    'assets/item_icons/appliances/balance-1.svg',
    'assets/item_icons/appliances/barber-clippers.svg',
    'assets/item_icons/appliances/boiler.svg',
    'assets/item_icons/appliances/calculator.svg',
    'assets/item_icons/appliances/coffee-machine.svg',
    'assets/item_icons/appliances/cooking-pot.svg',
    'assets/item_icons/appliances/electric-drill.svg',
    'assets/item_icons/appliances/electric-iron.svg',
    'assets/item_icons/appliances/electronic-pen.svg',
    'assets/item_icons/appliances/experiment.svg',
    'assets/item_icons/appliances/fish.svg',
    'assets/item_icons/appliances/flashlight.svg',
    'assets/item_icons/appliances/hair-dryer.svg',
    'assets/item_icons/appliances/hammer-and-anvil.svg',
    'assets/item_icons/appliances/handwashing-fluid.svg',
    'assets/item_icons/appliances/industrial-scales.svg',
    'assets/item_icons/appliances/intercom.svg',
    'assets/item_icons/appliances/iron.svg',
    'assets/item_icons/appliances/measuring-cup.svg',
    'assets/item_icons/appliances/oven.svg',
    'assets/item_icons/appliances/robot.svg',
    'assets/item_icons/appliances/ruler.svg',
    'assets/item_icons/appliances/screwdriver.svg',
    'assets/item_icons/appliances/shaver-0.svg',
    'assets/item_icons/appliances/shaver-1.svg',
    'assets/item_icons/appliances/shower-head.svg',
    'assets/item_icons/appliances/snacks.svg',
    'assets/item_icons/appliances/soybean-milk-maker.svg',
    'assets/item_icons/appliances/stapler.svg',
    'assets/item_icons/appliances/tape-measure.svg',
    'assets/item_icons/appliances/tea-drink.svg',
    'assets/item_icons/appliances/thermometer.svg',
    'assets/item_icons/appliances/toilet.svg',
    'assets/item_icons/appliances/tub.svg',
    'assets/item_icons/appliances/vacuum-cleaner.svg',
    'assets/item_icons/appliances/washing-machine.svg',
    'assets/item_icons/appliances/water-level.svg',
    'assets/item_icons/electronics/computer-0.svg',
    'assets/item_icons/electronics/computer-1.svg',
    'assets/item_icons/electronics/devices.svg',
    'assets/item_icons/electronics/drone.svg',
    'assets/item_icons/electronics/earphone-0.svg',
    'assets/item_icons/electronics/earphone-1.svg',
    'assets/item_icons/electronics/earphone-2.svg',
    'assets/item_icons/electronics/glasses-ar.svg',
    'assets/item_icons/electronics/glasses-vr.svg',
    'assets/item_icons/electronics/hard-disk.svg',
    'assets/item_icons/electronics/hdd.svg',
    'assets/item_icons/electronics/headwear.svg',
    'assets/item_icons/electronics/ipad-0.svg',
    'assets/item_icons/electronics/ipad-1.svg',
    'assets/item_icons/electronics/iphone.svg',
    'assets/item_icons/electronics/keyboard.svg',
    'assets/item_icons/electronics/laptop.svg',
    'assets/item_icons/electronics/logo-android.svg',
    'assets/item_icons/electronics/logo-apple.svg',
    'assets/item_icons/electronics/logo-microsoft.svg',
    'assets/item_icons/electronics/mouse-0.svg',
    'assets/item_icons/electronics/mouse-1.svg',
    'assets/item_icons/electronics/painted-screen.svg',
    'assets/item_icons/electronics/pen.svg',
    'assets/item_icons/electronics/power-bank.svg',
    'assets/item_icons/electronics/printer.svg',
    'assets/item_icons/electronics/ring.svg',
    'assets/item_icons/electronics/router.svg',
    'assets/item_icons/electronics/usb.svg',
    'assets/item_icons/electronics/watch-0.svg',
    'assets/item_icons/electronics/watch-1.svg',
    'assets/item_icons/electronics/watch-2.svg',
    'assets/item_icons/electronics/watch-3.svg',
    'assets/item_icons/electronics/wifi.svg',
    'assets/item_icons/entertainment/camera-0.svg',
    'assets/item_icons/entertainment/camera-1.svg',
    'assets/item_icons/entertainment/camera-2.svg',
    'assets/item_icons/entertainment/camera-3.svg',
    'assets/item_icons/entertainment/camera-4.svg',
    'assets/item_icons/entertainment/camera-5.svg',
    'assets/item_icons/entertainment/camera-gopro.svg',
    'assets/item_icons/entertainment/camera-vedio.svg',
    'assets/item_icons/entertainment/cd.svg',
    'assets/item_icons/entertainment/game-console.svg',
    'assets/item_icons/entertainment/game-handle.svg',
    'assets/item_icons/entertainment/game-ps.svg',
    'assets/item_icons/entertainment/game-switch.svg',
    'assets/item_icons/entertainment/game.svg',
    'assets/item_icons/entertainment/microphone-0.svg',
    'assets/item_icons/entertainment/microphone-1.svg',
    'assets/item_icons/entertainment/phonograph.svg',
    'assets/item_icons/entertainment/ppt.svg',
    'assets/item_icons/entertainment/projector.svg',
    'assets/item_icons/entertainment/radio.svg',
    'assets/item_icons/entertainment/speaker-0.svg',
    'assets/item_icons/entertainment/speaker-1.svg',
    'assets/item_icons/entertainment/tv.svg',
    'assets/item_icons/others/air-bike.svg',
    'assets/item_icons/others/air-conditioning.svg',
    'assets/item_icons/others/bank-card.svg',
    'assets/item_icons/others/battery-storage.svg',
    'assets/item_icons/others/box.svg',
    'assets/item_icons/others/car-battery.svg',
    'assets/item_icons/others/cardioelectric.svg',
    'assets/item_icons/others/clock.svg',
    'assets/item_icons/others/control-0.svg',
    'assets/item_icons/others/control-1.svg',
    'assets/item_icons/others/default.svg',
    'assets/item_icons/others/desk-lamp.svg',
    'assets/item_icons/others/dome-light.svg',
    'assets/item_icons/others/door-0.svg',
    'assets/item_icons/others/door-1.svg',
    'assets/item_icons/others/electric-wave.svg',
    'assets/item_icons/others/fan.svg',
    'assets/item_icons/others/flower.svg',
    'assets/item_icons/others/key.svg',
    'assets/item_icons/others/lightning.svg',
    'assets/item_icons/others/motor.svg',
    'assets/item_icons/others/petrol.svg',
    'assets/item_icons/others/piano.svg',
    'assets/item_icons/others/plug-0.svg',
    'assets/item_icons/others/plug-1.svg',
    'assets/item_icons/others/plug-2.svg',
    'assets/item_icons/others/pokeball.svg',
    'assets/item_icons/others/telephone.svg',
    'assets/item_icons/others/tips.svg',
    'assets/item_icons/others/treadmill.svg',
    'assets/item_icons/others/trunk.svg',
    'assets/item_icons/others/wallet.svg',
    'assets/item_icons/others/warning.svg',
  ];

  AddEditItemController({ItemModel? initialItem})
    : _initialItem = initialItem,
      selectedIconColor = Rx<Color>(
        initialItem?.iconColor ?? kPrimaryColor,
      );

  @override
  void onInit() {
    super.onInit();
    if (_initialItem != null) {
      // Populate fields if we're editing an existing item
      nameController.text = _initialItem.name;
      usageCommentController.text = _initialItem.usageComment ?? '';
      selectedIconPath.value = _initialItem.iconPath;
      //selectedIconColor.value = initialItem!.iconColor;
      notifyBeforeNextUse.value = _initialItem.notifyBeforeNextUse;
      selectedTags.assignAll(_initialItem.tags);
    } else {
      // Set a default icon if adding a new item and none is selected
      if (svgIconPaths.isNotEmpty) {
        selectedIconPath.value = svgIconPaths.first;
      }
    }
  }

  void toggleTag(TagModel tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  Future<void> saveItem() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        '错误',
        '物品名称不能为空',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedIconPath.value.isEmpty) {
      Get.snackbar(
        '错误',
        '请选择一个图标',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final ItemModel itemToSave;

      if (isEditing) {
        // When editing, use the original ID
        itemToSave = ItemModel(
          id: _initialItem!.id, // Use the existing ID
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          iconPath: selectedIconPath.value,
          iconColor: selectedIconColor.value,
          usageRecords:
              _initialItem.usageRecords, // Preserve existing records
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
      } else {
        // When adding, don't provide an ID, let Drift auto-generate
        itemToSave = ItemModel(
          id: null, // <--- Key change: Pass null for ID for new items
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          iconPath: selectedIconPath.value,
          iconColor: selectedIconColor.value,
          usageRecords: [], // New item has no records initially
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
      }

      await _itemService.saveItem(
        itemToSave,
      ); // _itemService.saveItem will now handle the upsert logic

      if (isEditing) {
        Get.snackbar(
          '成功',
          '${itemToSave.name} 更新成功！',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '成功',
          '${itemToSave.name} 添加成功！',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      _itemController.loadAllItems();
      Get.back();
    } catch (e) {
      Get.snackbar(
        '错误',
        '操作失败: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Save Item Error: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usageCommentController.dispose();
    super.onClose();
  }
}
