import 'package:cycle_it/utils/responsive_style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/item_model.dart';
import '../../../utils/constants.dart';
import '../../shared_widgets/date_picker_helper.dart';

class UsageRecordsTable extends StatelessWidget {
  final ItemModel currentItem;

  const UsageRecordsTable({super.key, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyText = style.bodyText;
    final TextStyle titleTextMD = style.titleTextMD;
    //final double tableHeight = style.tableHeight;

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
          return SizedBox(
            //height: tableHeight, //实际上没啥用，组件被包在有限制的组件中了，这里只是个保证
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
                          onPressed: () async {
                            final DateTime? pickedDate =
                                await promptForUsageDate(
                                  DateTime.now(),
                                );
                            if (pickedDate != null) {
                              Get.back();
                              itemController.addUsageRecord(
                                pickedDate,
                              );
                            }
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
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text('使用日期', style: bodyText),
                            onSort: (columnIndex, ascending) {
                              itemController.onUsageRecordsSort(
                                'usedAt',
                              );
                            },
                            size: ColumnSize.L,
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text('间隔天数', style: bodyText),
                            onSort: (columnIndex, ascending) {
                              itemController.onUsageRecordsSort(
                                'intervalSinceLastUse',
                              );
                            },
                            size: ColumnSize.L,
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text('操作', style: bodyText),
                            headingRowAlignment:
                                MainAxisAlignment.center,
                            size: ColumnSize.S,
                          ),
                        ],
                        autoRowsToHeight: true,
                        wrapInCard: false,
                        showCheckboxColumn: false,
                        empty: Center(
                          child: Text('暂无使用记录', style: bodyText),
                        ),
                        horizontalMargin: 0,
                        columnSpacing: 0,
                        headingRowColor: WidgetStateProperty.all(
                          kSecondaryBgColor,
                        ),
                        //dividerThickness: 1,
                        border: TableBorder(
                          top: const BorderSide(color: kBorderColor),
                          bottom: const BorderSide(
                            color: kBorderColor,
                          ),
                          //left: BorderSide(color: Colors.grey[300]!),
                          //right: BorderSide(color: Colors.grey[300]!),
                          verticalInside: const BorderSide(
                            color: kBorderColor,
                          ),
                          horizontalInside: const BorderSide(
                            color: kBorderColor,
                          ),
                        ),
                        scrollController: ScrollController(),
                        sortArrowIcon: Icons.north,
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
