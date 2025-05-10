import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../utils/responsive.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.isActive, required this.press});

  final ItemModel item;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: () {
          itemCtrl.selectItem(item);
          if (Responsive.isMobile(context)) Get.toNamed("/Details");
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: isActive && !Responsive.isMobile(context) ? kSecondaryBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 2.0,
                  color: isActive && !Responsive.isMobile(context) ? kSelectedBorderColor : kBorderColor,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              //padding: EdgeInsets.all(5),
                              width: 50,
                              height: 50,
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.rectangle,
                              //   border: Border.all(color: kSecondaryColor),
                              //   borderRadius: BorderRadius.circular(5),
                              //   color: kSecondaryColor,
                              // ),
                              child: SvgPicture.asset(
                                item.iconPath,
                                //width: 20,
                                //height: 20,
                                colorFilter: ColorFilter.mode(item.iconColor, BlendMode.srcIn),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(color: kTitleTextColor, fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  Text("${item.firstUsed}", style: TextStyle(color: kTextColor, fontSize: 10)),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                            Icon(Icons.warning, size: 18),
                            SizedBox(width: 10),
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Text("2d", style: TextStyle(color: kTextColor, fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
