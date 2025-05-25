import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/test/mock_data.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/home_page/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../details_page/details_page.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

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
              child: ListView.builder(
                itemCount: sampleItems.length + 1, // 加一个“底部标识”项
                itemBuilder: (context, index) {
                  if (index == sampleItems.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Center(
                        child: Text(
                          '—— 已经到底了 ——',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final item = sampleItems[index];
                  return Obx(() {
                    final selected =
                        Get.find<ItemController>().selectedItem.value;
                    final isActive = selected?.id == item.id;
                    return ItemCard(
                      item: item,
                      isActive: isActive,
                      press: () {
                        itemCtrl.selectItem(item);
                        Get.to(() => DetailsPage())!.then((_) {
                          itemCtrl.clearSelection(); // 返回时清除状态
                        });
                      },
                    );
                  });
                },
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
}
