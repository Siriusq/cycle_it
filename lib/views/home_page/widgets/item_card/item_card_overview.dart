import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/item_model.dart';
import '../../../../utils/constants.dart';
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
                Icon(
                  Icons.repeat,
                  color: kTextColor,
                  size: iconSizeSM,
                ),
                SizedBox(width: spacingXS),
                Flexible(
                  child: Text(
                    "Usage Cycle: ${usageCount > 1 ? '$usageFrequency days' : 'data not enough'}",
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
                Icon(
                  Icons.history,
                  color: kTextColor,
                  size: iconSizeSM,
                ),
                SizedBox(width: spacingXS),
                Flexible(
                  child: Text(
                    "Last Used: ${lastUsedDate != null ? DateFormat('yyyy-MM-dd').format(lastUsedDate) : 'data not enough'}",
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
              title: "Last Used",
              value:
                  lastUsedDate != null
                      ? DateFormat('yyyy-MM-dd').format(lastUsedDate)
                      : 'data not enough',
            ),
            // 使用次数
            ItemUsageStatItem(
              icon: Icons.pin_outlined,
              title: "Usage Count",
              value: "$usageCount times",
            ),
            // 使用周期
            ItemUsageStatItem(
              icon: Icons.repeat,
              title: "Usage Cycle",
              value:
                  usageCount > 1
                      ? '$usageFrequency days'
                      : 'data not enough',
            ),
            // 下次使用预计
            ItemUsageStatItem(
              icon: Icons.update,
              title: "EST. Next Use",
              value:
                  nextExpectedUseDate != null
                      ? DateFormat(
                        'yyyy-MM-dd',
                      ).format(nextExpectedUseDate)
                      : 'data not enough',
            ),
          ],
        ),
      );
    }
  }
}
