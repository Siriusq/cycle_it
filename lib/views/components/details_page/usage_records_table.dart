import 'dart:math';

import 'package:cycle_it/utils/responsive_style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/item_model.dart';
import '../../../utils/constants.dart';

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

      final dataSource = itemController.usageRecordDataSource.value;
      if (dataSource == null) {
        return Center(child: Text('加载使用记录...', style: bodyText));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          double columnSpacing = style.tableColWidth;
          double tableHeight = max(Get.height * 0.8, 400);

          return SizedBox(
            height: tableHeight,
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryBgColor,
                border: Border.all(width: 1.5, color: kBorderColor),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Padding(
                    // 顶部栏
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('使用记录', style: titleTextMD),
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
                  //const Divider(height: 0, thickness: 1),
                  Expanded(
                    child: Obx(() {
                      return PaginatedDataTable2(
                        source: dataSource,
                        columns: [
                          DataColumn2(
                            label: Text('序号', style: bodyText),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('使用日期', style: bodyText),
                            onSort: (columnIndex, ascending) {
                              itemController.onUsageRecordsSort(
                                'usedAt',
                              );
                            },
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text('与上次间隔(天)', style: bodyText),
                            onSort: (columnIndex, ascending) {
                              itemController.onUsageRecordsSort(
                                'intervalSinceLastUse',
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
                        autoRowsToHeight: true,
                        wrapInCard: false,
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
                        sortColumnIndex: _getSortColumnIndex(
                          itemController.usageRecordsSortColumn.value,
                        ),
                        sortAscending:
                            itemController
                                .usageRecordsSortAscending
                                .value,
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // 将列名映射到索引
  int? _getSortColumnIndex(String columnName) {
    switch (columnName) {
      case 'usedAt':
        return 1;
      case 'intervalSinceLastUse':
        return 2;
      default:
        return null;
    }
  }
}
