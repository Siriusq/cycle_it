import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/utils/extensions.dart';
import 'package:cycle_it/utils/responsive.dart';
import 'package:cycle_it/views/components/side_menu/order_by_option.dart';
import 'package:cycle_it/views/components/side_menu/tag_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../test/mock_data.dart';
import '../../../utils/constants.dart';
import '../../settings_page.dart';

class SideMenu extends StatelessWidget {
  final itemListOrderCtrl = Get.find<ItemListOrderController>();

  SideMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: kBgLightColor,
      child: SafeArea(
        child: Stack(
          children: [
            // 滚动内容区域
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: 80, // 留出按钮的高度空间，避免内容被遮挡
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      //关闭按钮
                      if (!Responsive.isDesktop(context)) CloseButton(),
                    ],
                  ),
                  if (Responsive.isDesktop(context)) SizedBox(height: kDefaultPadding),
                  //宽屏显示添加按钮
                  if (Responsive.isDesktop(context))
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 0),
                        padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.create_rounded),
                      label: Text("Add Item", style: TextStyle(color: kTitleTextColor)),
                    ).addNeumorphism(topShadowColor: Colors.white, bottomShadowColor: Color(0x6643AF9D)),
                  //SizedBox(height: kDefaultPadding * 2),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 10),
                  //排序
                  Row(
                    children: [
                      Icon(Icons.sort, color: kGrayColor),
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
                      Icon(Icons.bookmark_outline, color: kGrayColor),
                      SizedBox(width: 5),
                      Text("Tags", style: TextStyle(fontWeight: FontWeight.w600, color: kTitleTextColor)),
                      Spacer(),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add, color: kGrayColor)),
                    ],
                  ),
                  Column(
                    children:
                        allTags.map((tag) {
                          return TagOption(tagName: tag.name, color: tag.color);
                        }).toList(),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                ],
              ),
            ),

            // 固定在底部的按钮栏
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: kBgLightColor,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: () => Get.to(() => SettingsPage()), icon: Icon(Icons.settings)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.upload_file)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.copyright)),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
