import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_charts/material_charts.dart'; // 导入 material_charts

import '../../../controllers/item_controller.dart';
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
      final bool isLoading =
          itemController.isLoadingMonthlyChartData.value;
      final String error = itemController.monthlyChartError.value;
      final List<BarChartData> barChartData =
          itemController.monthlyBarChartData;
      final double usageSum = itemController.monthlyUsageSum.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth;
          final chartHeight = chartWidth * 0.5;

          // 根据不同的状态，决定显示哪个子组件
          Widget contentToDisplay;
          if (isLoading) {
            contentToDisplay = SizedBox(
              height: chartHeight, // 确保加载指示器与图表高度一致
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (error.isNotEmpty) {
            contentToDisplay = SizedBox(
              height: chartHeight, // 确保错误信息与图表高度一致
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Error: $error',
                    style: bodyText.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else if (usageSum <= 0) {
            contentToDisplay = SizedBox(
              height: chartHeight, // 确保空数据提示与图表高度一致
              child: Center(
                child: Text(
                  'no_usage_record_in_the_past_year'.tr,
                  style: bodyText,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            contentToDisplay = MaterialBarChart(
              data: barChartData,
              width: chartWidth,
              height: chartHeight,
              style: BarChartStyle(
                barColor: Theme.of(context).colorScheme.primary,
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
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeOutCubic,
              ),
              showGrid: false,
              showValues: true,
              interactive: true,
              padding: EdgeInsets.zero,
            );
          }

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
                      const Icon(Icons.bar_chart, size: 24),
                    ],
                  ),
                ),
                const Divider(thickness: 1.5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: contentToDisplay,
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
