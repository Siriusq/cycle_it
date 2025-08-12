import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/views/home_page/widgets/list_of_items/item_list_state_view.dart';
import 'package:cycle_it/views/home_page/widgets/list_of_items/list_of_items_app_bar.dart';
import 'package:flutter/material.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    return SafeArea(
      right: false,
      bottom: false,
      child: Scaffold(
        appBar: ListOfItemsAppBar(scaffoldKey: scaffoldKey),
        body: Column(
          children: [
            Expanded(
              // 解决横屏状态下滚动条重叠在卡片中的问题
              child: MediaQuery.removePadding(
                context: context,
                removeRight: !isSingleCol,
                removeTop: true,
                child: const ItemListStateView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
