import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

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
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          isActive && !isSingleCol
                              ? Theme.of(
                                context,
                              ).colorScheme.secondaryContainer
                              : Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  // 进度条颜色
                  Container(
                    height: 6,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color:
                          isActive && !isSingleCol
                              ? Theme.of(
                                context,
                              ).colorScheme.secondary
                              : Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child:
                isSingleCol
                    ? Row(
                      children: [
                        Icon(Icons.update, size: iconSizeSM),
                        SizedBox(width: spacingXS),
                        Expanded(
                          child: Text(
                            nextExpectedUseDate != null
                                ? 'est_timer_brief'.trParams({
                                  'date': DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(nextExpectedUseDate),
                                })
                                : 'data_not_enough'.tr,
                            style: smallBodyTextStyle,
                            overflow: TextOverflow.visible,
                          ),
                        ),

                        Text(
                          nextExpectedUseDate != null
                              ? "${(progress * 100).toStringAsFixed(2)}%"
                              : 'N/A',
                          style: smallBodyTextStyle,
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Text(
                          'est_timer'.tr,
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
