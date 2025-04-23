import 'package:cycle_it/test/mock_data.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/views/components/item_card.dart';
import 'package:cycle_it/views/components/side_menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../utils/responsive.dart';
import '../details_page.dart';

class ListOfItems extends StatelessWidget {
  const ListOfItems({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: ConstrainedBox(constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      body: Container(
        padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // 非桌面端显示抽屉按钮
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),

                    // 搜索框
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          hoverColor: kBgLightColor,
                          suffixIcon: Padding(padding: const EdgeInsets.all(15), child: Icon(Icons.search)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // 排序按钮
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: kTitleTextColor,
                        iconSize: 28,
                        padding: EdgeInsets.only(left: 6, right: 10),
                        //splashFactory: NoSplash.splashFactory,
                        //overlayColor: Colors.transparent,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.expand_more),
                      label: Text('Sorted by Name', style: TextStyle(fontWeight: FontWeight.w500)),
                      iconAlignment: IconAlignment.start,
                    ),
                    Spacer(),
                    // 筛选按钮
                    IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: sampleItems.length,
                  itemBuilder: (context, index) {
                    final item = sampleItems[index];
                    return Obx(() {
                      final selected = Get.find<ItemController>().selectedItem.value;
                      final isActive = selected?.id == item.id;
                      return ItemCard(
                        item: item,
                        isActive: isActive,
                        press: () {
                          itemCtrl.selectItem(item);
                          if (Responsive.isMobile(context)) {
                            Get.to(() => DetailsPage());
                          }
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
