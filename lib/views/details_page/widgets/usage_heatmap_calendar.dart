import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../../../controllers/item_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../models/usage_record_model.dart';
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
      final LanguageController languageController =
          Get.find<LanguageController>();

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
          final Color primaryColor =
              Theme.of(context).colorScheme.primary;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                        'usage_record_hot_map'.tr,
                        style: titleTextMD,
                      ),
                      Icon(Icons.calendar_month, size: 24),
                    ],
                  ),
                ),
                Divider(thickness: 1.5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: HeatmapCalendar<num>(
                      startDate: DateTime(DateTime.now().year - 1),
                      endedDate: DateTime.now(),
                      colorMap: {
                        1: primaryColor.withValues(alpha: 0.4),
                        2: primaryColor.withValues(alpha: 0.55),
                        3: primaryColor.withValues(alpha: 0.7),
                        4: primaryColor.withValues(alpha: 0.85),
                        5: primaryColor,
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
                        weekLabelColor: Theme.of(context).hintColor,
                        monthLabelFontSize: bodyText.fontSize!,
                        monthLabelColor: Theme.of(context).hintColor,
                      ),
                      colorTipLeftHelper: Text(
                        'less'.tr,
                        style: bodyText.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      colorTipRightHelper: Text(
                        'more'.tr,
                        style: bodyText.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
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
                      locale:
                          languageController.currentLocale ??
                          Get.deviceLocale,
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
