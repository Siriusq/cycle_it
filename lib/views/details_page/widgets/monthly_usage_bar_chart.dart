import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_charts/material_charts.dart';

import '../../../controllers/item_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/usage_record_model.dart';
import '../../../utils/responsive_style.dart';

class MonthlyUsageBarChart extends StatelessWidget {
  const MonthlyUsageBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextMD = style.titleTextMD;
    final TextStyle bodyText = style.bodyText;

    return Obx(() {
      final ThemeData currentTheme = themeController.currentThemeData;
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
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
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
              color: currentTheme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.5,
                color: currentTheme.colorScheme.outlineVariant,
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
                      Text('每月使用次数', style: titleTextMD),
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
                                    currentTheme.colorScheme.primary,
                                backgroundColor: Colors.transparent,
                                barSpacing: 0.30,
                                cornerRadius: 8.0,
                                gradientEffect: false,
                                labelStyle: bodyText,
                                valueStyle: bodyText,
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
                                  'No usage record in the past year.',
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
