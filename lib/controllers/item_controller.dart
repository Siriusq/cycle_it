import 'package:get/get.dart';

import '../models/item_model.dart';
import '../models/usage_record_model.dart';

class ItemController extends GetxController {
  final currentItem = Rxn<ItemModel>();

  void selectItem(ItemModel item) {
    currentItem.value = item;
  }

  void clearSelection() {
    currentItem.value = null;
  }

  // 添加使用记录
  void addUsageRecord(DateTime usedAt) {
    final currentItemValue = currentItem.value!;
    final List<UsageRecordModel> records = List.from(
      currentItemValue.usageRecords,
    );

    // 生成新的记录ID (在实际应用中，ID应由数据库生成)
    final int newRecordId = records.isEmpty ? 1 : records.last.id + 1;

    // 计算与上次使用的时间间隔
    int? interval;
    if (records.isNotEmpty) {
      final lastRecord = records.last;
      interval = usedAt.difference(lastRecord.usedAt).inDays;
    }

    final newRecord = UsageRecordModel(
      id: newRecordId,
      itemId: currentItemValue.id,
      usedAt: usedAt,
      intervalSinceLastUse: interval,
    );

    records.add(newRecord);
    // 确保列表排序
    records.sort((a, b) => a.usedAt.compareTo(b.usedAt));

    // 创建新的 ItemModel 实例以更新 Rx
    currentItem.value = ItemModel(
      id: currentItemValue.id,
      name: currentItemValue.name,
      usageComment: currentItemValue.usageComment,
      usageRecords: records,
      // 使用更新后的列表
      tags: currentItemValue.tags,
      iconPath: currentItemValue.iconPath,
      iconColor: currentItemValue.iconColor,
      notifyBeforeNextUse: currentItemValue.notifyBeforeNextUse,
    )..invalidateCalculatedProperties(); // 清除缓存

    // todo: 持久化数据 saveItemToDatabase(currentItem.value);
  }
}
