import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_charts/material_charts.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/usage_record_model.dart';
import '../../../utils/responsive_style.dart';

class MonthlyUsageBarChart extends StatelessWidget {
  const MonthlyUsageBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextMD = style.titleTextMD;
    final TextStyle bodyText = style.bodyText;

    return Obx(() {
      final List<UsageRecordModel> records =
          itemController.currentItem.value?.usageRecords ?? [];

      List<double> monthlyUsage = List.filled(13, 0);
      final int currentYear = DateTime.now().year;

      for (var record in records) {
        if (record.usedAt.year == currentYear) {
          monthlyUsage[record.usedAt.month]++;
        }
      }

      double usageSum = 0;
      for (var usage in monthlyUsage) {
        usageSum += usage;
      }

      final List<String> monthLabels = [
        '', //index placeholder
        'Jan'.tr,
        'Feb'.tr,
        'Mar'.tr,
        'Apr'.tr,
        'May'.tr,
        'Jun'.tr,
        'Jul'.tr,
        'Aug'.tr,
        'Sep'.tr,
        'Oct'.tr,
        'Nov'.tr,
        'Dec'.tr,
      ];

      // Prepare data for material_charts BarChart
      final List<BarChartData> barChartData = [];
      for (int i = 1; i <= 12; i++) {
        barChartData.add(
          BarChartData(value: monthlyUsage[i], label: monthLabels[i]),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth;
          final chartHeight = chartWidth * 0.5;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'monthly_usage_count'.tr,
                        style: titleTextMD,
                      ),
                      Icon(Icons.bar_chart, size: 24),
                    ],
                  ),
                ),
                Divider(thickness: 1.5),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child:
                        usageSum > 0
                            ? MaterialBarChart(
                              data: barChartData,
                              width: chartWidth,
                              height: chartHeight,
                              style: BarChartStyle(
                                barColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                backgroundColor: Colors.transparent,
                                barSpacing: 0.30,
                                cornerRadius: 8.0,
                                gradientEffect: false,
                                labelStyle: bodyText.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                                valueStyle: bodyText.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                                animationDuration: Duration(
                                  milliseconds: 300,
                                ),
                                animationCurve: Curves.easeOutCubic,
                              ),
                              showGrid: false,
                              showValues: true,
                              interactive: true,
                              padding: EdgeInsets.zero,
                            )
                            : SizedBox(
                              height: chartHeight,
                              //width: chartHeight,
                              child: Center(
                                child: Text(
                                  'no_usage_record_in_the_past_year'
                                      .tr,
                                  style: bodyText,
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
