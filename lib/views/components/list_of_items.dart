import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/test/mock_data.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/views/components/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../utils/responsive.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    final searchBarCtrl = Get.find<SearchBarController>();

    return Container(
      //drawer: ConstrainedBox(constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      //padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
      color: kPrimaryBgColor,
      child: SafeArea(
        right: false,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    children: [
                      // 非桌面端显示抽屉按钮
                      if (!Responsive.isDesktop(context))
                        IconButton(icon: Icon(Icons.menu), onPressed: () => scaffoldKey.currentState?.openDrawer()),
                      if (!Responsive.isDesktop(context)) SizedBox(width: 5),

                      // 搜索框
                      SizedBox(width: 5),
                      Expanded(
                        child: Obx(() {
                          return TextField(
                            controller: searchBarCtrl.textController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: "Search",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: kSelectedBorderColor, width: 2.0),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child:
                                        searchBarCtrl.hasText.value
                                            ? IconButton(
                                              onPressed: () {
                                                searchBarCtrl.clearText();
                                              },
                                              icon: Icon(Icons.clear),
                                            )
                                            : null,
                                  ),
                                  Padding(padding: const EdgeInsets.all(15), child: Icon(Icons.search)),
                                ],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: kBorderColor, width: 2.0),
                              ),
                            ),
                          );
                        }),
                      ),
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
                            // if (Responsive.isMobile(context)) {
                            //   Get.toNamed("/Details");
                            // }
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            // 只在手机端显示悬浮按钮
            if (!Responsive.isDesktop(context))
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {},
                  child: Icon(Icons.create_rounded),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
