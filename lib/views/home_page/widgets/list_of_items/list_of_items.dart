import 'package:flutter/material.dart';

import 'item_list_state_view.dart';
import 'list_of_items_app_bar.dart';

class ListOfItems extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ListOfItems({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      child: Scaffold(
        appBar: ListOfItemsAppBar(scaffoldKey: scaffoldKey),
        body: const Column(
          children: [Expanded(child: ItemListStateView())],
        ),
      ),
    );
  }
}
