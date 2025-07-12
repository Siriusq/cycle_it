import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/theme_controller.dart';
import '../../../../models/item_model.dart';
import '../../../../utils/responsive_layout.dart';
import '../../../../utils/responsive_style.dart';

class ItemCardProgressBar extends StatelessWidget {
  final ItemModel item;
  final bool isActive;

  const ItemCardProgressBar({
    super.key,
    required this.item,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();

    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    final double spacingXS = style.spacingXS;
    final double iconSizeSM = style.iconSizeSM;
    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final double progress = item.timePercentageBetweenLastAndNext();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // 进度条背景色
                  Obx(() {
                    final ThemeData currentTheme =
                        themeController.currentThemeData;

                    return Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            isActive && !isSingleCol
                                ? currentTheme
                                    .colorScheme
                                    .secondaryContainer
                                : currentTheme
                                    .colorScheme
                                    .surfaceContainer,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                  // 进度条颜色
                  Obx(() {
                    final ThemeData currentTheme =
                        themeController.currentThemeData;
                    return Container(
                      height: 6,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color:
                            isActive && !isSingleCol
                                ? currentTheme.colorScheme.secondary
                                : currentTheme
                                    .colorScheme
                                    .outlineVariant,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child:
                isTripleCol
                    ? Row(
                      children: [
                        Text("EST. Timer", style: smallBodyTextStyle),
                        const Spacer(),
                        Text(
                          "${(progress * 100).toStringAsFixed(2)}%",
                          style: smallBodyTextStyle,
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Icon(Icons.update, size: iconSizeSM),
                        SizedBox(width: spacingXS),
                        Text(
                          "EST. Next Use: ${nextExpectedUseDate != null ? DateFormat('yyyy-MM-dd').format(nextExpectedUseDate) : 'data not enough'}",
                          style: smallBodyTextStyle,
                        ),
                        const Spacer(),
                        Text(
                          "${(progress * 100).toStringAsFixed(2)}%",
                          style: smallBodyTextStyle,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
