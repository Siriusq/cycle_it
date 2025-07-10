import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/controllers/item_controller.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';
import '../../shared_widgets/responsive_component_group.dart';
import 'details_brief_card.dart';

class DetailsOverview extends StatelessWidget {
  final ItemModel item;
  const DetailsOverview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double minComponentWidth = style.minComponentWidthSM;

    return Obx(() {
      // 重新获取最新的 item 数据，因为 itemCtrl.currentItem 可能已更新
      final ItemModel? currentItem = itemCtrl.currentItem.value;
      if (currentItem == null) {
        return const SizedBox.shrink(); // 如果物品为空，不显示此部分
      }

      final int usageCount = currentItem.usageRecords.length;
      final DateTime? nextExpectedUseDate =
          currentItem.nextExpectedUse;
      final DateTime? firstUsedDate =
          usageCount > 0
              ? currentItem.usageRecords.first.usedAt
              : null;
      final DateTime? lastUsedDate =
          usageCount > 0
              ? currentItem.usageRecords.last.usedAt
              : null;
      final int daysSinceLastUse =
          currentItem.daysToToday(false).abs();
      final int daysTillNextUse = currentItem.daysToToday(true);
      final double usageFrequency = currentItem.usageFrequency
          .toPrecision(2);

      return Padding(
        padding: const EdgeInsets.all(0),
        child: ResponsiveComponentGroup(
          minComponentWidth: minComponentWidth,
          aspectRation: 1.8,
          children: [
            // 使用次数，自首次使用记录起
            DetailsBriefCard(
              title: 'Usage Count',
              icon: Icons.pin,
              iconColor: kIconColor,
              data: '$usageCount',
              comment:
                  firstUsedDate != null
                      ? 'times since ${DateFormat('yyyy-MM-dd').format(firstUsedDate)}'
                      : 'no usage records',
            ),
            // 使用周期
            DetailsBriefCard(
              title: 'Usage Cycle',
              icon: Icons.loop,
              iconColor: kIconColor,
              data: usageCount > 1 ? '$usageFrequency' : '-',
              comment:
                  usageCount > 1
                      ? 'days per usage'
                      : 'data not enough',
            ),
            // 上次使用
            DetailsBriefCard(
              title: 'Last Used',
              icon: Icons.history,
              iconColor: kIconColor,
              data: usageCount > 0 ? '$daysSinceLastUse' : '-',
              comment:
                  lastUsedDate != null
                      ? 'days ago since ${DateFormat('yyyy-MM-dd').format(lastUsedDate)}'
                      : 'data not enough',
            ),
            // 下次使用预计
            DetailsBriefCard(
              title: 'EST. Next Use',
              icon: Icons.update,
              iconColor: kIconColor,
              data: usageCount > 1 ? '${daysTillNextUse.abs()}' : '-',
              comment:
                  nextExpectedUseDate != null
                      ? 'days ${daysTillNextUse >= 0 ? 'later' : 'ago'} at ${DateFormat('yyyy-MM-dd').format(nextExpectedUseDate)}'
                      : 'data not enough',
            ),
          ],
        ),
      );
    });
  }
}
