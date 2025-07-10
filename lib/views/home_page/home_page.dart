import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../details_page/details_page.dart';
import '../side_menu/side_menu.dart';
import 'widgets/list_of_items/list_of_items.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(itemCtrl),
        tablet: _buildTabletLayout(itemCtrl),
        desktop: _buildDesktopLayout(itemCtrl),
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  Widget _buildMobileLayout(ItemController ctrl) {
    return ListOfItems(scaffoldKey: _scaffoldKey);
  }

  Widget _buildTabletLayout(ItemController ctrl) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListOfItems(scaffoldKey: _scaffoldKey),
        ),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 3,
          child: Obx(
            () =>
                ctrl.currentItem.value != null
                    ? DetailsPage()
                    : Container(
                      color: kPrimaryBgColor,
                      child: Center(child: Text("请选择项目")),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ItemController ctrl) {
    return Row(
      children: [
        SizedBox(width: 250, child: SideMenu()),
        VerticalDivider(thickness: 1, width: 1),
        SizedBox(
          width: 440,
          child: ListOfItems(scaffoldKey: _scaffoldKey),
        ),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Obx(
            () =>
                ctrl.currentItem.value != null
                    ? DetailsPage()
                    : Container(
                      color: kPrimaryBgColor,
                      child: Center(child: Text("请选择项目")),
                    ),
          ),
        ),
      ],
    );
  }
}
