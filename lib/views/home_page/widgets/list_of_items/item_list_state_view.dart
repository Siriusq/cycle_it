import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/item_controller.dart';
import '../../../../utils/responsive_style.dart';
import '../../../details_page/details_page.dart';
import '../item_card/item_card.dart';

class ItemListStateView extends StatelessWidget {
  const ItemListStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingMD = style.spacingMD;

    return Obx(() {
      if (itemController.isLoading.value) {
        // 状态1: 如果还没有加载数据，显示加载指示器
        return const Center(child: CircularProgressIndicator());
      } else {
        // 数据加载完成，检查数据状态
        if (itemController.allItems.isEmpty) {
          // 状态2: 物品库为空 (数据库中没有任何物品)
          return Center(
            child: Text(
              'please_add_an_item'.tr,
              style: style.bodyText,
            ),
          );
        } else if (itemController.displayedItems.isEmpty) {
          // 状态3: 物品库有数据，但当前筛选/搜索后没有符合条件的物品
          return Center(
            child: Text('no_matched_item'.tr, style: style.bodyText),
          );
        } else {
          // 状态4: 有物品需要显示
          return ListView.builder(
            itemCount: itemController.displayedItems.length + 1,
            itemBuilder: (context, index) {
              if (index == itemController.displayedItems.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: spacingMD),
                  child: Center(
                    child: Text(
                      'reached_end_hint'.tr,
                      style: bodyTextStyle,
                    ),
                  ),
                );
              }

              final item = itemController.displayedItems[index];
              return Obx(() {
                final selected = itemController.currentItem.value;
                final isActive = selected?.id == item.id;
                return ItemCard(
                  item: item,
                  isActive: isActive,
                  press: () {
                    Get.to(() => DetailsPage())!.then((_) {
                      itemController.clearSelection(); // 返回时清除状态
                    });
                  },
                );
              });
            },
          );
        }
      }
    });
  }
}
