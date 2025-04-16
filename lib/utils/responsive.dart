import 'package:cycle_it/views/components/list_of_items.dart';
import 'package:cycle_it/views/details_page.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile = ListOfItems();
  final Widget desktop = Row(
    children: [Expanded(flex: 6, child: ListOfItems()), Expanded(flex: 9, child: DetailsPage())],
  );

  Responsive({super.key});

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 650;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 650 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 650) {
          return desktop;
        }
        // Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}
