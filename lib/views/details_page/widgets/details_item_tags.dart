import 'package:flutter/material.dart';
import 'package:cycle_it/models/item_model.dart';

import '../../../utils/responsive_style.dart';
import '../../shared_widgets/icon_label.dart';

class DetailsItemTags extends StatelessWidget {
  final ItemModel item;
  const DetailsItemTags({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingXS = style.spacingXS;

    return Padding(
      padding: EdgeInsets.only(top: spacingXS, left: 2),
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
                    isLarge: true,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
