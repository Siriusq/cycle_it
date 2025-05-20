import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/icon_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../responsive_component_group.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.isActive,
    required this.press,
  });

  final ItemModel item;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final double spacingLG = context.responsiveStyle().spacingLG;
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacingLG,
        vertical: spacingLG * 0.5,
      ),
      child: InkWell(
        onTap: () {
          itemCtrl.selectItem(item);
          if (isSingleCol) Get.toNamed("/Details");
        },
        child: Container(
          padding: EdgeInsets.all(spacingLG * 0.5),
          //动态边框
          decoration: BoxDecoration(
            color:
                isActive && !isSingleCol
                    ? kSecondaryBgColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2.0,
              color:
                  isActive && !isSingleCol
                      ? kSelectedBorderColor
                      : kBorderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 图标、名称、更多按钮
              _buildTitle(context),

              // 详细使用数据，仅在桌面宽屏显示
              _buildOverview(context),

              // 进度条区域
              _buildDateProgressBar(
                item.timePercentageBetweenLastAndNext(),
                context,
              ),

              //标签
              _buildTags(context),
            ],
          ),
        ),
      ),
    );
  }

  // 图标、名称、更多按钮
  Widget _buildTitle(BuildContext context) {
    final style = context.responsiveStyle();
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingMD = style.spacingMD;
    final double iconSizeMD = style.iconSizeMD;
    final double iconSizeLG = style.iconSizeLG;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: isTripleCol ? 5 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 顶部对齐
        children: [
          // 图标部分
          Padding(
            padding: const EdgeInsets.only(top: 2), // 微调图标垂直对齐
            child: SizedBox(
              width: 25,
              height: 25,
              child: SvgPicture.asset(
                item.iconPath,
                colorFilter: ColorFilter.mode(
                  kIconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: spacingMD),

          // 文字内容区域
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.name,
                        style: titleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // 备注区域
                if (item.usageComment?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4), // 增加间距
                  Text(
                    item.usageComment!,
                    style: smallBodyTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // 更多按钮
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: iconSizeLG,
              height: iconSizeLG, // 点击区域大小
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.more_vert, size: iconSizeMD), // 视觉图标
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // 点击事件
                        },
                        customBorder:
                            const CircleBorder(), // 设置点击区域为圆形
                        //splashFactory: NoSplash.splashFactory, // 可选：禁用水波纹
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 详细使用数据，仅在桌面宽屏显示
  Widget _buildOverview(BuildContext context) {
    final int usageCount = item.usageRecords.length;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? lastUsedDate =
        usageCount > 0 ? item.usageRecords.last.usedAt : null;
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    final style = context.responsiveStyle();
    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingXS = style.spacingXS;
    final double spacingMD = style.spacingMD;
    final double iconSizeSM = style.iconSizeSM;
    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);

    if (!isTripleCol) {
      return Padding(
        padding: EdgeInsets.only(
          left: 5,
          bottom: spacingMD,
          top: spacingMD,
        ),
        child: Row(
          children: [
            Icon(Icons.repeat, color: kTextColor, size: iconSizeSM),
            SizedBox(width: spacingXS),
            Flexible(
              child: Text(
                "Usage Cycle: ${usageCount > 1 ? '$usageFrequency days' : 'data not enough'}",
                style: smallBodyTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ResponsiveComponentGroup(
          minComponentWidth: 160,
          aspectRation: 5,
          children: [
            // 上次使用
            _buildUsageStatItem(
              icon: Icons.history,
              title: "Last Used",
              value:
                  lastUsedDate != null
                      ? lastUsedDate.toLocal().toString().split(
                        ' ',
                      )[0]
                      : 'data not enough',
              context: context,
            ),
            // 使用次数
            _buildUsageStatItem(
              icon: Icons.pin_outlined,
              title: "Usage Count",
              value: "$usageCount times",
              context: context,
            ),
            // 使用周期
            _buildUsageStatItem(
              icon: Icons.repeat,
              title: "Usage Cycle",
              value:
                  usageCount > 1
                      ? '$usageFrequency days'
                      : 'data not enough',
              context: context,
            ),
            // 下次使用预计
            _buildUsageStatItem(
              icon: Icons.update,
              title: "EST. Next Use",
              value:
                  nextExpectedUseDate != null
                      ? nextExpectedUseDate
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                      : 'data not enough',
              context: context,
            ),
          ],
        ),
      );
    }
  }

  // 日期进度条组件
  Widget _buildDateProgressBar(
    double progress,
    BuildContext context,
  ) {
    final TextStyle smallBodyTextStyle =
        context.responsiveStyle().bodyTextSM;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: kBorderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text("EST. Timer", style: smallBodyTextStyle),
                Spacer(),
                Text(
                  "${(item.timePercentageBetweenLastAndNext() * 100).toStringAsFixed(2)}%",
                  style: smallBodyTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 单个数据项组件
  Widget _buildUsageStatItem({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 图标部分
            Icon(icon, size: 18, color: kTextColor),

            SizedBox(width: 6),

            // 文字部分
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    title,
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 12,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 数值
                  Text(
                    value,
                    style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 底部标签行
  Widget _buildTags(BuildContext context) {
    final double spacingXS = context.responsiveStyle().spacingXS;
    return Padding(
      padding: EdgeInsets.only(top: spacingXS, left: 2),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          children:
              item.tags.map((tag) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: IconLabel(
                    icon: Icons.bookmark,
                    label: tag.name,
                    iconColor: tag.color,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
