import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/responsive_style.dart';
import '../../shared_widgets/responsive_component_group.dart';
import 'details_brief_card.dart';

class DetailsOverview extends StatelessWidget {
  const DetailsOverview({super.key});

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

      // [修改] 直接从 currentItem 读取预先计算好的统计数据
      final int usageCount = currentItem.usageCount;
      final DateTime? nextExpectedUseDate =
          currentItem.nextExpectedUse;
      final DateTime? firstUsedDate = currentItem.firstUsedDate;
      final DateTime? lastUsedDate = currentItem.lastUsedDate;
      final double usageFrequency = currentItem.usageFrequency
          .toPrecision(2);
      //print(DateFormat('yyyy-MM-dd').format(firstUsedDate!));

      // [修改] 在这里重新计算与“今天”相关的天数差
      final int daysSinceLastUse =
          lastUsedDate != null
              ? DateTime.now().difference(lastUsedDate).inDays
              : 0;
      final int daysTillNextUse =
          nextExpectedUseDate != null
              ? nextExpectedUseDate.difference(DateTime.now()).inDays
              : 0;

      return Padding(
        padding: const EdgeInsets.all(0),
        child: ResponsiveComponentGroup(
          minComponentWidth: minComponentWidth,
          aspectRation: 1.8,
          children: [
            // 使用次数
            DetailsBriefCard(
              title: 'usage_count'.tr,
              icon: Icons.pin,
              data: '$usageCount',
              comment:
                  firstUsedDate != null
                      ? 'usage_count_comment'.trParams({
                        'date': DateFormat(
                          'yyyy-MM-dd',
                        ).format(firstUsedDate),
                      })
                      : 'no_usage_records'.tr,
            ),
            // 使用周期
            DetailsBriefCard(
              title: 'usage_cycle'.tr,
              icon: Icons.loop,
              data: usageCount > 1 ? '$usageFrequency' : '-',
              comment:
                  usageCount > 1
                      ? 'usage_cycle_comment'.tr
                      : 'data_not_enough'.tr,
            ),
            // 上次使用
            DetailsBriefCard(
              title: 'last_used_at'.tr,
              icon: Icons.history,
              data: usageCount > 0 ? '$daysSinceLastUse' : '-',
              comment:
                  lastUsedDate != null
                      ? 'last_used_at_comment'.trParams({
                        'date': DateFormat(
                          'yyyy-MM-dd',
                        ).format(lastUsedDate),
                      })
                      : 'data_not_enough'.tr,
            ),
            // 下次使用预计
            DetailsBriefCard(
              title: 'est_next_use_date'.tr,
              icon: Icons.update,
              data: usageCount > 1 ? '${daysTillNextUse.abs()}' : '-',
              comment:
                  nextExpectedUseDate != null
                      ? 'est_next_use_date_comment'.trParams({
                        'trend':
                            daysTillNextUse >= 0
                                ? 'days_later'.tr
                                : 'days_ago'.tr,
                        'date': DateFormat(
                          'yyyy-MM-dd',
                        ).format(nextExpectedUseDate),
                      })
                      : 'data_not_enough'.tr,
            ),
          ],
        ),
      );
    });
  }
}
