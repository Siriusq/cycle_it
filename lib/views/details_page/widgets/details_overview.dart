import 'dart:math';

import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/views/details_page/widgets/details_brief_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// 封装卡片的数据
class _CardData {
  final String title;
  final IconData icon;
  final String data;
  final String comment;

  _CardData({
    required this.title,
    required this.icon,
    required this.data,
    required this.comment,
  });
}

class DetailsOverview extends StatelessWidget {
  const DetailsOverview({super.key});

  // 定义常量
  static const double _breakPoint = 660;
  static const double _narrowLayoutHeightRatio = 0.5;
  static const double _narrowLayoutMaxHeight = 120;
  static const double _wideLayoutHeightRatio = 0.16;
  static const double _wideLayoutMaxHeight = 160;

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();

    return Obx(() {
      final ItemModel? currentItem = itemCtrl.currentItem.value;
      if (currentItem == null) {
        return const SizedBox.shrink(); // 如果物品为空，不显示此部分
      }

      // 提取并复用日期格式化器
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final DateTime now = DateTime.now();

      // 直接从 currentItem 读取预先计算好的统计数据
      final int usageCount = currentItem.usageCount;
      final DateTime? nextExpectedUseDate =
          currentItem.nextExpectedUse;
      final DateTime? firstUsedDate = currentItem.firstUsedDate;
      final DateTime? lastUsedDate = currentItem.lastUsedDate;
      final double usageFrequency = currentItem.usageFrequency
          .toPrecision(2);

      // 重新计算与今天相关的天数差
      final int daysSinceLastUse =
          lastUsedDate != null
              ? now.difference(lastUsedDate).inDays
              : 0;
      final int daysTillNextUse =
          nextExpectedUseDate != null
              ? nextExpectedUseDate.difference(now).inDays
              : 0;

      // 提前计算所有卡片的数据
      final List<_CardData> cardDataList = [
        // 使用次数
        _CardData(
          title: 'usage_count'.tr,
          icon: Icons.pin,
          data: '$usageCount',
          comment:
              firstUsedDate != null
                  ? 'usage_count_comment'.trParams({
                    'date': dateFormatter.format(firstUsedDate),
                  })
                  : 'no_usage_records'.tr,
        ),
        // 使用周期
        _CardData(
          title: 'usage_cycle'.tr,
          icon: Icons.loop,
          data: usageCount > 1 ? '$usageFrequency' : '-',
          comment:
              usageCount > 1
                  ? 'usage_cycle_comment'.tr
                  : 'data_not_enough'.tr,
        ),
        // 上次使用
        _CardData(
          title: 'last_used_at'.tr,
          icon: Icons.history,
          data: usageCount > 0 ? '$daysSinceLastUse' : '-',
          comment:
              lastUsedDate != null
                  ? 'last_used_at_comment'.trParams({
                    'date': dateFormatter.format(lastUsedDate),
                  })
                  : 'data_not_enough'.tr,
        ),
        // 下次使用预计
        _CardData(
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
                    'date': dateFormatter.format(nextExpectedUseDate),
                  })
                  : 'data_not_enough'.tr,
        ),
      ];

      // 构建单个 DetailsBriefCard
      Widget buildBriefCard(_CardData data) {
        return Expanded(
          child: DetailsBriefCard(
            title: data.title,
            icon: data.icon,
            data: data.data,
            comment: data.comment,
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          // 窄布局，两行，每行两个卡片
          if (constraints.maxWidth < _breakPoint) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                SizedBox(
                  height: min(
                    _narrowLayoutMaxHeight,
                    constraints.maxWidth * _narrowLayoutHeightRatio,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children:
                        cardDataList
                            .sublist(0, 2)
                            .map(buildBriefCard)
                            .toList(),
                  ),
                ),
                SizedBox(
                  height: min(
                    _narrowLayoutMaxHeight,
                    constraints.maxWidth * _narrowLayoutHeightRatio,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children:
                        cardDataList
                            .sublist(2, 4)
                            .map(buildBriefCard)
                            .toList(),
                  ),
                ),
              ],
            );
          }
          // 宽布局，一行四个卡片
          else {
            return Column(
              children: [
                SizedBox(
                  height: min(
                    _wideLayoutMaxHeight,
                    constraints.maxWidth * _wideLayoutHeightRatio,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 12,
                    children:
                        cardDataList.map(buildBriefCard).toList(),
                  ),
                ),
              ],
            );
          }
        },
      );
    });
  }
}
