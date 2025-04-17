import 'package:cycle_it/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'components/list_of_items.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: ListOfItems(),
        tablet: Row(children: [Expanded(flex: 2, child: ListOfItems()), Expanded(flex: 3, child: DetailsPage())]),
        desktop: Row(children: [SizedBox(width: 440, child: ListOfItems()), Expanded(child: DetailsPage())]),
      ),
    );
  }
}
