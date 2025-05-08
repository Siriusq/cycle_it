import 'package:cycle_it/test/mock_data.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/extensions.dart';
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

    return Container(
      //drawer: ConstrainedBox(constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      //padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
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
                    IconButton(icon: Icon(Icons.menu), onPressed: () => scaffoldKey.currentState?.openDrawer()),
                  if (!Responsive.isDesktop(context)) SizedBox(width: 5),

                  // 搜索框
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Search",
                        //fillColor: kBgLightColor,
                        //filled: true,
                        hoverColor: kBgLightColor,
                        suffixIcon: Padding(padding: const EdgeInsets.all(15), child: Icon(Icons.search)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ).addNeumorphism(
                      offset: 5,
                      blurRadius: 5,
                      lightColor: Colors.white,
                      shadowColor: Color(0xffa2a3ab),
                      isInset: true,
                    ),
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
                        if (Responsive.isMobile(context)) {
                          Get.toNamed("/Details");
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
    );
  }
}
