import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../details_page/details_page.dart';
import '../side_menu/side_menu.dart';
import 'widgets/list_of_items/list_of_items.dart';

// 在 initState 中触发初始数据加载
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final itemCtrl = Get.find<ItemController>();

  @override
  void initState() {
    super.initState();
    // 初始加载逻辑
    // 使用 addPostFrameCallback 确保在第一帧渲染后（即UI显示后）才开始加载数据
    // 这样可以避免启动时UI线程被阻塞，用户会先看到加载指示器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 检查 allItems 是否为空，防止在页面重建时重复加载数据
      if (itemCtrl.allItems.isEmpty) {
        itemCtrl.loadAllItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
        scaffoldKey: _scaffoldKey,
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListOfItems(scaffoldKey: _scaffoldKey);
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListOfItems(scaffoldKey: _scaffoldKey),
        ),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 3,
          // 监听 selectedItemPreview
          // DetailsPage 内部会自己处理加载状态
          child: Obx(
            () =>
                itemCtrl.selectedItemPreview.value != null
                    ? DetailsPage()
                    : Center(child: Text('please_select_an_item'.tr)),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
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
          // 监听 selectedItemPreview
          child: Obx(
            () =>
                itemCtrl.selectedItemPreview.value != null
                    ? DetailsPage()
                    : Center(child: Text('please_select_an_item'.tr)),
          ),
        ),
      ],
    );
  }
}
