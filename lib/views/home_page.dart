import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/list_of_items.dart';
import 'components/side_menu/side_menu.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    return Scaffold(
      body: Obx(() {
        return Responsive(
          mobile: _buildMobileLayout(itemCtrl),
          tablet: _buildTabletLayout(),
          desktop: _buildDesktopLayout(),
        );
      }),
    );
  }

  Widget _buildMobileLayout(ItemController ctrl) {
    return ctrl.selectedItem.value != null ? DetailsPage() : ListOfItems();
  }

  Widget _buildTabletLayout() {
    return Row(children: [Expanded(flex: 2, child: ListOfItems()), Expanded(flex: 3, child: _buildDetailSection())]);
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(width: 250, child: SideMenu()),
        SizedBox(width: 440, child: ListOfItems()),
        Expanded(child: _buildDetailSection()),
      ],
    );
  }

  Widget _buildDetailSection() {
    return GetBuilder<ItemController>(
      builder: (ctrl) {
        return ctrl.selectedItem.value != null ? DetailsPage() : Center(child: Text("请选择项目"));
      },
    );
  }
}
