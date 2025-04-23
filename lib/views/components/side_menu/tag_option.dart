import 'package:cycle_it/controllers/item_list_tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class TagOption extends StatelessWidget {
  final String tagName;
  final Color color;
  final tagCtrl = Get.find<ItemListTagController>();

  TagOption({super.key, required this.tagName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = tagCtrl.selectedTags.contains(tagName);
      return Padding(
        padding: EdgeInsets.only(top: kDefaultPadding),
        child: InkWell(
          onTap: () {
            tagCtrl.toggleTag(tagName);
          },
          child: Row(
            children: [
              SizedBox(width: 25),
              isSelected ? Icon(Icons.bookmark, color: color) : Icon(Icons.bookmark_outline, color: kGrayColor),
              //Icon(isSelected ? Icons.bookmark : Icons.bookmark_outline, color: color, size: 18),
              SizedBox(width: kDefaultPadding / 2),
              Text(tagName, style: TextStyle(fontWeight: FontWeight.w500, color: kTextColor)),
            ],
          ),
        ),
      );
    });
  }
}
