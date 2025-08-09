import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagOption extends StatelessWidget {
  final String tagName;
  final Color color;
  final tagCtrl = Get.find<TagController>();

  TagOption({super.key, required this.tagName, required this.color});

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyMD = Theme.of(context).textTheme.bodyMedium!;

    return Obx(() {
      final isSelected = tagCtrl.selectedTags.contains(tagName);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: InkWell(
          onTap: () {
            tagCtrl.toggleTag(tagName);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? color.withAlpha(50)
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
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: color,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tagName,
                      style: bodyMD.copyWith(
                        color:
                            isSelected
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
