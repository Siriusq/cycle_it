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

    return Obx(() {
      if (itemController.currentItem.value == null ||
          itemController.currentItem.value!.id != currentItem.id) {
        return const Center(child: CircularProgressIndicator());
      }

      if (itemController.usageRecordDataSource.value == null) {
        return Center(child: Text('加载使用记录...', style: bodyText));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          double columnSpacing =
              constraints.maxWidth > 900 ? 100 : 40;

          // --- KEY CHANGE: Removed Expanded here ---
          return SizedBox(
            height: style.isMobileDevice ? 300 : 400,
            child: PaginatedDataTable2(
              source: itemController.usageRecordDataSource.value!,
              columns: [
                DataColumn2(
                  label: Text('序号', style: bodyText),
                  onSort: (columnIndex, ascending) {
                    itemController.usageRecordDataSource.value!.sort(
                      'index',
                      ascending,
                    );
                  },
                  fixedWidth: 80,
                ),
                DataColumn2(
                  label: Text('使用日期', style: bodyText),
                  onSort: (columnIndex, ascending) {
                    itemController.usageRecordDataSource.value!.sort(
                      'usedAt',
                      ascending,
                    );
                  },
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('与上次间隔(天)', style: bodyText),
                  onSort: (columnIndex, ascending) {
                    itemController.usageRecordDataSource.value!.sort(
                      'intervalSinceLastUse',
                      ascending,
                    );
                  },
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('操作', style: bodyText),
                  fixedWidth: 100,
                ),
              ],
              rowsPerPage: itemController.rowsPerPage.value,
              onRowsPerPageChanged:
                  itemController.onRowsPerPageChanged,
              availableRowsPerPage: const [5, 10, 20, 50],
              onPageChanged: itemController.onPageChanged,
              wrapInCard: false,
              showCheckboxColumn: false,
              empty: Center(child: Text('暂无使用记录', style: bodyText)),
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
              // No fit: FlexFit.tight here, as it's not directly in a Flex
              // If PaginatedDataTable2 still needs a size, you might wrap it in a SizedBox
              // but usually, when it's in SingleChildScrollView, its height is determined by its content (rows)
              // If the table doesn't scroll itself, you might need to give it a fixed height
              // or put it inside an Expanded if its parent is a Column/Row and it needs to fill remaining space
            ),
          );
        },
      );
    });
  }
}
