import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';

import '../../../controllers/item_controller.dart';
import '../../../controllers/language_controller.dart';
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

    final LanguageController languageController =
        Get.find<LanguageController>();

    return Obx(() {
      final bool isLoading =
          itemController.isLoadingHeatmapData.value;
      final String error = itemController.heatMapError.value;
      final Map<DateTime, int> heatMapData =
          itemController.heatMapData;

      return LayoutBuilder(
        builder: (context, constraints) {
          final Color primaryColor =
              Theme.of(context).colorScheme.primary;

          // 根据不同的状态，决定 AnimatedSwitcher 要显示哪个子组件
          Widget contentToAnimate;
          if (isLoading) {
            contentToAnimate = const Center(
              key: ValueKey(
                'loading',
              ), // 为 AnimatedSwitcher 提供唯一的 Key
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (error.isNotEmpty) {
            contentToAnimate = Center(
              key: ValueKey('error'), // 为 AnimatedSwitcher 提供唯一的 Key
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
            );
          } else if (heatMapData.isEmpty) {
            contentToAnimate = Center(
              key: ValueKey('empty'), // 为 AnimatedSwitcher 提供唯一的 Key
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'no_usage_records_found'.tr,
                  style: bodyText.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            contentToAnimate = Center(
              key: ValueKey(
                'heatmap',
              ), // 为 AnimatedSwitcher 提供唯一的 Key
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  colorTipCellSize: Size.square(heatmapTipCellSize),
                  cellSpaceBetween: heatmapCellSpaceBetween,
                  style: HeatmapCalendarStyle.defaults(
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
            );
          }

          // 估算日历组件的最小高度，以确保加载指示器等也占据相似的空间
          final double estimatedCalendarHeight =
              7 * heatmapCellSize +
              6 * heatmapCellSpaceBetween +
              heatmapTipCellSize +
              32;

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
                      const Icon(Icons.calendar_month, size: 24),
                    ],
                  ),
                ),
                const Divider(thickness: 1.5),
                // 淡入淡出和大小动画
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0, // 确保动画从顶部开始
                        child: child,
                      ),
                    );
                  },
                  // 使用 ConstrainedBox 确保 AnimatedSwitcher 的子组件有一个最小高度
                  // 这样在内容切换时，整体高度不会剧烈跳动
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: estimatedCalendarHeight,
                    ),
                    child: contentToAnimate,
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
