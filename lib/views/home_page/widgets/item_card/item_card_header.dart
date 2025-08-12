import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/home_page/widgets/item_card/item_card_action_button.dart';
import 'package:flutter/material.dart';

class ItemCardHeader extends StatelessWidget {
  final ItemModel item;

  const ItemCardHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    final TextStyle titleMD =
        Theme.of(
          context,
        ).textTheme.titleMedium!.useSystemChineseFont();
    final TextStyle bodySM = Theme.of(context).textTheme.bodySmall!;
    final double itemCardIconSize = style.itemCardIconSize;

    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: isTripleCol ? 4 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标部分
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: itemCardIconSize,
              height: itemCardIconSize,
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
          const SizedBox(width: 8),
          // 文字内容区域
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                // 标题行
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        style: titleMD,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // 备注区域
                if (item.usageComment?.isNotEmpty ?? false)
                  Flexible(
                    child: Text(
                      item.usageComment!,
                      style: bodySM,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
