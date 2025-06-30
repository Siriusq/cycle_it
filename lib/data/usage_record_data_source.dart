import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/usage_record_model.dart';

typedef OnEditCallback = void Function(UsageRecordModel record);
typedef OnDeleteCallback = void Function(UsageRecordModel record);

class UsageRecordDataSource extends DataTableSource {
  final int itemId;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;
  final TextStyle textStyleMD; // 从外部传入TextStyle

  List<UsageRecordModel> _usageRecords = [];
  String _sortColumn = 'usedAt'; // 默认排序字段
  bool _sortAscending = true; // 默认升序

  UsageRecordDataSource({
    required this.itemId,
    required this.onEdit,
    required this.onDelete,
    required this.textStyleMD,
    List<UsageRecordModel>? initialRecords, //接收初始数据
  }) {
    if (initialRecords != null) {
      _usageRecords = initialRecords;
      _applySort(); // 【修改点5】如果传入了初始数据，进行默认排序
    }
  }

  // 直接接收完整的记录列表
  void updateRecords(List<UsageRecordModel> newRecords) {
    _usageRecords = newRecords;
    _applySort(); // 确保新数据也按照当前排序规则排序
    notifyListeners(); // 通知表格数据已更新
  }

  // 【修改点7】辅助排序方法
  void _applySort() {
    _usageRecords.sort((a, b) {
      Comparable aValue;
      Comparable bValue;

      switch (_sortColumn) {
        case 'index': // 对于序号排序，实际是按 usedAt 排序
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
        DataCell(Text(displayIndex.toString(), style: textStyleMD)),
        DataCell(
          Text(
            DateFormat('yyyy-MM-dd').format(record.usedAt),
            style: textStyleMD,
          ),
        ),
        DataCell(
          Text(
            record.intervalSinceLastUse?.toString() ?? 'N/A',
            style: textStyleMD,
          ),
        ),
        DataCell(
          PopupMenuButton<String>(
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
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('编辑'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('删除'),
                  ),
                ],
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
