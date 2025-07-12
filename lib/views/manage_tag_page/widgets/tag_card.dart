import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_controller.dart';
import '../../../models/tag_model.dart';
import '../../../utils/responsive_style.dart';
import 'tag_action_button.dart';

class TagCard extends StatelessWidget {
  final TagModel tag;

  const TagCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final double iconSizeMD = style.iconSizeMD;
    final TextStyle bodyTextStyle = style.bodyText;

    return Obx(() {
      final ThemeData currentTheme = themeController.currentThemeData;

      return Card(
        color: currentTheme.colorScheme.surfaceContainer,
        margin: EdgeInsets.symmetric(vertical: spacingSM * 0.5),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: currentTheme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(
            spacingMD,
            0,
            spacingSM,
            0,
          ),
          leading: Icon(
            Icons.bookmark,
            color: tag.color,
            size: iconSizeMD,
          ),
          title: Text(tag.name, style: bodyTextStyle),
          trailing: TagActionButton(tag: tag),
        ),
      );
    });
  }
}
