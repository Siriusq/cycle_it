import 'package:flutter/material.dart';

class DetailsBriefCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String data;
  final String comment;

  const DetailsBriefCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double titleFontSize = maxWidth * 0.06;
        final double iconSize = maxWidth * 0.1;
        final double dataFontSize = maxWidth * 0.18;
        final double commentFontSize = maxWidth * 0.045;
        final double cardPadding = maxWidth * 0.005;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部标题区域
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: titleFontSize,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(icon, size: iconSize),
                  ],
                ),

                // 中间主数据区域（占剩余高度的75%）
                Expanded(
                  flex: 3, // 占总高度的3/4
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: dataFontSize,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // 底部注释区域
                Text(
                  comment,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: commentFontSize,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
