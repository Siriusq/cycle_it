import 'package:cycle_it/utils/responsive_style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/item_model.dart';

class UsageRecordsTable extends StatelessWidget {
  final ItemModel currentItem;

  const UsageRecordsTable({super.key, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyText = style.bodyText;
    final TextStyle titleTextMD = style.titleTextMD; // 获取小标题样式

    return Obx(() {
      if (itemController.currentItem.value == null ||
          itemController.currentItem.value!.id != currentItem.id) {
        return const Center(child: CircularProgressIndicator());
      }

      // todo：改成添加按钮或者改成无记录
      if (itemController.usageRecordDataSource.value == null) {
        return Center(child: Text('加载使用记录...', style: bodyText));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          double columnSpacing =
              constraints.maxWidth > 900 ? 100 : 40;

          return SizedBox(
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // 使用卡片背景色
                borderRadius: BorderRadius.circular(12.0), // 圆角边框
                boxShadow: [
                  // 阴影效果
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    // 【修改点26】顶部栏
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '使用记录',
                          style: titleTextMD, // 使用小标题样式
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 24,
                          ), // 添加按钮
                          onPressed: () {
                            // TODO: Implement add record functionality
                            // 可以打开一个添加使用记录的对话框
                            itemController.addUsageRecord(
                              DateTime.now(),
                            ); // 示例：快速添加一条当前日期的记录
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0, thickness: 1),
                  Expanded(
                    child: PaginatedDataTable2(
                      source:
                          itemController.usageRecordDataSource.value!,
                      columns: [
                        DataColumn2(
                          label: Text('序号', style: bodyText),
                          onSort: (columnIndex, ascending) {
                            itemController
                                .usageRecordDataSource
                                .value!
                                .sort('index', ascending);
                          },
                          //fixedWidth: 80,
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('使用日期', style: bodyText),
                          onSort: (columnIndex, ascending) {
                            itemController
                                .usageRecordDataSource
                                .value!
                                .sort('usedAt', ascending);
                          },
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('与上次间隔(天)', style: bodyText),
                          onSort: (columnIndex, ascending) {
                            itemController
                                .usageRecordDataSource
                                .value!
                                .sort(
                                  'intervalSinceLastUse',
                                  ascending,
                                );
                          },
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('操作', style: bodyText),
                          //fixedWidth: 100,
                          size: ColumnSize.S,
                        ),
                      ],
                      // rowsPerPage: itemController.usageRecordDataSource.value!.rowCount == 0
                      //     ? 1 // 避免 rowCount 为 0 时崩溃，至少显示一行空内容
                      //     : itemController.usageRecordDataSource.value!.rowCount,
                      // 启用 AutoRows 功能
                      autoRowsToHeight: true,

                      wrapInCard: false,
                      // 外部已经有 Card/Container 样式，无需再包裹
                      showCheckboxColumn: false,
                      empty: Center(
                        child: Text('暂无使用记录', style: bodyText),
                      ),
                      horizontalMargin: 12,
                      columnSpacing: columnSpacing,
                      headingRowColor: WidgetStateProperty.all(
                        Colors.blue.shade50,
                      ),
                      dividerThickness: 2,
                      border: TableBorder.all(
                        color: Colors.blueGrey.shade200,
                        width: 1,
                      ),
                      scrollController: ScrollController(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
