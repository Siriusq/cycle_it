import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../services/item_service.dart';
import '../utils/constants.dart';
import '../utils/icomoon.dart';
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
  final Rx<IconData>
  selectedIconData; // Holds the selected IconData object
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
  final List<IconData> availableIcomoonIcons = [
    Icomoon.announcement,
    Icomoon.artist,
    Icomoon.beverage,
    Icomoon.box,
    Icomoon.brightnessUp,
    Icomoon.calculator,
    Icomoon.camera,
    Icomoon.clipboard,
    Icomoon.cloud,
    Icomoon.coffee,
    Icomoon.cog,
    Icomoon.compose,
    Icomoon.computerDesktop,
    Icomoon.computerLaptop,
    Icomoon.creditCard,
    Icomoon.editCut,
    Icomoon.editPencil,
    Icomoon.envelope,
    Icomoon.explore,
    Icomoon.film,
    Icomoon.flashlight,
    Icomoon.folderOutline,
    Icomoon.gift,
    Icomoon.hardDrive,
    Icomoon.headphones,
    Icomoon.inbox,
    Icomoon.key,
    Icomoon.keyboard,
    Icomoon.lightBulb,
    Icomoon.locationFood,
    Icomoon.locationGasStation,
    Icomoon.locationHotel,
    Icomoon.locationMarina,
    Icomoon.locationPark,
    Icomoon.mic,
    Icomoon.mobileDevices,
    Icomoon.mouse,
    Icomoon.musicAlbum,
    Icomoon.musicNotes,
    Icomoon.network,
    Icomoon.newsPaper,
    Icomoon.notifications,
    Icomoon.penTool,
    Icomoon.phone,
    Icomoon.photo,
    Icomoon.pin,
    Icomoon.playOutline,
    Icomoon.plugin,
    Icomoon.portfolio,
    Icomoon.printer,
    Icomoon.radar,
    Icomoon.radio,
    Icomoon.saveDisk,
    Icomoon.search,
    Icomoon.servers,
    Icomoon.shoppingCart,
    Icomoon.standBy,
    Icomoon.stethoscope,
    Icomoon.tablet,
    Icomoon.thermometer,
    Icomoon.time,
    Icomoon.trash,
    Icomoon.travelBus,
    Icomoon.travelTaxiCab,
    Icomoon.travelTrain,
    Icomoon.usb,
    Icomoon.videoCamera,
    Icomoon.volumeUp,
    Icomoon.watch,
    Icomoon.batteryCharging,
    Icomoon.microphone,
    Icomoon.tag,
    Icomoon.heart,
    Icomoon.star,
    Icomoon.flag,
    Icomoon.lock,
    Icomoon.bullhorn,
    Icomoon.screen,
    Icomoon.phone1,
    Icomoon.phonePortrait,
    Icomoon.phoneLandscape,
    Icomoon.tablet1,
    Icomoon.tabletLandscape,
    Icomoon.laptop,
    Icomoon.camera1,
    Icomoon.microwaveoven,
    Icomoon.creditcards,
    Icomoon.calculator1,
    Icomoon.bag,
    Icomoon.sun,
    Icomoon.coffee1,
    Icomoon.uniE95B,
    Icomoon.barbell,
    Icomoon.syringe,
    Icomoon.health,
    Icomoon.pill,
    Icomoon.lab,
    Icomoon.mug,
    Icomoon.bucket,
    Icomoon.power,
    Icomoon.homeOutline,
    Icomoon.trash1,
    Icomoon.rssOutline,
    Icomoon.linkOutline,
    Icomoon.imageOutline,
    Icomoon.cross,
    Icomoon.wiFiOutline,
    Icomoon.starOutline,
    Icomoon.mail,
    Icomoon.heartOutline,
    Icomoon.flashOutline,
    Icomoon.beaker,
    Icomoon.watch1,
    Icomoon.time1,
    Icomoon.locationArrowOutline,
    Icomoon.infoOutline,
    Icomoon.attachmentOutline,
    Icomoon.lockClosedOutline,
    Icomoon.videoOutline,
    Icomoon.pointOfInterestOutline,
    Icomoon.keyOutline,
    Icomoon.infinityOutline,
    Icomoon.globeOutline,
    Icomoon.cameraOutline,
    Icomoon.scissorsOutline,
    Icomoon.downloadOutline,
    Icomoon.zoomOutline,
    Icomoon.tag1,
    Icomoon.pinOutline,
    Icomoon.batteryFull,
    Icomoon.batteryCharge,
    Icomoon.pipette,
    Icomoon.folder,
    Icomoon.pen,
    Icomoon.codeOutline,
    Icomoon.calculator2,
    Icomoon.gift1,
    Icomoon.database,
    Icomoon.bell,
    Icomoon.shoppingBag,
    Icomoon.powerOutline,
    Icomoon.notesOutline,
    Icomoon.deviceTablet,
    Icomoon.devicePhone,
    Icomoon.deviceLaptop,
    Icomoon.deviceDesktop,
    Icomoon.briefcase,
    Icomoon.stopwatch,
    Icomoon.spannerOutline,
    Icomoon.puzzleOutline,
    Icomoon.printer1,
    Icomoon.lightbulb,
    Icomoon.flagOutline,
    Icomoon.archive,
    Icomoon.planeOutline,
    Icomoon.phoneOutline,
    Icomoon.microphoneOutline,
    Icomoon.weatherSunny,
    Icomoon.weatherSnow,
    Icomoon.wine,
    Icomoon.ticket,
    Icomoon.tags,
    Icomoon.plug,
    Icomoon.headphones1,
    Icomoon.creditCard1,
    Icomoon.coffee2,
    Icomoon.beer,
    Icomoon.volumeUp1,
    Icomoon.tree,
    Icomoon.thermometer1,
    Icomoon.shoppingCart1,
    Icomoon.leaf,
    Icomoon.feather,
    Icomoon.phone2,
    Icomoon.tablet2,
    Icomoon.monitor,
    Icomoon.ipod,
    Icomoon.tv,
    Icomoon.camera2,
    Icomoon.camera3,
    Icomoon.film1,
    Icomoon.film2,
    Icomoon.microphone1,
    Icomoon.drink,
    Icomoon.drink1,
    Icomoon.drink2,
    Icomoon.drink3,
    Icomoon.coffee3,
    Icomoon.mug1,
    Icomoon.icecream,
    Icomoon.cake,
    Icomoon.inbox1,
    Icomoon.cog1,
    Icomoon.health1,
    Icomoon.suitcase,
    Icomoon.picture,
    Icomoon.android,
    Icomoon.cassette,
    Icomoon.watch2,
    Icomoon.chronometer,
    Icomoon.watch3,
    Icomoon.alarmclock,
    Icomoon.time2,
    Icomoon.headphones2,
    Icomoon.wallet,
    Icomoon.gamepad,
    Icomoon.alarm,
    Icomoon.phone3,
    Icomoon.phone4,
    Icomoon.trashcan,
    Icomoon.lab1,
    Icomoon.tie,
    Icomoon.football,
    Icomoon.eightball,
    Icomoon.bowling,
    Icomoon.bowlingpin,
    Icomoon.baseball,
    Icomoon.soccer,
    Icomoon.threedglasses,
    Icomoon.microwave,
    Icomoon.refrigerator,
    Icomoon.oven,
    Icomoon.washingmachine,
    Icomoon.mouse1,
    Icomoon.radio1,
    Icomoon.ninetoSwitch,
    Icomoon.key1,
    Icomoon.cord,
    Icomoon.locked,
    Icomoon.locked1,
    Icomoon.magnifier,
    Icomoon.lamp,
    Icomoon.lamp1,
    Icomoon.umbrella,
    Icomoon.bomb,
    Icomoon.archive1,
    Icomoon.battery,
    Icomoon.battery1,
    Icomoon.megaphone,
    Icomoon.pil,
    Icomoon.injection,
    Icomoon.thermometer2,
    Icomoon.lamp2,
    Icomoon.cube,
    Icomoon.box1,
    Icomoon.moneybag,
    Icomoon.ruler,
    Icomoon.ruler1,
    Icomoon.tools,
    Icomoon.screwdriver,
    Icomoon.paint,
    Icomoon.hammer,
    Icomoon.brush,
    Icomoon.pen1,
    Icomoon.volume,
    Icomoon.equalizer,
    Icomoon.calculator3,
    Icomoon.library,
    Icomoon.justice,
    Icomoon.hourglass,
    Icomoon.pencil,
    Icomoon.pen2,
    Icomoon.pin1,
    Icomoon.scissors,
    Icomoon.pig,
    Icomoon.bookmark,
    Icomoon.safe,
    Icomoon.envelope1,
    Icomoon.radioactive,
    Icomoon.music,
    Icomoon.presentation,
    Icomoon.heart1,
    Icomoon.piano,
    Icomoon.car,
    Icomoon.bike,
    Icomoon.truck,
    Icomoon.bus,
    Icomoon.bike1,
    Icomoon.microphone2,
    Icomoon.keyboard1,
    Icomoon.keyboard2,
    Icomoon.radio2,
    Icomoon.printer2,
    Icomoon.eyedropper,
    Icomoon.shipping,
    Icomoon.usb1,
  ];

  AddEditItemController({ItemModel? initialItem})
    : _initialItem = initialItem,
      // Initialize selectedIconData with the item's icon or a default
      selectedIconData = Rx<IconData>(
        initialItem?.displayIcon ?? Icomoon.box,
      ), // <--- Initialize with IconData
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
      selectedIconData.value =
          _initialItem.displayIcon; // <--- Set IconData directly
      notifyBeforeNextUse.value = _initialItem.notifyBeforeNextUse;
      selectedTags.assignAll(_initialItem.tags);
    } else {
      // Set a default icon if adding a new item and none is selected
      if (availableIcomoonIcons.isNotEmpty) {
        selectedIconData.value =
            Icomoon.box; // <--- Default to your actual default icon
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
    // Check if an icon has been selected. Use a comparison with a known default/empty state.
    // If you always default to Icomoon.defaultIcon, this check might not be strictly necessary
    // unless you want to enforce a different selection.
    if (selectedIconData.value == Icomoon.box && !isEditing) {
      // Example: If default is not allowed for new items
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
          displayIcon:
              selectedIconData
                  .value, // <--- Use selectedIconData.value
          iconColor: selectedIconColor.value,
          usageRecords:
              _initialItem.usageRecords, // Preserve existing records
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
        await _itemController.updateItem(itemToSave);
      } else {
        // When adding, don't provide an ID, let Drift auto-generate
        itemToSave = ItemModel(
          id: null, // <--- Key change: Pass null for ID for new items
          name: nameController.text.trim(),
          usageComment:
              usageCommentController.text.trim().isEmpty
                  ? null
                  : usageCommentController.text.trim(),
          displayIcon:
              selectedIconData
                  .value, // <--- Use selectedIconData.value
          iconColor: selectedIconColor.value,
          usageRecords: [], // New item has no records initially
          notifyBeforeNextUse: notifyBeforeNextUse.value,
          tags: selectedTags.toList(),
        );
        await _itemController.addNewItem(itemToSave);
      }

      //_itemController.loadAllItems(); // This should be handled by your itemController after add/update
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
