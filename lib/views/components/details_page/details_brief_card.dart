import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class DetailsBriefCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String data;
  final String comment;

  const DetailsBriefCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.data,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.responsiveStyle();
    final double spacingLG = style.spacingLG;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kSecondaryBgColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.5, color: kBorderColor),
            //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.005),
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
                          color: kTitleTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize:
                              constraints.maxWidth * 0.06, // 响应式字体
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      icon,
                      color: iconColor,
                      size: constraints.maxWidth * 0.1,
                    ),
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
                          color: kTitleTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize:
                              constraints.maxWidth * 0.18, // 动态字号
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
                    color: kTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: constraints.maxWidth * 0.045, // 响应式字体
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
