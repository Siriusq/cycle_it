import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

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
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyTextStyle = style.bodyText;
    final TextStyle titleTextMD = style.titleTextMD;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double iconSize = maxWidth * 0.1;
        final double dataFontSize = maxWidth * 0.18;
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
                        style: titleTextMD,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    SizedBox(
                      height: titleTextMD.fontSize,
                      child: Icon(icon, size: iconSize),
                    ),
                  ],
                ),

                // 中间主数据区域（占剩余高度的75%）
                Expanded(
                  //flex: 3, // 占总高度的3/4
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
                  style: bodyTextStyle,
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
