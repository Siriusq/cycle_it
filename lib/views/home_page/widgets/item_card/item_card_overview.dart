import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/item_model.dart';
import 'item_usage_stat_item.dart';

class ItemCardOverview extends StatelessWidget {
  final ItemModel item;

  const ItemCardOverview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    // 读取预先计算好的统计数据
    final int usageCount = item.usageCount;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? firstUsedDate = item.firstUsedDate;
    final DateTime? lastUsedDate = item.lastUsedDate;
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    final TextStyle bodySM = Theme.of(context).textTheme.bodySmall!;

    if (isSingleCol) {
      // 移动端
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
        child: Column(
          spacing: 4,
          children: [
            // 使用周期
            Row(
              children: [
                Icon(Icons.repeat, size: 12),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    usageCount > 1
                        ? 'usage_cycle_brief'.trParams({
                          'freq': '$usageFrequency',
                        })
                        : 'usage_cycle_brief_data_not_enough'.tr,
                    style: bodySM,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // 上次使用
            Row(
              children: [
                Icon(Icons.history, size: 12),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    lastUsedDate != null
                        ? 'last_used_at_brief'.trParams({
                          'date': DateFormat(
                            'yyyy-MM-dd',
                          ).format(lastUsedDate),
                        })
                        : 'last_used_at_brief_data_not_enough'.tr,
                    style: bodySM,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // 桌面布局
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  Expanded(
                    child: // 上次使用
                        ItemUsageStatItem(
                      icon: Icons.history,
                      title: 'last_used_at'.tr,
                      value:
                          lastUsedDate != null
                              ? 'last_used_at_brief_data'.trParams({
                                'date': DateFormat(
                                  'yyyy-MM-dd',
                                ).format(lastUsedDate),
                              })
                              : 'data_not_enough'.tr,
                    ),
                  ),
                  Expanded(
                    child: // 使用次数
                        ItemUsageStatItem(
                      icon: Icons.pin_outlined,
                      title: 'usage_count'.tr,
                      value:
                          firstUsedDate != null
                              ? 'usage_count_brief_data'.trParams({
                                'count': '$usageCount',
                              })
                              : 'no_usage_records'.tr,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  Expanded(
                    child: // 使用周期
                        ItemUsageStatItem(
                      icon: Icons.repeat,
                      title: 'usage_cycle'.tr,
                      value:
                          usageCount > 1
                              ? 'usage_cycle_brief_data'.trParams({
                                'freq': '$usageFrequency',
                              })
                              : 'data_not_enough'.tr,
                    ),
                  ),
                  Expanded(
                    child: // 下次使用预计
                        ItemUsageStatItem(
                      icon: Icons.update,
                      title: 'est_next_use_date'.tr,
                      value:
                          nextExpectedUseDate != null
                              ? 'est_next_use_date_data'.trParams({
                                'date': DateFormat(
                                  'yyyy-MM-dd',
                                ).format(nextExpectedUseDate),
                              })
                              : 'data_not_enough'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
