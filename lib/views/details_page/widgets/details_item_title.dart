import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../utils/responsive_style.dart';

class DetailsItemTitle extends StatelessWidget {
  const DetailsItemTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final double detailsIconSize = style.detailsIconSize;

    return Obx(() {
      final ItemModel? currentItem = itemCtrl.currentItem.value;
      if (currentItem == null) {
        return const SizedBox.shrink(); // 如果物品为空，不显示此部分
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: currentItem.iconColor,
            ),
            width: detailsIconSize,
            height: detailsIconSize,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    currentItem.emoji,
                    style: const TextStyle(fontSize: 100),
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
              spacing: spacingSM,
              children: [
                // 标题行
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        currentItem.name,
                        style:
                            Theme.of(context).textTheme.titleLarge!
                                .useSystemChineseFont(),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),

                // 备注区域
                if (currentItem.usageComment?.isNotEmpty ?? false)
                  Flexible(
                    child: Text(
                      currentItem.usageComment!,
                      style: Theme.of(context).textTheme.bodyMedium!,
                      softWrap: true,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
