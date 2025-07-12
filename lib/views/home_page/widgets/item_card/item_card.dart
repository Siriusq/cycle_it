import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/home_page/widgets/item_card/item_card_header.dart';
import 'package:cycle_it/views/home_page/widgets/item_card/item_card_overview.dart';
import 'package:cycle_it/views/home_page/widgets/item_card/item_card_progress_bar.dart';
import 'package:cycle_it/views/home_page/widgets/item_card/item_card_tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/theme_controller.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.isActive,
    required this.press,
  });

  final ItemModel item;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    final ThemeController themeController =
        Get.find<ThemeController>();

    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;

    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    return Padding(
      padding: EdgeInsets.only(
        left: spacingLG,
        right: spacingLG,
        top: spacingLG,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          itemCtrl.selectItem(item);
          if (isSingleCol) Get.toNamed("/Details");
        },
        child: Obx(() {
          final ThemeData currentTheme =
              themeController.currentThemeData;
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(spacingLG * 0.5),
            //动态边框
            decoration: BoxDecoration(
              color:
                  isActive && !isSingleCol
                      ? currentTheme.colorScheme.surfaceContainerLow
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2.0,
                color:
                    isActive && !isSingleCol
                        ? currentTheme.colorScheme.outline
                        : currentTheme.colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 图标、名称、更多按钮
                ItemCardHeader(item: item),

                // 详细使用数据
                ItemCardOverview(item: item),

                // 进度条区域
                ItemCardProgressBar(item: item, isActive: isActive),

                //标签
                ItemCardTags(item: item),
              ],
            ),
          );
        }),
      ),
    );
  }
}
