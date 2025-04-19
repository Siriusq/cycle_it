import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../utils/responsive.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          if (Responsive.isMobile(context))
            BackButton(
              onPressed: () {
                if (Get.key.currentState?.canPop() ?? false) {
                  Get.back();
                } else {
                  Get.toNamed("/");
                }
                itemCtrl.clearSelection();
              },
            ),
          IconButton(onPressed: () {}, icon: Icon(Icons.navigate_before)),
          IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next)),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
