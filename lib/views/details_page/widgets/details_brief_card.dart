import 'package:chinese_font_library/chinese_font_library.dart';
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
        // 数字字体动态大小
        final double dataFontSize = constraints.maxWidth * 0.18;

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
            padding: const EdgeInsets.all(4),
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
                        style:
                            Theme.of(context).textTheme.titleMedium!
                                .useSystemChineseFont(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 16, child: Icon(icon)),
                  ],
                ),

                // 中间主数据区域
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge!.copyWith(
                          fontSize: dataFontSize,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // 底部注释区域
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment,
                        style: Theme.of(context).textTheme.bodySmall!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
