import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';

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
    final TextStyle bodyTextLG = style.bodyTextLG;
    final TextStyle bodyText = style.bodyText;

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
                    child: HeatMapCalendar(
                      initDate: DateTime.now(),
                      datasets: heatMapData,
                      colorMode: ColorMode.opacity,
                      colorsets: {
                        1: kPrimaryColor.withValues(alpha: 0.2),
                        2: kPrimaryColor.withValues(alpha: 0.4),
                        3: kPrimaryColor.withValues(alpha: 0.6),
                        4: kPrimaryColor.withValues(alpha: 0.8),
                        5: kPrimaryColor,
                      },
                      defaultColor: kGrayColor.withValues(alpha: 0.2),
                      monthFontSize: bodyTextLG.fontSize,
                      weekFontSize: bodyText.fontSize,
                      weekTextColor: kTextColor,
                      textColor: kTextColor,
                      borderRadius: 4,
                      flexible: true,
                      showColorTip: true,
                      colorTipSize: 20,
                      colorTipCount: 5,
                      colorTipHelper: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text('Less', style: bodyText),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text('More', style: bodyText),
                        ),
                      ],
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
