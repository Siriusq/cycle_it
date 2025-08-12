import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/usage_record_model.dart';
import 'package:cycle_it/views/shared_widgets/date_picker_helper.dart';
import 'package:cycle_it/views/shared_widgets/delete_confirm_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UsageRecordDataSource extends DataTableSource {
  final int itemId;
  final itemController = Get.find<ItemController>();

  List<UsageRecordModel> _usageRecords = [];
  String _sortColumn; // 默认排序字段
  bool _sortAscending; // 默认升序

  UsageRecordDataSource({
    required this.itemId,
    List<UsageRecordModel>? initialRecords,
    // 【新增】接收初始排序状态
    required String initialSortColumn,
    required bool initialSortAscending,
  }) : _sortColumn = initialSortColumn,
       _sortAscending = initialSortAscending {
    if (initialRecords != null) {
      _usageRecords = initialRecords;
      _applySort(); // 如果传入了初始数据，进行默认排序
    }
  }

  // 直接接收完整的记录列表
  void updateRecords(List<UsageRecordModel> newRecords) {
    _usageRecords = newRecords;
    _applySort(); // 确保新数据也按照当前排序规则排序
    notifyListeners(); // 通知表格数据已更新
  }

  // 辅助排序方法
  void _applySort() {
    _usageRecords.sort((a, b) {
      Comparable aValue;
      Comparable bValue;

      switch (_sortColumn) {
        case 'usedAt':
          aValue = a.usedAt;
          bValue = b.usedAt;
          break;
        case 'intervalSinceLastUse':
          // 处理 null 值，将 null 视为最大或最小，取决于排序方向
          if (a.intervalSinceLastUse == null &&
              b.intervalSinceLastUse == null) {
            return 0;
          } else if (a.intervalSinceLastUse == null) {
            return _sortAscending ? 1 : -1; // null 排在后面
          } else if (b.intervalSinceLastUse == null) {
            return _sortAscending ? -1 : 1; // null 排在后面
          }
          aValue = a.intervalSinceLastUse!;
          bValue = b.intervalSinceLastUse!;
          break;
        default:
          aValue = a.usedAt; // 默认按日期排序
          bValue = b.usedAt;
          break;
      }

      final int comparison = Comparable.compare(aValue, bValue);
      return _sortAscending ? comparison : -comparison;
    });
  }

  // -------- DataTableSource 接口实现 --------
  @override
  DataRow2? getRow(int index) {
    if (index >= _usageRecords.length) {
      return null;
    }

    final record = _usageRecords[index];
    // 序号基于内存中已排序列表的索引
    final int displayIndex = index + 1;

    return DataRow2(
      cells: [
        DataCell(Center(child: Text(displayIndex.toString()))),
        DataCell(
          Center(
            child: Text(
              DateFormat('yyyy-MM-dd').format(record.usedAt),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              record.intervalSinceLastUse?.toString() ?? 'N/A',
            ),
          ),
        ),
        DataCell(
          Center(
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: '❕',
              onSelected: (String value) async {
                if (value == 'edit') {
                  final DateTime? pickedDate =
                      await promptForDateSelection(record.usedAt);
                  if (pickedDate != null) {
                    itemController.editUsageRecord(
                      record,
                      pickedDate,
                    );
                  }
                } else if (value == 'delete') {
                  final bool? confirmed =
                      await showDeleteConfirmDialog(
                        deleteTargetName: DateFormat(
                          'yyyy-MM-dd',
                        ).format(record.usedAt),
                      );
                  final String confirmMessage =
                      'usage_record_deleted_hint'.trParams({
                        'record': DateFormat(
                          'yyyy-MM-dd',
                        ).format(record.usedAt),
                      });
                  if (confirmed == true) {
                    itemController.deleteUsageRecord(
                      record,
                    ); // 调用删除方法
                    Get.snackbar(
                      'deleted_successfully'.tr,
                      confirmMessage,
                      duration: const Duration(seconds: 1),
                    );
                  }
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.edit),
                          Text(
                            'edit'.tr,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          Text(
                            'delete'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _usageRecords.length;

  @override
  int get selectedRowCount => 0;

  // 排序逻辑
  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    _applySort();
    notifyListeners(); // 通知 UI 刷新
  }
}
