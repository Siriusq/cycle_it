import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    final TextStyle bodySM = Theme.of(context).textTheme.bodySmall!;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final double progress = item.timePercentageBetweenLastAndNext();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                      borderRadius: BorderRadius.circular(4),
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
                      borderRadius: BorderRadius.circular(4),
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
                        const Icon(Icons.update, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            nextExpectedUseDate != null
                                ? 'est_timer_brief'.trParams({
                                  'date': DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(nextExpectedUseDate),
                                })
                                : 'data_not_enough'.tr,
                            style: bodySM,
                            overflow: TextOverflow.visible,
                          ),
                        ),

                        Text(
                          nextExpectedUseDate != null
                              ? "${(progress * 100).toStringAsFixed(2)}%"
                              : 'N/A',
                          style: bodySM,
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('est_timer'.tr, style: bodySM),
                        Text(
                          "${(progress * 100).toStringAsFixed(2)}%",
                          style: bodySM,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
