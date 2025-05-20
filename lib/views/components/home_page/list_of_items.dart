import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/test/mock_data.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/home_page/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final double headerSpacing = isMobile ? 4 : 20;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;
    final double bottomSpacing = isMobile ? 0 : 10;
    final double dividerHeight = isMobile ? 0 : 16;

    return Container(
      //drawer: ConstrainedBox(constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      //padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
      color: kPrimaryBgColor,
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: horizontalSpacing,
                right: horizontalSpacing,
                top: headerSpacing, // 留出按钮的高度空间，避免内容被遮挡
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
            SizedBox(height: bottomSpacing),
            Divider(height: dividerHeight),
            SizedBox(height: spacingXS),

            // 物品卡片
            Expanded(
              child: ListView.builder(
                itemCount: sampleItems.length,
                itemBuilder: (context, index) {
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
            textAlignVertical: TextAlignVertical.bottom,
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
