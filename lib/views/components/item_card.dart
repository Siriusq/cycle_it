import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/extensions.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.isActive, required this.press});

  final ItemModel item;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.laptop_mac, size: 30),
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
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: Offset(5, 5),
              topShadowColor: Colors.white60,
              bottomShadowColor: Color(0x6643AF9D),
            ),
          ],
        ),
      ),
    );
  }
}
