import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/details_page/details_brief_card.dart';
import 'package:cycle_it/views/components/details_page/usage_records_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_layout.dart';
import '../dialog/delete_confirm_dialog.dart';
import '../icon_label.dart';
import '../responsive_component_group.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ResponsiveLayout.isSingleCol(context) &&
          Get.currentRoute == '/Details') {
        Get.back();
      }
    });

    return PopScope(
      canPop: true,
      // onPopInvokedWithResult: (bool didPop, Object? result) async {
      //   if (didPop) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       //itemCtrl.clearSelection(); // 等待动画完成后再清除选中项
      //       print('Cleared');
      //     });
      //   }
      // },
      child: Obx(() {
        final ItemModel? item = itemCtrl.currentItem.value;
        if (item == null) {
          return Container(color: kPrimaryBgColor);
        }

        return Scaffold(
          body: SafeArea(
            child: Container(
              color: kPrimaryBgColor,
              child: Column(
                children: [
                  // 顶栏
                  _buildHeader(context, style, isMobile, item),

                  // 分割线
                  Divider(height: 0),

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

                          UsageRecordsTable(currentItem: item),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ResponsiveStyle style,
    bool isMobile,
    ItemModel item,
  ) {
    final itemCtrl = Get.find<ItemController>();

    final double spacingLG = style.spacingLG;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;
    final double verticalSpacing = isMobile ? 0 : spacingLG;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalSpacing,
        vertical: verticalSpacing,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            if (itemCtrl.currentItem.value != null)
              BackButton(
                onPressed: () {
                  if (Get.currentRoute == '/Details') {
                    Get.back();
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                        itemCtrl
                            .clearSelection(); // 动画结束后再清空，防止出现页面提前销毁导致的黑屏闪烁
                      },
                    );
                  } else {
                    itemCtrl.clearSelection();
                  }
                },
              ),

            Spacer(),
            // 删除当前物品
            IconButton(
              onPressed: () async {
                final bool? confirmed = await showDeleteConfirmDialog(
                  context: context,
                  deleteTargetName: item.name,
                );
                final String confirmMessage = '物品 ${item.name} 已删除！';

                if (confirmed == true) {
                  if (Get.currentRoute == '/Details') {
                    Get.back();
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () {
                        itemCtrl.deleteItem(
                          item.id!,
                        ); // 动画结束后再删除，防止出现页面提前销毁导致的黑屏闪烁
                      },
                    );
                  } else {
                    itemCtrl.deleteItem(item.id!); // 调用删除方法
                  }
                  Get.snackbar('删除成功', confirmMessage);
                }
              },
              icon: Icon(Icons.delete_outline),
            ),
            // 编辑当前物品
            IconButton(
              onPressed: () async {
                final result = await Get.toNamed(
                  '/AddEditItem',
                  arguments: item,
                );

                if (result != null && result['success']) {
                  Get.snackbar('成功', '${result['message']}');
                }
              },
              icon: Icon(Icons.edit_outlined),
            ),
            // 快速添加使用记录，以当前日期为准
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
    final double spacingLG = style.spacingLG;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacingLG * 0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: item.iconColor,
              ),
              width: 50,
              height: 50,
              child: Center(
                // Centers the Text widget
                child: Padding(
                  padding: const EdgeInsets.all(
                    4.0,
                  ), // Padding around the emoji
                  child: FittedBox(
                    // Scales the Text to fit within the padding
                    fit: BoxFit.contain,
                    // Ensures the emoji is fully visible
                    child: Text(
                      item.emoji,
                      // FontSize can be large as FittedBox will scale it down
                      style: const TextStyle(
                        fontSize: 100,
                      ), // Start with a large size
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: spacingLG),

          // 文字内容区域
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  Flexible(
                    child: Text(
                      item.usageComment!,
                      style: bodyText,
                      softWrap: true,
                    ),
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
          runSpacing: 5,
          children:
              item.tags.map((tag) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: IconLabel(
                    icon: Icons.bookmark,
                    label: tag.name,
                    iconColor: tag.color,
                    isLarge: true,
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
    final int daysSinceLastUse = item.daysToToday(false).abs();
    final int daysTillNextUse = item.daysToToday(true);
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
