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
    final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;

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
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    icon,
                    color:
                        isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                              context,
                            ).colorScheme.secondaryFixedDim,
                    size: 22,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: bodyMD.copyWith(
                        color:
                            isActive
                                ? Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer
                                : Theme.of(
                                  context,
                                ).colorScheme.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (isActive)
                    itemListOrderCtrl.isAscending.value
                        ? Icon(
                          Icons.arrow_upward,
                          size: 22,
                          color:
                              Theme.of(context).colorScheme.primary,
                        )
                        : Icon(
                          Icons.arrow_downward,
                          size: 22,
                          color:
                              Theme.of(context).colorScheme.primary,
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
