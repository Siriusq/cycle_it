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
    final double spacingSideMenuOption = style.spacingSideMenuOption;

    return Obx(() {
      final isActive =
          itemListOrderCtrl.selectedOrderOption.value == orderType;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: InkWell(
          onTap: () {
            itemListOrderCtrl.changeOrderOption(orderType);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isActive
                      ? kPrimaryColor.withAlpha(30)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: spacingSideMenuOption,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isActive ? kPrimaryColor : kGrayColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: optionFontSize,
                        fontWeight: FontWeight.normal,
                        color:
                            isActive ? kTitleTextColor : kGrayColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (isActive)
                    itemListOrderCtrl.isAscending.value
                        ? const Icon(
                          Icons.arrow_upward,
                          size: 22,
                          color: kPrimaryColor,
                        )
                        : const Icon(
                          Icons.arrow_downward,
                          size: 22,
                          color: kPrimaryColor,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
