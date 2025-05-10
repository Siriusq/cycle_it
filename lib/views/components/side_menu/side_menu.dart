import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/views/components/dialog/add_tag_dialog.dart';
import 'package:cycle_it/views/components/side_menu/order_by_option.dart';
import 'package:cycle_it/views/components/side_menu/tag_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../settings_page.dart';

class SideMenu extends StatelessWidget {
  final itemListOrderCtrl = Get.find<ItemListOrderController>();
  final tagCtrl = Get.find<TagController>();

  SideMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(top: GetPlatform.isDesktop ? kDefaultPadding : 0),
      height: double.infinity,
      color: kSecondaryBgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          //padding: EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      //App 图标
                      Image.asset("assets/images/logo_transparent.png", width: 40, height: 40, fit: BoxFit.contain),
                      const SizedBox(width: 10),
                      // 中间文字
                      Expanded(
                        child: Text(
                          "Cycle It",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTitleTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //设置按钮
                      IconButton(
                        onPressed: () => Get.to(() => SettingsPage()),
                        icon: Icon(Icons.tune, color: kTitleTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding / 2),
              Divider(),
              SizedBox(height: kDefaultPadding / 2),
              //排序
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sort),
                        SizedBox(width: 5),
                        Text("Order By", style: TextStyle(fontWeight: FontWeight.w600, color: kTitleTextColor)),
                      ],
                    ),
                    OrderByOption(orderType: OrderType.name, icon: Icons.sort_by_alpha, title: "Names"),
                    OrderByOption(orderType: OrderType.lastUsed, icon: Icons.event, title: "Recent Used"),
                    OrderByOption(orderType: OrderType.frequency, icon: Icons.equalizer, title: "Frequency"),
                    SizedBox(height: 15),
                    Divider(),
                    //SizedBox(height: 5),
                    //标签
                    Row(
                      children: [
                        Icon(Icons.bookmark_outline),
                        SizedBox(width: 5),
                        Text("Tags", style: TextStyle(fontWeight: FontWeight.w600, color: kTitleTextColor)),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.dialog(AddTagDialog());
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                    Obx(() {
                      return Column(
                        children:
                            tagCtrl.allTags.map((tag) {
                              return TagOption(tagName: tag.name, color: tag.color);
                            }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
