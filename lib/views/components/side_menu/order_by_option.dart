import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_list_order_controller.dart';

class OrderByOption extends StatelessWidget {
  OrderByOption({super.key, required this.orderType, required this.icon, required this.title});

  final IconData icon;
  final String title;
  final OrderType orderType;

  final itemListOrderCtrl = Get.find<ItemListOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = itemListOrderCtrl.selectedOrderOption.value == orderType;

      return Padding(
        padding: EdgeInsets.only(top: kDefaultPadding),
        child: InkWell(
          onTap: () {
            itemListOrderCtrl.changeOrderOption(orderType);
          },
          child: Row(
            children: [
              if (isActive) Icon(Icons.arrow_forward_ios, size: 15) else SizedBox(width: 15),
              SizedBox(width: kDefaultPadding / 4),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  //decoration: isActive ? BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDFE2EF)))) : null,
                  child: Row(
                    children: [
                      Icon(icon, color: (isActive) ? kPrimaryColor : kGrayColor),
                      SizedBox(width: kDefaultPadding / 2),
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.w500, color: (isActive) ? kTitleTextColor : kGrayColor),
                      ),
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
