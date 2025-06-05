import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class TagOption extends StatelessWidget {
  final String tagName;
  final Color color;
  final tagCtrl = Get.find<TagController>();

  TagOption({super.key, required this.tagName, required this.color});

  @override
  Widget build(BuildContext context) {
    final style = ResponsiveStyle.to;
    final double optionFontSize = style.optionFontSize;

    return Obx(() {
      final isSelected = tagCtrl.selectedTags.contains(tagName);
      return Padding(
        padding: EdgeInsets.only(top: 14),
        child: InkWell(
          onTap: () {
            tagCtrl.toggleTag(tagName);
          },
          child: Row(
            children: [
              const SizedBox(width: 25),
              isSelected
                  ? Icon(Icons.bookmark, color: color)
                  : Icon(Icons.bookmark_outline, color: kGrayColor),
              //Icon(isSelected ? Icons.bookmark : Icons.bookmark_outline, color: color, size: 18),
              const SizedBox(width: 10),
              Text(
                tagName,
                style: TextStyle(
                  fontSize: optionFontSize,
                  fontWeight: FontWeight.normal,
                  color: isSelected ? kTitleTextColor : kGrayColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
