import 'package:cycle_it/models/item_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

class DetailsItemTitle extends StatelessWidget {
  final ItemModel item;

  const DetailsItemTitle({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle detailsTitleText = style.detailsTitleText;
    final TextStyle bodyText = style.bodyText;
    final double spacingLG = style.spacingLG;
    final double detailsIconSize = style.detailsIconSize;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingLG * 0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: item.iconColor,
              ),
              width: detailsIconSize,
              height: detailsIconSize,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: spacingLG),

          // 文字内容区域
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        style: detailsTitleText,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),

                // 备注区域
                if (item.usageComment?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      item.usageComment!,
                      style: bodyText,
                      softWrap: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
