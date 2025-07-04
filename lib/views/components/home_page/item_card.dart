import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/icon_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../dialog/date_picker_helper.dart';
import '../dialog/delete_confirm_dialog.dart';
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

    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;

    final bool isTripleCol = ResponsiveLayout.isTripleCol(context);
    final bool isSingleCol = ResponsiveLayout.isSingleCol(context);

    return Padding(
      padding: EdgeInsets.only(
        left: spacingLG,
        right: spacingLG,
        top: spacingLG,
      ),
      child: InkWell(
        onTap: () {
          itemCtrl.selectItem(item);
          if (isSingleCol) Get.toNamed("/Details");
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
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
              _buildTitle(context, style, isTripleCol, itemCtrl),

              // 详细使用数据，仅在桌面宽屏显示
              _buildOverview(context, style, isTripleCol),

              // 进度条区域
              _buildDateProgressBar(
                item.timePercentageBetweenLastAndNext(),
                context,
                style,
                isSingleCol,
              ),

              //标签
              _buildTags(context, style),
            ],
          ),
        ),
      ),
    );
  }

  // 图标、名称、更多按钮
  Widget _buildTitle(
    BuildContext context,
    ResponsiveStyle style,
    bool isTripleCol,
    ItemController itemController,
  ) {
    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingSM = style.spacingSM;

    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: isTripleCol ? 5 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 顶部对齐
        children: [
          // 图标部分
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: 40,
              // Fixed width for the container
              height: 40,
              // Fixed height for the container
              decoration: BoxDecoration(
                //border: Border.all(color: kGrayColor),
                borderRadius: BorderRadius.circular(8.0),
                color: item.iconColor, // Emoji background color
              ),
              // Using Center and Padding to ensure emoji fills the space
              // and has padding around it. FittedBox is not ideal for Text scaling,
              // better to control fontSize with a wrapper.
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

          SizedBox(width: spacingSM),

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
                  Flexible(
                    // Use Flexible here too
                    child: Text(
                      item.usageComment!,
                      style: smallBodyTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 更多按钮
          _buildActionButton(context, style, itemController, item),
        ],
      ),
    );
  }

  // 卡片下拉菜单，包括编辑和删除物品
  Widget _buildActionButton(
    BuildContext context,
    ResponsiveStyle style,
    ItemController itemController,
    ItemModel item,
  ) {
    final spacingSM = style.spacingSM;
    final bodyTextStyle = style.bodyText;

    return PopupMenuButton<String>(
      color: kSecondaryBgColor,
      tooltip: 'More Action',
      onSelected: (value) async {
        if (value == 'cycle') {
          final DateTime? pickedDate = await promptForUsageDate(
            DateTime.now(),
          );
          if (pickedDate != null) {
            Get.back();
            itemController.addUsageRecord(pickedDate);
            Get.snackbar(
              '添加成功',
              '添加使用记录 ${DateFormat('yyyy-MM-dd').format(pickedDate)} 到物品 ${item.name}',
            );
          }
        } else if (value == 'edit') {
          final result = await Get.toNamed(
            '/AddEditItem',
            arguments: item,
          );
          if (result != null && result['success']) {
            Get.snackbar('成功', '${result['message']}');
          }
        } else if (value == 'delete') {
          final bool? confirmed = await showDeleteConfirmDialog(
            deleteTargetName: item.name,
          );
          final String confirmMessage = '物品 ${item.name} 已删除！';
          if (confirmed == true) {
            itemController.deleteItem(item.id!); // 调用删除方法
            Get.snackbar('删除成功', confirmMessage);
          }
        }
      },
      itemBuilder:
          (_) => [
            PopupMenuItem(
              value: 'cycle',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: itemIconColor),
                  SizedBox(width: spacingSM),
                  Text(
                    'cycle'.tr,
                    style: bodyTextStyle.copyWith(
                      color: itemIconColor,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: kTextColor),
                  SizedBox(width: spacingSM),
                  Text('edit'.tr, style: bodyTextStyle),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: spacingSM),
                  Text(
                    'delete'.tr,
                    style: bodyTextStyle.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
    );
  }

  // 详细使用数据，仅在桌面宽屏显示
  Widget _buildOverview(
    BuildContext context,
    ResponsiveStyle style,
    bool isTripleCol,
  ) {
    final int usageCount = item.usageRecords.length;
    final DateTime? nextExpectedUseDate = item.nextExpectedUse;
    final DateTime? lastUsedDate =
        usageCount > 0 ? item.usageRecords.last.usedAt : null;
    final double usageFrequency = item.usageFrequency.toPrecision(2);

    final TextStyle smallBodyTextStyle = style.bodyTextSM;
    final double spacingXS = style.spacingXS;
    final double spacingSM = style.spacingSM;
    final double iconSizeSM = style.iconSizeSM;

    if (!isTripleCol) {
      return Padding(
        padding: EdgeInsets.only(
          left: 5,
          bottom: spacingSM,
          top: spacingSM,
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
                      ? DateFormat('yyyy-MM-dd').format(lastUsedDate)
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
                      ? DateFormat(
                        'yyyy-MM-dd',
                      ).format(nextExpectedUseDate)
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
    ResponsiveStyle style,
    bool isSingleCol,
  ) {
    final TextStyle smallBodyTextStyle = style.bodyTextSM;

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
                      color:
                          isActive && !isSingleCol
                              ? kProgressBarColor
                              : kSecondaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color:
                          isActive && !isSingleCol
                              ? kSelectedBorderColor
                              : kProgressBarColor,
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
  Widget _buildTags(BuildContext context, ResponsiveStyle style) {
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
                  //clipBehavior: Clip.antiAlias,
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
                    isLarge: false,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
