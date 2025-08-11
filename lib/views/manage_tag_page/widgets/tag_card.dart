import 'package:flutter/material.dart';

import '../../../models/tag_model.dart';
import 'tag_action_button.dart';

// 每一条标签及操作按钮
class TagCard extends StatelessWidget {
  final TagModel tag;

  const TagCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
        leading: Icon(Icons.bookmark, color: tag.color),
        title: Text(tag.name),
        trailing: TagActionButton(tag: tag),
      ),
    );
  }
}
