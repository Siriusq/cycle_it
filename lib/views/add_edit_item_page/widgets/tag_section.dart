import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../shared_widgets/icon_label.dart';
import 'item_tag_picker_dialog.dart';

class TagSection extends StatelessWidget {
  const TagSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditItemController controller =
        Get.find<AddEditItemController>();

    final TextStyle titleMD =
        Theme.of(
          context,
        ).textTheme.titleMedium!.useSystemChineseFont();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('tags'.tr, style: titleMD),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final List<Widget> tagWidgets =
                controller.selectedTags.map((tag) {
                  return SizedBox(
                    child: IconLabel(
                      icon: Icons.bookmark,
                      label: tag.name,
                      iconColor: tag.color,
                      isLarge: true,
                    ),
                  );
                }).toList();

            tagWidgets.add(
              SizedBox(
                child: InkWell(
                  onTap: () {
                    showItemTagPickerDialog(context);
                  },
                  child: IconLabel(
                    icon: Icons.bookmark_add_outlined,
                    label: 'select_tag'.tr,
                    iconColor: Theme.of(context).colorScheme.primary,
                    isLarge: true,
                  ),
                ),
              ),
            );

            return Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: tagWidgets,
            );
          }),
        ),
      ],
    );
  }
}
