import 'package:flutter/material.dart';

import '../../../models/tag_model.dart';
import '../../../utils/responsive_style.dart';
import 'tag_action_button.dart';

// 每一条标签及操作按钮
class TagCard extends StatelessWidget {
  final TagModel tag;

  const TagCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingMD = style.spacingMD;
    final double iconSizeMD = style.iconSizeMD;
    final TextStyle bodyTextStyle = style.bodyText;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.symmetric(vertical: spacingSM * 0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
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
  }
}
