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
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: Row(
        children: [
          if (Responsive.isMobile(context))
            BackButton(
              onPressed: () {
                // if (Get.key.currentState!.canPop()) {
                //   print('Current route: ${Get.routing.current}');
                //   print('Previous route: ${Get.routing.previous}');
                //   print('Is back?: ${Get.routing.isBack}');
                //
                //   Get.back();
                // } else {
                //   Get.toNamed("/");
                // }

                // itemCtrl.clearSelection();
                if (Get.currentRoute == '/Details') {
                  // 只有在真的跳到详情页（/Details）时才执行返回
                  Get.back();
                } else {
                  // 否则只是清除选中状态，让HomePage回到列表模式
                  itemCtrl.clearSelection();
                }
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
