import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/views/components/icon_label.dart';
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
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding / 2),
          //动态边框
          decoration: BoxDecoration(
            color: isActive && !Responsive.isMobile(context) ? kSecondaryBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2.0,
              color: isActive && !Responsive.isMobile(context) ? kSelectedBorderColor : kBorderColor,
            ),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 图标、名称、更多按钮
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset(
                        item.iconPath,
                        colorFilter: ColorFilter.mode(kTitleTextColor, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(color: kTitleTextColor, fontWeight: FontWeight.w500, fontSize: 16),
                        softWrap: true,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                  ],
                ),
              ),

              // 上次使用、预计下次使用、使用频率
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 5, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.update, color: kGrayColor, size: 16),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Last used date: ${item.usageRecords.last.usedAt.toLocal().toString().split(' ')[0]}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.event_repeat, color: kGrayColor, size: 16),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.nextExpectedUse == null
                                ? "Insufficient data"
                                : "Estimated next use date: ${item.nextExpectedUse?.toLocal().toString().split(' ')[0]}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.equalizer_rounded, color: kGrayColor, size: 16),
                        SizedBox(width: 5),
                        Expanded(child: Text("Usage Cycle: ${item.usageFrequency} days")),
                      ],
                    ),
                  ],
                ),
              ),

              //标签
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 5),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    children:
                        item.tags.map((tag) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: IconLabel(icon: Icons.bookmark, label: tag.name, iconColor: tag.color),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
