import 'package:cycle_it/views/details_page/widgets/usage_records_table.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';
import 'monthly_usage_bar_chart.dart';
import 'usage_heatmap_calendar.dart';

class DetailsChartsGroup extends StatelessWidget {
  const DetailsChartsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final double tableHeight = ResponsiveStyle.to.tableHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        /// 窄屏单列布局
        if (constraints.maxWidth < 660) {
          return Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UsageRecordsTable(),
              UsageHeatmapCalendar(),
              SizedBox(height: 350, child: MonthlyUsageBarChart()),
            ],
          );
        }
        // 宽屏双列布局
        else {
          return SizedBox(
            height: tableHeight,
            child: Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: UsageRecordsTable()),
                Expanded(
                  child: Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UsageHeatmapCalendar(),
                      // 柱状图占满剩余高度
                      Expanded(child: MonthlyUsageBarChart()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
