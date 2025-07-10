import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';
import 'monthly_usage_bar_chart.dart';
import 'usage_heatmap_calendar.dart';

class DetailsChartsGroup extends StatelessWidget {
  const DetailsChartsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to; // 直接获取 style
    final double spacingMD = style.spacingMD;

    return Wrap(
      children: [
        const UsageHeatmapCalendar(),
        SizedBox(height: spacingMD, width: spacingMD),
        const MonthlyUsageBarChart(),
      ],
    );
  }
}
