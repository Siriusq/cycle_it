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

    final style = ResponsiveStyle.to;
    final double spacingXS = style.spacingXS;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
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
                    onPressed: () async {
                      final result = await Get.toNamed(
                        '/AddEditItem',
                      );

                      // 在显示 Snackbar 前添加一个微小延迟
                      await Future.delayed(
                        const Duration(milliseconds: 50),
                      );

                      if (result != null && result['success']) {
                        Get.snackbar('成功', '${result['message']}');
                      }
                    },
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
                                // 清除文本后立即执行一次搜索，以清除筛选结果
                                searchBarCtrl.performSearch();
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
                              onPressed: () {
                                searchBarCtrl
                                    .performSearch(); // 点击搜索按钮时执行搜索
                              },
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
    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingMD = style.spacingMD;

    return Obx(() {
      if (itemController.isLoading.value) {
        // 如果还没有加载数据，显示加载指示器
        return const Center(
          child: CircularProgressIndicator(color: kPrimaryColor),
        );
      } else {
        // 数据加载完成，检查数据状态
        if (itemController.allItems.isEmpty) {
          // 状态2: 物品库为空 (数据库中没有任何物品)
          return Center(
            child: Text(
              '您的物品库是空的，快去添加吧！', // 例如：引导用户添加物品
              style: style.bodyText, // 使用你的响应式文本样式
            ),
          );
        } else if (itemController.displayedItems.isEmpty) {
          // 状态3: 物品库有数据，但当前筛选/搜索后没有符合条件的物品
          return Center(
            child: Text(
              '没有符合条件的物品', // 当过滤/搜索无结果时显示
              style: style.bodyText, // 使用你的响应式文本样式
            ),
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
                      '—— 已经到底了 ——',
                      style: bodyTextStyle.copyWith(
                        color: Colors.grey,
                      ),
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
