import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/list_of_items.dart';
import 'components/side_menu/side_menu.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      body: Responsive(
        mobile: _buildMobileLayout(itemCtrl),
        tablet: _buildTabletLayout(itemCtrl),
        desktop: _buildDesktopLayout(itemCtrl),
      ),
    );
  }

  Widget _buildMobileLayout(ItemController ctrl) {
    return ctrl.selectedItem.value != null
        ? DetailsPage()
        : ListOfItems(
          scaffoldKey: _scaffoldKey, // 传入 key
        );
  }

  Widget _buildTabletLayout(ItemController ctrl) {
    return Row(
      children: [
        Expanded(flex: 2, child: ListOfItems(scaffoldKey: _scaffoldKey)),
        Expanded(
          flex: 3,
          child: Obx(() => ctrl.selectedItem.value != null ? DetailsPage() : Center(child: Text("请选择项目"))),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ItemController ctrl) {
    return Row(
      children: [
        SizedBox(width: 250, child: SideMenu()),
        SizedBox(width: 440, child: ListOfItems(scaffoldKey: _scaffoldKey)),
        Expanded(child: Obx(() => ctrl.selectedItem.value != null ? DetailsPage() : Center(child: Text("请选择项目")))),
      ],
    );
  }
}
