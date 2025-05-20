import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/details_page/details_brief_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_layout.dart';
import '../icon_label.dart';
import '../responsive_component_group.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final style = context.responsiveStyle();
    final double spacingXS = style.spacingXS;
    final double spacingLG = style.spacingLG;
    final bool isMobile = GetPlatform.isIOS || GetPlatform.isAndroid;
    final double headerSpacing = isMobile ? 4 : 20;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;
    final double bottomSpacing = isMobile ? 0 : 10;
    final double dividerHeight = isMobile ? 0 : 16;
    final TextStyle largeTitleTextStyle = style.titleTextLG;

    return Obx(() {
      final ItemModel? item = itemCtrl.selectedItem.value;
      if (item == null) {
        return const SizedBox.shrink();
      }

      final int usageCount = item.usageRecords.length;
      final DateTime? nextExpectedUseDate = item.nextExpectedUse;
      final DateTime? firstUsedDate =
          usageCount > 0 ? item.usageRecords.first.usedAt : null;
      final DateTime? lastUsedDate =
          usageCount > 0 ? item.usageRecords.last.usedAt : null;
      final int daysSinceLastUse =
          item.daysBetweenTodayAnd(false).abs();
      final int daysTillNextUse = item.daysBetweenTodayAnd(true);
      final double usageFrequency = item.usageFrequency.toPrecision(
        2,
      );

      return Scaffold(
        body: Container(
          color: kPrimaryBgColor,
          child: SafeArea(
            child: Column(
              children: [
                // 顶栏
                _buildHeader(context, style, isMobile),

                // 分割线
                SizedBox(height: bottomSpacing),
                Divider(height: dividerHeight),
                SizedBox(height: spacingXS),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacingLG,
                    ),
                    child: Column(
                      children: [
                        //标题、标签与图标
                        _buildTitle(context, style, item),
                        _buildTags(context, style, item),

                        SizedBox(height: spacingLG),

                        //图表
                        _buildOverview(context, style, item),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    ResponsiveStyle style,
    bool isMobile,
  ) {
    final itemCtrl = Get.find<ItemController>();

    final double spacingLG = style.spacingLG;
    final double headerSpacing = isMobile ? 4 : 20;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;
    final double topBarHeight = isMobile ? 32 : 48;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalSpacing,
        right: horizontalSpacing,
        top: headerSpacing,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            if (itemCtrl.selectedItem.value != null)
              BackButton(
                onPressed: () {
                  itemCtrl.clearSelection();
                  // 确保路由同步
                  if (!ResponsiveLayout.isSingleCol(context)) {
                    Get.back();
                    //Get.offAllNamed('/');
                  }
                },
              ),
            // IconButton(onPressed: () {}, icon: Icon(Icons.navigate_before)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next)),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit_outlined),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ResponsiveStyle style,
    ItemModel item,
  ) {
    final TextStyle largeTitleTextStyle = style.titleTextLG;
    final TextStyle bodyText = style.bodyText;
    final double spacingMD = style.spacingMD;
    final double spacingLG = style.spacingLG;

    return Padding(
      padding: EdgeInsets.symmetric(
        //horizontal: spacingLG,
        vertical: spacingLG * 0.5,
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset(
                item.iconPath,
                colorFilter: ColorFilter.mode(
                  kIconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: spacingLG),

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
                        style: largeTitleTextStyle,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),

                // 备注区域
                if (item.usageComment?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4), // 增加间距
                  Text(
                    item.usageComment!,
                    style: bodyText,
                    softWrap: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 底部标签行
  Widget _buildTags(
    BuildContext context,
    ResponsiveStyle style,
    ItemModel item,
  ) {
    final double spacingXS = style.spacingXS;

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

  // 详细使用数据，仅在桌面宽屏显示
  Widget _buildOverview(
    BuildContext context,
    ResponsiveStyle style,
    ItemModel item,
  ) {
    final int usageCount = item.usageRecords.length;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? firstUsedDate =
        usageCount > 0 ? item.usageRecords.first.usedAt : null;
    final DateTime? lastUsedDate =
        usageCount > 0 ? item.usageRecords.last.usedAt : null;
    final int daysSinceLastUse =
        item.daysBetweenTodayAnd(false).abs();
    final int daysTillNextUse = item.daysBetweenTodayAnd(true);
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    final double minComponentWidth = style.minComponentWidth;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: ResponsiveComponentGroup(
        minComponentWidth: minComponentWidth,
        aspectRation: 1.8,
        children: [
          // 使用次数，自首次使用记录起
          DetailsBriefCard(
            title: 'Usage Count',
            icon: Icons.pin,
            iconColor: kIconColor,
            data: '$usageCount',
            comment:
                firstUsedDate != null
                    ? 'times since ${firstUsedDate.toLocal().toString().split(' ')[0]}'
                    : 'no usage records',
          ),
          // 使用周期
          DetailsBriefCard(
            title: 'Usage Cycle',
            icon: Icons.loop,
            iconColor: kIconColor,
            data: usageCount > 1 ? '$usageFrequency' : '-',
            comment:
                usageCount > 1 ? 'days per usage' : 'data not enough',
          ),
          // 上次使用
          DetailsBriefCard(
            title: 'Last Used',
            icon: Icons.history,
            iconColor: kIconColor,
            data: usageCount > 0 ? '$daysSinceLastUse' : '-',
            comment:
                lastUsedDate != null
                    ? 'days ago since ${lastUsedDate.toLocal().toString().split(' ')[0]}'
                    : 'data not enough',
          ),
          // 下次使用预计
          DetailsBriefCard(
            title: 'EST. Next Use',
            icon: Icons.update,
            iconColor: kIconColor,
            data: usageCount > 1 ? '${daysTillNextUse.abs()}' : '-',
            comment:
                nextExpectedUseDate != null
                    ? 'days ${daysTillNextUse >= 0 ? 'later' : 'ago'} at ${nextExpectedUseDate.toLocal().toString().split(' ')[0]}'
                    : 'data not enough',
          ),
        ],
      ),
    );
  }
}
