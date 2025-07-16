import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/item_model.dart';
import '../../../../utils/responsive_layout.dart';
import '../../../../utils/responsive_style.dart';
import '../../../shared_widgets/responsive_component_group.dart';
import 'item_usage_stat_item.dart';

class ItemCardOverview extends StatelessWidget {
  final ItemModel item;

  const ItemCardOverview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    final int usageCount = item.usageRecords.length;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? firstUsedDate =
        usageCount > 0 ? item.usageRecords.first.usedAt : null;
    final DateTime? lastUsedDate =
        usageCount > 0 ? item.usageRecords.last.usedAt : null;
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingXS = style.spacingXS;
    final double spacingSM = style.spacingSM;
    final double iconSizeSM = style.iconSizeSM;

    if (!isTripleCol) {
      // 移动端
      return Padding(
        padding: EdgeInsets.only(
          left: 5,
          bottom: spacingSM,
          top: spacingSM,
        ),
        child: Column(
          children: [
            // 使用周期
            Row(
              children: [
                Icon(Icons.repeat, size: iconSizeSM),
                SizedBox(width: spacingXS),
                Flexible(
                  child: Text(
                    usageCount > 1
                        ? 'usage_cycle_brief'.trParams({
                          'freq': '$usageFrequency',
                        })
                        : 'usage_cycle_brief_data_not_enough'.tr,
                    style: smallBodyTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacingSM),
            // 上次使用
            Row(
              children: [
                Icon(Icons.history, size: iconSizeSM),
                SizedBox(width: spacingXS),
                Flexible(
                  child: Text(
                    lastUsedDate != null
                        ? 'last_used_at_brief'.trParams({
                          'date': DateFormat(
                            'yyyy-MM-dd',
                          ).format(lastUsedDate),
                        })
                        : 'last_used_at_brief_data_not_enough'.tr,
                    style: smallBodyTextStyle,
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
        child: ResponsiveComponentGroup(
          minComponentWidth: 160,
          aspectRation: 5,
          children: [
            // 上次使用
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
            // 使用次数
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
            // 使用周期
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
            // 下次使用预计
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
          ],
        ),
      );
    }
  }
}
