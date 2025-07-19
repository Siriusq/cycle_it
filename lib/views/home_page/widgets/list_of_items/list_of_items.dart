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
      child: Scaffold(
        appBar: ListOfItemsAppBar(scaffoldKey: scaffoldKey),
        body: Column(
          children: [
            Expanded(
                child: MediaQuery.removePadding(
                    context:context,
                    removeRight: !isSingleCol,
                    removeTop: isSingleCol,
                    child: const ItemListStateView()
                )
            )
          ],
        ),
      ),
    );
  }
}
