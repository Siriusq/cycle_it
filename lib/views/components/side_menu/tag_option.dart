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
    final double spacingSideMenuOption = style.spacingSideMenuOption;

    return Obx(() {
      final isSelected = tagCtrl.selectedTags.contains(tagName);
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2,
        ), // Reduced vertical padding for a tighter list
        child: InkWell(
          onTap: () {
            tagCtrl.toggleTag(tagName);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? color.withAlpha(30)
                      : Colors
                          .transparent, // Light background when selected
              borderRadius: BorderRadius.circular(
                8.0,
              ), // Rounded corners for the container
              border: Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: spacingSideMenuOption,
              ), // Inner padding
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    // Use filled icon when selected
                    color:
                        color, // Icon color always uses the tag's color
                    size:
                        22, // Slightly increased icon size for better visibility
                  ),
                  const SizedBox(width: 12), // Increased spacing
                  Expanded(
                    child: Text(
                      tagName,
                      style: TextStyle(
                        fontSize: optionFontSize,
                        fontWeight: FontWeight.normal,
                        color:
                            isSelected
                                ? kTitleTextColor
                                : kGrayColor, // Text color remains as per original logic
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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
