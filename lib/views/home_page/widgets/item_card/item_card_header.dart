import 'package:flutter/material.dart';

import '../../../../models/item_model.dart';
import '../../../../utils/responsive_layout.dart';
import '../../../../utils/responsive_style.dart';
import 'item_card_action_button.dart';

class ItemCardHeader extends StatelessWidget {
  final ItemModel item;

  const ItemCardHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingSM = style.spacingSM;

    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: isTripleCol ? 5 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标部分
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: item.iconColor,
              ),
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
          SizedBox(width: spacingSM),
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
                        style: titleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      style: smallBodyTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 更多按钮
          ItemCardActionButton(item: item),
        ],
      ),
    );
  }
}
