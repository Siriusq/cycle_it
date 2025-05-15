import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive.dart';
import 'package:cycle_it/views/components/icon_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../responsive_component_group.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.isActive, required this.press});

  final ItemModel item;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final int usageCount = item.usageRecords.length;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? firstUsedDate = usageCount > 0 ? item.usageRecords.first.usedAt : null;
    final DateTime? lastUsedDate = usageCount > 0 ? item.usageRecords.last.usedAt : null;
    final int daysSinceLastUse = item.daysBetweenTodayAnd(false).abs();
    final int daysTillNextUse = item.daysBetweenTodayAnd(true);
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: () {
          itemCtrl.selectItem(item);
          if (Responsive.isMobile(context)) Get.toNamed("/Details");
        },
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding / 2),
          //动态边框
          decoration: BoxDecoration(
            color: isActive && !Responsive.isMobile(context) ? kSecondaryBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2.0,
              color: isActive && !Responsive.isMobile(context) ? kSelectedBorderColor : kBorderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 图标、名称、更多按钮
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5),
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
                          colorFilter: ColorFilter.mode(kIconColor, BlendMode.srcIn),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

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
                                  style: TextStyle(
                                    color: kTitleTextColor,
                                    fontWeight: FontWeight.w600, // 加粗提升可读性
                                    fontSize: Responsive.isMobile(context) ? 15 : 17,
                                    height: 1.2, // 行高调整
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // 备注区域（条件渲染）
                          if (item.usageComment?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 4), // 增加间距
                            Text(
                              item.usageComment!,
                              style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: Responsive.isMobile(context) ? 10 : 12,
                                height: 1.3, // 更紧凑的行高
                              ),
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
                      child: IconButton(
                        icon: Icon(Icons.more_horiz, size: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              //使用数据区域
              Padding(
                padding: const EdgeInsets.all(5),
                child: ResponsiveComponentGroup(
                  minComponentWidth: 80,
                  aspectRation: 3,
                  children: [
                    // 上次使用
                    _buildUsageStatItem(
                      icon: Icons.history,
                      title: "Last Used",
                      value: lastUsedDate != null ? lastUsedDate.toLocal().toString().split(' ')[0] : 'data not enough',
                      context: context,
                    ),
                    // 使用次数
                    // _buildUsageStatItem(
                    //   icon: Icons.pin_outlined,
                    //   title: "Usage Count",
                    //   value: "$usageCount times",
                    //   context: context,
                    // ),
                    // 使用周期
                    _buildUsageStatItem(
                      icon: Icons.repeat,
                      title: "Usage Cycle",
                      value: usageCount > 1 ? '$usageFrequency days' : 'data not enough',
                      context: context,
                    ),
                    // 下次使用预计
                    _buildUsageStatItem(
                      icon: Icons.update,
                      title: "EST. Next Use",
                      value:
                          nextExpectedUseDate != null
                              ? nextExpectedUseDate.toLocal().toString().split(' ')[0]
                              : 'data not enough',
                      context: context,
                    ),
                  ],
                ),
              ),

              // 进度条区域
              _buildDateProgressBar(item.timePercentageBetweenLastAndNext(), context),

              //标签
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
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
                            child: IconLabel(icon: Icons.bookmark, label: tag.name, iconColor: tag.color),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 日期进度条组件
  Widget _buildDateProgressBar(double progress, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(color: kBorderColor, borderRadius: BorderRadius.circular(3)),
                      ),
                      Container(
                        height: 6,
                        width: constraints.maxWidth * value,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "EST.: ${item.nextExpectedUse}",
                style: TextStyle(color: kTextColor, fontSize: Responsive.isMobile(context) ? 10 : 12),
              ),
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
        // 响应式布局判断
        final isCompactLayout = constraints.maxWidth < 120;
        final iconSize = isCompactLayout ? 14.0 : 18.0;
        final spacing = isCompactLayout ? 4.0 : 6.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 图标部分
            Icon(icon, size: iconSize, color: kTextColor),

            SizedBox(width: spacing),

            // 文字部分
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isCompactLayout ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    title,
                    style: TextStyle(color: kTextColor, fontSize: isCompactLayout ? 10 : 12, height: 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 数值
                  Text(
                    value,
                    style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: _calculateValueSize(constraints.maxWidth),
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

  // 动态计算数值字体大小
  double _calculateValueSize(double containerWidth) {
    return containerWidth < 100
        ? 10
        : containerWidth < 150
        ? 12
        : containerWidth < 200
        ? 14
        : 16;
  }
}
