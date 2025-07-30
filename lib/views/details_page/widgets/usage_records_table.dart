import 'package:cycle_it/utils/responsive_style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/item_model.dart';
import '../../shared_widgets/date_picker_helper.dart';

class UsageRecordsTable extends StatelessWidget {
  const UsageRecordsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final TextStyle bodyTextStyleLG = style.bodyTextLG;
    final TextStyle titleTextMD = style.titleTextMD;
    final double tableHeight = style.tableHeight;

    return Obx(() {
      final ItemModel? currentItem = itemCtrl.currentItem.value;
      if (currentItem == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final dataSource = itemCtrl.usageRecordDataSource.value;
      if (dataSource == null) {
        return Center(
          child: Text(
            'loading_usage_record...'.tr,
            style: bodyTextStyleLG,
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: tableHeight, //实际上没啥用，组件被包在有限制的组件中了，这里只是个保证
            child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1.5,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
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
                        Expanded(
                          child: Text(
                            'usage_record'.tr,
                            style: titleTextMD,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                              itemCtrl.addUsageRecord(pickedDate);
                              Get.snackbar(
                                'success'.tr,
                                'usage_record_added_hint'.trParams({
                                  'record': DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(pickedDate),
                                  'item': currentItem.name,
                                }),
                                duration: const Duration(seconds: 1),
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
                            label: Text(
                              'index'.tr,
                              style: bodyTextStyleLG,
                            ),
                            size: ColumnSize.S,
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text(
                              'used_at'.tr,
                              style: bodyTextStyleLG,
                            ),
                            onSort: (columnIndex, ascending) {
                              itemCtrl.onUsageRecordsSort('usedAt');
                            },
                            size: ColumnSize.L,
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text(
                              'interval_since_last_use'.tr,
                              style: bodyTextStyleLG,
                            ),
                            onSort: (columnIndex, ascending) {
                              itemCtrl.onUsageRecordsSort(
                                'intervalSinceLastUse',
                              );
                            },
                            size: ColumnSize.L,
                            headingRowAlignment:
                                MainAxisAlignment.center,
                          ),
                          DataColumn2(
                            label: Text(
                              'actions'.tr,
                              style: bodyTextStyleLG,
                            ),
                            headingRowAlignment:
                                MainAxisAlignment.center,
                            size: ColumnSize.S,
                          ),
                        ],
                        autoRowsToHeight: true,
                        wrapInCard: false,
                        showCheckboxColumn: false,
                        empty: Center(
                          child: Text(
                            'no_usage_records'.tr,
                            style: bodyTextStyleLG,
                          ),
                        ),
                        horizontalMargin: 0,
                        columnSpacing: 0,
                        headingRowColor: WidgetStateProperty.all(
                          Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                        ),
                        //dividerThickness: 1,
                        border: TableBorder(
                          top: BorderSide(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                          ),
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                          verticalInside: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                          horizontalInside: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        scrollController: ScrollController(),
                        sortArrowIcon: Icons.north,
                        sortColumnIndex: _getSortColumnIndex(
                          itemCtrl.usageRecordsSortColumn.value,
                        ),
                        sortAscending:
                            itemCtrl.usageRecordsSortAscending.value,
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
