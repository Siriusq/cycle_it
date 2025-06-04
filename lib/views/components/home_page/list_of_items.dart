import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/home_page/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_list_order_controller.dart';
import '../../../controllers/tag_controller.dart';
import '../details_page/details_page.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ItemListOrderController orderController =
        Get.find<ItemListOrderController>();
    final TagController tagController = Get.find<TagController>();

    final style = context.responsiveStyle();
    final double spacingXS = style.spacingXS;
    final double spacingLG = style.spacingLG;
    final bool isMobile = GetPlatform.isIOS || GetPlatform.isAndroid;
    final double verticalSpacing = isMobile ? 0 : spacingLG;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;

    return SafeArea(
      right: false,
      child: Container(
        color: kPrimaryBgColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalSpacing,
                vertical: verticalSpacing,
              ),
              child: Row(
                children: [
                  // 非桌面端显示抽屉按钮
                  if (!ResponsiveLayout.isTripleCol(context))
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed:
                          () =>
                              scaffoldKey.currentState?.openDrawer(),
                    ),
                  if (!ResponsiveLayout.isTripleCol(context))
                    SizedBox(width: spacingXS),

                  // 搜索框
                  _buildSearchBar(context, isMobile),

                  //添加物品按钮
                  SizedBox(width: spacingXS),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.library_add_outlined),
                  ),
                ],
              ),
            ),

            // 分割线
            Divider(height: 0),

            // 物品卡片
            Expanded(
              child: _buildItemCards(
                context,
                isMobile,
                itemController,
                style,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    final searchBarCtrl = Get.find<SearchBarController>();

    final double topBarHeight = isMobile ? 32 : 48;
    final double searchBarIconSize = isMobile ? 16 : 24;
    final double searchBarButtonSize = isMobile ? 26 : 40;
    final TextStyle searchBarHintStyle =
        isMobile ? TextStyle(fontSize: 12) : TextStyle(fontSize: 16);

    return Expanded(
      child: SizedBox(
        height: topBarHeight,
        child: Obx(() {
          return TextField(
            style: searchBarHintStyle,
            textAlignVertical:
                isMobile
                    ? TextAlignVertical.bottom
                    : TextAlignVertical.center,
            controller: searchBarCtrl.textController,
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: searchBarHintStyle,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: kSelectedBorderColor,
                  width: 2.0,
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 清除文字按钮
                  SizedBox(
                    height: searchBarButtonSize,
                    width: searchBarButtonSize,
                    child:
                        searchBarCtrl.hasText.value
                            ? IconButton(
                              padding: EdgeInsets.all(0.0),
                              iconSize: searchBarIconSize,
                              onPressed: () {
                                searchBarCtrl.clearText();
                              },
                              icon: Icon(Icons.clear),
                            )
                            : null,
                  ),
                  // 搜索按钮
                  SizedBox(
                    height: searchBarButtonSize,
                    width: searchBarButtonSize,
                    child:
                        searchBarCtrl.hasText.value
                            ? IconButton(
                              padding: EdgeInsets.all(0.0),
                              iconSize: searchBarIconSize,
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            )
                            : Icon(
                              Icons.search,
                              size: searchBarIconSize,
                            ),
                  ),
                  // 占位符
                  SizedBox(width: 6),
                ],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: kBorderColor,
                  width: 2.0,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildItemCards(
    BuildContext context,
    bool isMobile,
    ItemController itemController,
    ResponsiveStyle style,
  ) {
    if (itemController.displayedItems.isEmpty &&
        itemController.allItems.isEmpty) {
      // 如果还没有加载数据，显示加载指示器
      return Center(child: CircularProgressIndicator());
    }

    if (itemController.displayedItems.isEmpty) {
      return Center(child: Text('没有符合条件的物品', style: style.bodyText));
    }

    return Obx(() {
      return ListView.builder(
        itemCount: itemController.displayedItems.length + 1,
        itemBuilder: (context, index) {
          if (index == itemController.displayedItems.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  '—— 已经到底了 ——',
                  style: TextStyle(color: Colors.grey),
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
    });
  }
}
