import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/tag_model.dart';
import '../models/usage_record_model.dart';

final List<TagModel> allTagsFromMock =
    [
      TagModel(id: 1, name: 'Kitchen', color: kColorPalette[0]),
      TagModel(id: 2, name: 'Electronics', color: kColorPalette[1]),
      TagModel(id: 3, name: 'Seasonal', color: kColorPalette[2]),
      TagModel(id: 4, name: 'Office', color: kColorPalette[3]),
      TagModel(id: 5, name: 'Tools', color: kColorPalette[4]),
      TagModel(id: 6, name: 'Hobby', color: kColorPalette[5]),
    ].obs;

final List<ItemModel> sampleItems =
    [
      ItemModel(
        id: 1,
        name: 'A Marvel Rice Cooker with Super Capacity and Endless Power Supply',
        iconPath: 'assets/item_icons/appliances/cooking-pot.svg',
        iconColor: Colors.orange,
        firstUsed: DateTime.now().subtract(Duration(days: 90)),
        usageRecords: [
          UsageRecordModel(id: 1, itemId: 1, usedAt: DateTime.now().subtract(Duration(days: 80))),
          UsageRecordModel(id: 2, itemId: 1, usedAt: DateTime.now().subtract(Duration(days: 60))),
        ],
        tags: [allTagsFromMock[0], allTagsFromMock[1], allTagsFromMock[2]],
      ),
      ItemModel(
        id: 2,
        name: 'Winter Jacket',
        iconPath: 'assets/item_icons/others/flower.svg',
        iconColor: Colors.blueGrey,
        firstUsed: DateTime.now().subtract(Duration(days: 200)),
        usageRecords: [
          UsageRecordModel(id: 3, itemId: 2, usedAt: DateTime.now().subtract(Duration(days: 150))),
          UsageRecordModel(id: 4, itemId: 2, usedAt: DateTime.now().subtract(Duration(days: 100))),
        ],
        tags: [allTagsFromMock[2]],
      ),
      ItemModel(
        id: 3,
        name: 'Laptop',
        iconPath: 'assets/item_icons/electronics/laptop.svg',
        iconColor: Colors.grey,
        firstUsed: DateTime.now().subtract(Duration(days: 365)),
        usageRecords: [
          UsageRecordModel(id: 5, itemId: 3, usedAt: DateTime.now().subtract(Duration(days: 10))),
          UsageRecordModel(id: 6, itemId: 3, usedAt: DateTime.now().subtract(Duration(days: 5))),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[3]],
      ),
      ItemModel(
        id: 4,
        name: 'Screwdriver',
        iconPath: 'assets/item_icons/appliances/screwdriver.svg',
        iconColor: Colors.red,
        firstUsed: DateTime.now().subtract(Duration(days: 50)),
        usageRecords: [UsageRecordModel(id: 7, itemId: 4, usedAt: DateTime.now().subtract(Duration(days: 48)))],
        tags: [allTagsFromMock[4]],
      ),
      ItemModel(
        id: 5,
        name: 'Camera',
        iconPath: 'assets/item_icons/entertainment/camera-0.svg',
        iconColor: Colors.black,
        firstUsed: DateTime.now().subtract(Duration(days: 150)),
        usageRecords: [
          UsageRecordModel(id: 8, itemId: 5, usedAt: DateTime.now().subtract(Duration(days: 130))),
          UsageRecordModel(id: 9, itemId: 5, usedAt: DateTime.now().subtract(Duration(days: 90))),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[5]],
      ),
      ItemModel(
        id: 6,
        name: 'Notebook',
        iconPath: 'assets/item_icons/electronics/ipad-1.svg',
        iconColor: Colors.green,
        firstUsed: DateTime.now().subtract(Duration(days: 30)),
        usageRecords: [UsageRecordModel(id: 10, itemId: 6, usedAt: DateTime.now().subtract(Duration(days: 20)))],
        tags: [allTagsFromMock[3]],
      ),
      ItemModel(
        id: 7,
        name: 'Electric Fan',
        iconPath: 'assets/item_icons/others/fan.svg',
        iconColor: Colors.lightBlue,
        firstUsed: DateTime.now().subtract(Duration(days: 300)),
        usageRecords: [
          UsageRecordModel(id: 11, itemId: 7, usedAt: DateTime.now().subtract(Duration(days: 200))),
          UsageRecordModel(id: 12, itemId: 7, usedAt: DateTime.now().subtract(Duration(days: 100))),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[2]],
      ),
      ItemModel(
        id: 8,
        name: 'Sketchbook',
        iconPath: 'assets/item_icons/electronics/painted-screen.svg',
        iconColor: Colors.purple,
        firstUsed: DateTime.now().subtract(Duration(days: 120)),
        usageRecords: [
          UsageRecordModel(id: 13, itemId: 8, usedAt: DateTime.now().subtract(Duration(days: 110))),
          UsageRecordModel(id: 14, itemId: 8, usedAt: DateTime.now().subtract(Duration(days: 60))),
        ],
        tags: [allTagsFromMock[5]],
      ),
      ItemModel(
        id: 9,
        name: 'Thermos Bottle',
        iconPath: 'assets/item_icons/appliances/boiler.svg',
        iconColor: Colors.teal,
        firstUsed: DateTime.now().subtract(Duration(days: 200)),
        usageRecords: [UsageRecordModel(id: 15, itemId: 9, usedAt: DateTime.now().subtract(Duration(days: 180)))],
        tags: [allTagsFromMock[0], allTagsFromMock[2]],
      ),
      ItemModel(
        id: 10,
        name: 'Wireless Mouse',
        iconPath: 'assets/item_icons/electronics/mouse-0.svg',
        iconColor: Colors.brown,
        firstUsed: DateTime.now().subtract(Duration(days: 70)),
        usageRecords: [
          UsageRecordModel(id: 16, itemId: 10, usedAt: DateTime.now().subtract(Duration(days: 60))),
          UsageRecordModel(id: 17, itemId: 10, usedAt: DateTime.now().subtract(Duration(days: 10))),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[3]],
      ),
    ].obs;
