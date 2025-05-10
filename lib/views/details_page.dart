import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/details_header.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return Obx(() {
      final ItemModel? item = itemCtrl.selectedItem.value;
      if (item == null) {
        return const SizedBox.shrink();
      }

      return Container(
        color: kPrimaryBgColor,
        child: SafeArea(
          child: Column(
            children: [
              DetailsHeader(),
              Divider(thickness: 1), //未对齐的分隔线
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('名称：${item.name}'),
                      SizedBox(height: 8),
                      Text('首次使用：${item.firstUsed}'),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
