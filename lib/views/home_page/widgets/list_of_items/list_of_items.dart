import 'package:flutter/material.dart';

import 'item_list_state_view.dart';
import 'list_of_items_header.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      child: Column(
        children: [
          // 顶部导航栏
          ListOfItemsHeader(scaffoldKey: scaffoldKey),

          // 分割线
          Divider(height: 0),

          // 物品卡片列表状态视图
          const Expanded(child: ItemListStateView()),
        ],
      ),
    );
  }
}
