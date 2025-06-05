import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_list_order_controller.dart';

class OrderByOption extends StatelessWidget {
  OrderByOption({
    super.key,
    required this.orderType,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;
  final OrderType orderType;

  final itemListOrderCtrl = Get.find<ItemListOrderController>();

  @override
  Widget build(BuildContext context) {
    final style = ResponsiveStyle.to;
    final double optionFontSize = style.optionFontSize;

    return Obx(() {
      final isActive =
          itemListOrderCtrl.selectedOrderOption.value == orderType;

      return Padding(
        padding: EdgeInsets.only(top: 14),
        child: InkWell(
          onTap: () {
            itemListOrderCtrl.changeOrderOption(orderType);
          },
          child: Row(
            children: [
              if (!isActive)
                const SizedBox(width: 15)
              else if (itemListOrderCtrl.isAscending.value)
                Icon(Icons.arrow_upward, size: 15)
              else
                Icon(Icons.arrow_downward, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  //decoration: isActive ? BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDFE2EF)))) : null,
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color:
                            (isActive) ? kPrimaryColor : kGrayColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: optionFontSize,
                          fontWeight: FontWeight.normal,
                          color:
                              (isActive)
                                  ? kTitleTextColor
                                  : kGrayColor,
                        ),
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
