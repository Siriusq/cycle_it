import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/utils/extensions.dart';
import 'package:cycle_it/utils/responsive.dart';
import 'package:cycle_it/views/components/side_menu/order_by_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                      label: Text("New message", style: TextStyle(color: kTitleTextColor)),
                    ).addNeumorphism(topShadowColor: Colors.white, bottomShadowColor: Color(0x6643AF9D)),
                  SizedBox(height: kDefaultPadding * 2),
                  Text("Order By", style: TextStyle(fontWeight: FontWeight.w600, color: kTitleTextColor)),
                  OrderByOption(index: 1, icon: Icons.abc, title: "Names"),
                  OrderByOption(index: 2, icon: Icons.timeline, title: "Add Time"),
                  OrderByOption(index: 3, icon: Icons.recent_actors, title: "Last Used Time"),
                  SizedBox(height: 50),
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
