import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../utils/responsive.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();
    return Padding(
      padding: EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        top: kDefaultPadding,
        bottom: kDefaultPadding / 2,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            if (itemCtrl.selectedItem.value != null)
              BackButton(
                onPressed: () {
                  itemCtrl.clearSelection();
                  // 确保路由同步
                  if (!Responsive.isMobile(context)) {
                    Get.back();
                    //Get.offAllNamed('/');
                  }
                },
              ),
            // IconButton(onPressed: () {}, icon: Icon(Icons.navigate_before)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next)),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          ],
        ),
      ),
    );
  }
}
