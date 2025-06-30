import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/item_controller.dart'; // 引入控制器
import '../models/usage_record_model.dart';
import '../services/item_service.dart';

typedef OnEditCallback = void Function(UsageRecordModel record);
typedef OnDeleteCallback = void Function(UsageRecordModel record);

// 定义一个数据传输对象 (DTO) 来返回分页查询结果
class PaginatedUsageRecordsResult {
  final List<UsageRecordModel> records;
  final int totalCount;

  PaginatedUsageRecordsResult({
    required this.records,
    required this.totalCount,
  });
}

class UsageRecordDataSource extends DataTableSource {
  final ItemService _itemService = Get.find<ItemService>();
  final int itemId;
  final OnEditCallback onEdit;
  final OnDeleteCallback onDelete;
  final TextStyle textStyleMD; // 从外部传入TextStyle

  List<UsageRecordModel> _usageRecords = [];
  int _totalRecords = 0;
  String _sortColumn = 'usedAt'; // 默认排序字段
  bool _sortAscending = true; // 默认升序
  int _currentPage = 0; // 当前页码 (从0开始)
  int _rowsPerPage = 10; // 每页行数

  UsageRecordDataSource({
    required this.itemId,
    required this.onEdit,
    required this.onDelete,
    required this.textStyleMD, // 接收TextStyle
  }) {
    // 初始化时加载数据，确保表格有数据展示
    // 注意：这里的 itemId 是初始值，如果 ItemController 后面更新了 currentItem，需要手动调用 updateItemIdAndReload
    // 首次加载不需要在这里调用 loadData，因为 ItemController 会在 currentItem 变化时统一调用
  }

  // 更新 itemId 并重新加载数据
  Future<void> updateItemIdAndReload(int newId) async {
    if (itemId != newId) {
      // 这里的 itemId 是 final，不能直接修改，所以考虑 dataSource 的生命周期或重新创建。
      // 更合理的做法是，如果 ItemId 变化，应该在 ItemController 中判断并创建新的 UsageRecordDataSource 实例。
      // 但是为了兼容当前结构，我们假设这是一个新的 dataSource，并且只在第一次 set ItemId 时使用。
      // 如果你希望在同一个 dataSource 实例中切换 itemId，则 itemId 应该是非 final 字段。
      // 考虑到 `PaginatedDataTable2` 的 `source` 是一个可变参数，我们可以在 `ItemController` 中在 `currentItem` 变化时，
      // 重新赋值 `usageRecordDataSource = UsageRecordDataSource(...)`。
      // 为简化，这里暂时不修改 itemId 的 final 属性，而是依赖 ItemController 重新赋值 dataSource。
      // 实际上这个方法可能不会被外部直接调用，而是 `ItemController` 创建新的实例时传入。
    }

    // 重新加载数据，回到第一页
    await loadData(0, _rowsPerPage);
  }

  // 加载数据的方法，包含分页和排序逻辑
  Future<void> loadData(int page, int pageSize) async {
    _currentPage = page;
    _rowsPerPage = pageSize;
    final offset = page * pageSize;

    // 从数据库按需加载数据
    final result = await _itemService.getPaginatedUsageRecords(
      itemId: itemId,
      offset: offset,
      limit: pageSize,
      sortBy: _sortColumn,
      sortAscending: _sortAscending,
    );

    _usageRecords = result.records;
    _totalRecords = result.totalCount;
    notifyListeners(); // 通知表格数据已更新
  }

  // 刷新当前页数据 (通常在添加/编辑/删除后调用)
  Future<void> refreshData() async {
    await loadData(_currentPage, _rowsPerPage);
    notifyListeners();
  }

  // -------- DataTableSource 接口实现 --------
  @override
  DataRow2? getRow(int index) {
    if (index >= _usageRecords.length) {
      return null;
    }

    final record = _usageRecords[index];
    // 计算全局序号，需要 ItemController 提供当前页的起始偏移量
    final ItemController itemController = Get.find<ItemController>();
    final int displayIndex =
        itemController.currentRowsStartOffset.value + index + 1;

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
  int get rowCount => _totalRecords;

  @override
  int get selectedRowCount => 0;

  // 排序逻辑
  void sort(String columnName, bool ascending) {
    // 将前端的逻辑排序字段映射到数据库实际字段
    String actualSortColumn;

    if (columnName == 'index') {
      // 序号排序通常基于 usedAt，因为你希望“按照使用日期从老到新计数”
      actualSortColumn = 'usedAt';
    } else {
      actualSortColumn = columnName;
    }

    _sortColumn = actualSortColumn;
    _sortAscending = ascending;

    // 重新加载数据以应用新的排序，回到第一页
    loadData(0, _rowsPerPage);
  }
}
