import 'package:flutter/material.dart';

import '../../../../models/item_model.dart';
import '../../../shared_widgets/icon_label.dart';

class ItemCardTags extends StatelessWidget {
  final ItemModel item;

  const ItemCardTags({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 2),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 5,
          children:
              item.tags.map((tag) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: IconLabel(
                    icon: Icons.bookmark,
                    label: tag.name,
                    iconColor: tag.color,
                    isLarge: false,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
