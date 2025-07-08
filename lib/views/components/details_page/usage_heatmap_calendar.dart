import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/usage_record_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

class UsageHeatmapCalendar extends StatelessWidget {
  const UsageHeatmapCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle titleTextMD = style.titleTextMD;
    final TextStyle bodyText = style.bodyText;
    final double heatmapCellSize = style.heatmapCellSize;
    final double heatmapTipCellSize = style.heatmapTipCellSize;
    final double heatmapCellSpaceBetween =
        style.heatmapCellSpaceBetween;

    return Obx(() {
      final List<UsageRecordModel> records =
          itemController.currentItem.value?.usageRecords ?? [];

      // Process data, generate data points required by the heatmap
      Map<DateTime, int> heatMapData = {};
      for (var record in records) {
        // Adjust date to only include year, month, day, ignore time
        DateTime day = DateTime(
          record.usedAt.year,
          record.usedAt.month,
          record.usedAt.day,
        );
        heatMapData.update(
          day,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: kSecondaryBgColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1.5, color: kBorderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text('使用记录热点图', style: titleTextMD),
                ),
                Divider(color: kBorderColor, thickness: 1.5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: HeatmapCalendar<num>(
                      startDate: DateTime(DateTime.now().year - 1),
                      endedDate: DateTime.now(),
                      colorMap: {
                        1: kPrimaryColor.withValues(alpha: 0.4),
                        2: kPrimaryColor.withValues(alpha: 0.55),
                        3: kPrimaryColor.withValues(alpha: 0.7),
                        4: kPrimaryColor.withValues(alpha: 0.85),
                        5: kPrimaryColor,
                      },
                      selectedMap: heatMapData,
                      cellSize: Size.square(heatmapCellSize),
                      colorTipCellSize: Size.square(
                        heatmapTipCellSize,
                      ),
                      cellSpaceBetween: heatmapCellSpaceBetween,
                      style: HeatmapCalendarStyle.defaults(
                        //cellValueFontSize: 6.0,
                        cellRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        weekLabelValueFontSize: bodyText.fontSize!,
                        weekLabelColor: bodyText.color,
                        monthLabelFontSize: bodyText.fontSize!,
                        monthLabelColor: bodyText.color,
                      ),
                      colorTipLeftHelper: Text(
                        'Less',
                        style: bodyText,
                      ),
                      colorTipRightHelper: Text(
                        'More',
                        style: bodyText,
                      ),
                      layoutParameters:
                          const HeatmapLayoutParameters.defaults(
                            monthLabelPosition:
                                CalendarMonthLabelPosition.top,
                            weekLabelPosition:
                                CalendarWeekLabelPosition.right,
                            colorTipPosition:
                                CalendarColorTipPosition.bottom,
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
