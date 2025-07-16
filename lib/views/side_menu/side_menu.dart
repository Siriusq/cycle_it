import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/side_menu/widgets/side_menu_app_bar.dart';
import 'package:cycle_it/views/side_menu/widgets/side_menu_ordering_section.dart';
import 'package:cycle_it/views/side_menu/widgets/side_menu_tag_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final itemListOrderCtrl = Get.find<ItemListOrderController>();
  final tagCtrl = Get.find<TagController>();

  SideMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final style = ResponsiveStyle.to;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: SideMenuAppBar(),
        body: Container(
          height: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //排序
                SideMenuOrderingSection(),

                // 分割线
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: style.spacingLG,
                  ),
                  child: const Divider(height: 0),
                ),

                //标签
                SideMenuTagSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
