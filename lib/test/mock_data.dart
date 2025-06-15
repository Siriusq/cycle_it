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
        name:
            'A Marvel Rice Cooker with Super Capacity and Endless Power Supply',
        usageComment: 'Clean Inside',
        emoji: '🍯',
        iconColor: Colors.orange,
        usageRecords: [
          UsageRecordModel(
            id: 0,
            itemId: 1,
            usedAt: DateTime.now().subtract(Duration(days: 90)),
          ),
          UsageRecordModel(
            id: 1,
            itemId: 1,
            usedAt: DateTime.now().subtract(Duration(days: 80)),
          ),
          UsageRecordModel(
            id: 2,
            itemId: 1,
            usedAt: DateTime.now().subtract(Duration(days: 60)),
          ),
        ],
        tags: [
          allTagsFromMock[0],
          allTagsFromMock[1],
          allTagsFromMock[2],
        ],
      ),
      ItemModel(
        id: 2,
        name:
            'A Marvel Rice Cooker with Super Capacity and Endless Power Supply',
        usageComment:
            'A Marvel Rice Cooker with Super Capacity and Endless Power Supply',
        emoji: '✨',
        iconColor: Colors.blueGrey,
        usageRecords: [
          UsageRecordModel(
            id: 3,
            itemId: 2,
            usedAt: DateTime.now().subtract(Duration(days: 200)),
          ),
          UsageRecordModel(
            id: 4,
            itemId: 2,
            usedAt: DateTime.now().subtract(Duration(days: 150)),
          ),
          UsageRecordModel(
            id: 5,
            itemId: 2,
            usedAt: DateTime.now().subtract(Duration(days: 100)),
          ),
        ],
        tags: [allTagsFromMock[2]],
      ),
      ItemModel(
        id: 3,
        name: 'Laptop',
        usageComment: 'Recharge Battery',
        emoji: '🖥',
        iconColor: Colors.grey,
        usageRecords: [
          UsageRecordModel(
            id: 6,
            itemId: 3,
            usedAt: DateTime.now().subtract(Duration(days: 365)),
          ),
          UsageRecordModel(
            id: 7,
            itemId: 3,
            usedAt: DateTime.now().subtract(Duration(days: 200)),
          ),
          UsageRecordModel(
            id: 8,
            itemId: 3,
            usedAt: DateTime.now().subtract(Duration(days: 120)),
          ),
          UsageRecordModel(
            id: 9,
            itemId: 3,
            usedAt: DateTime.now().subtract(Duration(days: 10)),
          ),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[3]],
      ),
      ItemModel(
        id: 4,
        name: 'Screwdriver',
        emoji: '🛠',
        iconColor: Colors.red,
        usageRecords: [
          UsageRecordModel(
            id: 10,
            itemId: 4,
            usedAt: DateTime.now().subtract(Duration(days: 48)),
          ),
        ],
        tags: [allTagsFromMock[4]],
      ),
      ItemModel(
        id: 5,
        name: 'Camera',
        emoji: '📷',
        iconColor: Colors.black,
        usageRecords: [
          UsageRecordModel(
            id: 11,
            itemId: 5,
            usedAt: DateTime.now().subtract(Duration(days: 130)),
          ),
          UsageRecordModel(
            id: 12,
            itemId: 5,
            usedAt: DateTime.now().subtract(Duration(days: 90)),
          ),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[5]],
      ),
      ItemModel(
        id: 6,
        name: 'Notebook',
        emoji: '💻',
        iconColor: Colors.green,
        usageRecords: [
          UsageRecordModel(
            id: 13,
            itemId: 6,
            usedAt: DateTime.now().subtract(Duration(days: 30)),
          ),
          UsageRecordModel(
            id: 14,
            itemId: 6,
            usedAt: DateTime.now().subtract(Duration(days: 20)),
          ),
        ],
        tags: [allTagsFromMock[3]],
      ),
      ItemModel(
        id: 7,
        name: 'Electric Fan',
        emoji: '🌊',
        iconColor: Colors.lightBlue,
        usageRecords: [
          UsageRecordModel(
            id: 15,
            itemId: 7,
            usedAt: DateTime.now().subtract(Duration(days: 300)),
          ),
          UsageRecordModel(
            id: 16,
            itemId: 7,
            usedAt: DateTime.now().subtract(Duration(days: 200)),
          ),
          UsageRecordModel(
            id: 17,
            itemId: 7,
            usedAt: DateTime.now().subtract(Duration(days: 100)),
          ),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[2]],
      ),
      ItemModel(
        id: 8,
        name: 'Sketchbook',
        emoji: '📒',
        iconColor: Colors.purple,
        usageRecords: [
          UsageRecordModel(
            id: 18,
            itemId: 8,
            usedAt: DateTime.now().subtract(Duration(days: 110)),
          ),
          UsageRecordModel(
            id: 19,
            itemId: 8,
            usedAt: DateTime.now().subtract(Duration(days: 60)),
          ),
        ],
        tags: [allTagsFromMock[5]],
      ),
      ItemModel(
        id: 9,
        name: 'Thermos Bottle',
        emoji: '💦',
        iconColor: Colors.teal,
        usageRecords: [
          UsageRecordModel(
            id: 20,
            itemId: 9,
            usedAt: DateTime.now().subtract(Duration(days: 180)),
          ),
        ],
        tags: [allTagsFromMock[0], allTagsFromMock[2]],
      ),
      ItemModel(
        id: 10,
        name: 'Wireless Mouse',
        emoji: '🖱',
        iconColor: Colors.brown,
        usageRecords: [
          UsageRecordModel(
            id: 21,
            itemId: 10,
            usedAt: DateTime.now().subtract(Duration(days: 70)),
          ),
          UsageRecordModel(
            id: 22,
            itemId: 10,
            usedAt: DateTime.now().subtract(Duration(days: 60)),
          ),
          UsageRecordModel(
            id: 23,
            itemId: 10,
            usedAt: DateTime.now().subtract(Duration(days: 10)),
          ),
        ],
        tags: [allTagsFromMock[1], allTagsFromMock[3]],
      ),
      ItemModel(
        id: 11,
        name: 'No Usage Record Test Item',
        emoji: '🍩',
        iconColor: Colors.black,
        usageRecords: [],
        tags: [allTagsFromMock[2], allTagsFromMock[3]],
      ),
    ].obs;
