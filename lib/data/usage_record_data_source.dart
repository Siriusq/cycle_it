import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 用于 GetX 注入
import 'package:intl/intl.dart';

import '../controllers/item_controller.dart';
import '../models/usage_record_model.dart';
import '../services/item_service.dart';

typedef OnEditCallback = void Function(UsageRecordModel record);
typedef OnDeleteCallback = void Function(UsageRecordModel record);

class UsageRecordDataSource extends DataTableSource {
  final ItemService _itemService =
      Get.find<ItemService>(); // 获取 ItemService 实例
  final int itemId;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;

  List<UsageRecordModel> _usageRecords = []; // 当前加载的数据
  int _totalRecords = 0; // 总记录数
  bool _isAscending = true; // 排序方向
  String _sortColumn = 'usedAt'; // 当前排序的列
  //todo:
  TextStyle textStyleMD = TextStyle();

  UsageRecordDataSource({
    required this.itemId,
    required this.onEdit,
    required this.onDelete,
  });

  // 加载数据的方法，包含分页和排序逻辑
  Future<void> loadData(int page, int pageSize) async {
    // page 是基于0的索引
    final offset = page * pageSize;

    // 从数据库按需加载数据
    // 假设你的 ItemService 有一个方法可以按分页和排序获取记录
    final result = await _itemService.getPaginatedUsageRecords(
      itemId: itemId,
      offset: offset,
      limit: pageSize,
      sortBy: _sortColumn,
      sortAscending: _isAscending,
    );

    _usageRecords = result.records;
    _totalRecords = result.totalCount;
    notifyListeners(); // 通知表格数据已更新
  }

  // 刷新所有数据 (通常在添加/编辑/删除后调用)
  Future<void> refreshData() async {
    // 重新加载当前页的数据，或者从头开始加载第一页，取决于你的需求
    // 这里我们简单地重新加载第一页，你也可以保存当前页码并重新加载
    await loadData(
      0,
      Get.find<ItemController>().rowsPerPage.value,
    ); // 假设你控制器里有 rowsPerPage
    notifyListeners(); // 通知表格数据已更新
  }

  // -------- DataTableSource 接口实现 --------

  @override
  DataRow2? getRow(int index) {
    if (index >= _usageRecords.length) {
      return null;
    }

    final record = _usageRecords[index];
    // 计算序号
    // 注意：这里的序号是基于当前页面和排序的，如果需要全局序号，需要重新考虑
    // 对于分页加载，序号最好在后端计算或者在加载到内存后根据全局索引来算
    // 考虑到你要求“与使用记录的ID无关，按照使用日期从老到新计数”，
    // 那么这个序号需要在完整的、排序后的数据集中计算。
    // 由于我们是分页加载，这里展示的序号是当前页面内的相对序号。
    // 如果你要求的是全局序号，且是“从老到新计数”，那么你需要确保后端查询返回的记录
    // 包含其全局索引，或者在前端结合 offset 进行计算。
    // 这里我们先使用简单的当前页序号 + offset。
    final int displayIndex =
        (index +
            Get.find<ItemController>().currentRowsStartOffset.value +
            1); // 假设控制器里有当前页的起始偏移量

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
            record.intervalSinceLastUse?.toString() ??
                'N/A', // 第一次使用没有间隔
            style: textStyleMD,
          ),
        ),
        DataCell(
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
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
                    child: Text('编辑'),
                  ),
                  PopupMenuItem<String>(
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
  bool get isRowCountApproximate => false; // 我们知道总行数
  @override
  int get rowCount => _totalRecords; // 总行数
  @override
  int get selectedRowCount => 0; // 不支持行选择

  // 排序逻辑
  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _isAscending = ascending;
    // 重新加载数据以应用新的排序
    loadData(
      0,
      Get.find<ItemController>().rowsPerPage.value,
    ); // 重新加载第一页
  }
}

// 定义一个数据传输对象 (DTO) 来返回分页查询结果
class PaginatedUsageRecordsResult {
  final List<UsageRecordModel> records;
  final int totalCount;

  PaginatedUsageRecordsResult({
    required this.records,
    required this.totalCount,
  });
}
