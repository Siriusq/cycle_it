import 'package:cycle_it/utils/responsive_style.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/usage_record_model.dart';
import '../utils/constants.dart';

// todo: 简化这里，直接在按钮处调用dialog，根源在控制器那里
typedef OnEditCallback = void Function(UsageRecordModel record);
typedef OnDeleteCallback = void Function(UsageRecordModel record);

class UsageRecordDataSource extends DataTableSource {
  final int itemId;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;

  List<UsageRecordModel> _usageRecords = [];
  String _sortColumn; // 默认排序字段
  bool _sortAscending; // 默认升序

  UsageRecordDataSource({
    required this.itemId,
    required this.onEdit,
    required this.onDelete,
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
    final style = ResponsiveStyle.to;
    final bodyTextStyleLG = style.bodyTextLG;
    final bodyTextStyle = style.bodyText;
    final spacingSM = style.spacingSM;

    return DataRow2(
      cells: [
        DataCell(
          Center(
            child: Text(
              displayIndex.toString(),
              style: bodyTextStyleLG,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              DateFormat('yyyy-MM-dd').format(record.usedAt),
              style: bodyTextStyleLG,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              record.intervalSinceLastUse?.toString() ?? 'N/A',
              style: bodyTextStyleLG,
            ),
          ),
        ),
        DataCell(
          Center(
            child: PopupMenuButton<String>(
              color: kSecondaryBgColor,
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'edit') {
                  onEdit(record);
                } else if (value == 'delete') {
                  onDelete(record);
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: kTextColor),
                          SizedBox(width: spacingSM),
                          Text('edit'.tr, style: bodyTextStyle),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: spacingSM),
                          Text(
                            'delete'.tr,
                            style: bodyTextStyle.copyWith(
                              color: Colors.red,
                            ),
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
    _applySort(); // 【修改点11】应用排序
    notifyListeners(); // 通知 UI 刷新
  }
}
