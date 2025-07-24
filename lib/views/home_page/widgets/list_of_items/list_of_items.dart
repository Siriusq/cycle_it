import 'package:flutter/material.dart';

import '../../../../utils/responsive_layout.dart';
import 'item_list_state_view.dart';
import 'list_of_items_app_bar.dart';

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
