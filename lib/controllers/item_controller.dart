import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/usage_record_data_source.dart';
import '../models/item_model.dart';
import '../models/usage_record_model.dart';
import '../services/item_service.dart';
import 'item_list_order_controller.dart';

class ItemController extends GetxController {
  final ItemService _itemService = Get.find<ItemService>(); // 注入服务
  final ItemListOrderController _orderController =
      Get.find<ItemListOrderController>();
  final TagController _tagController = Get.find<TagController>();
  final SearchBarController _searchBarController =
      Get.find<SearchBarController>();

  // 加载状态
  RxBool isLoading = true.obs; // 初始为 true，表示正在加载

  // 主页列表数据
  final RxList<ItemModel> allItems = <ItemModel>[].obs; // 存储所有加载的物品
  final RxList<ItemModel> displayedItems =
      <ItemModel>[].obs; // 经过排序和筛选后显示在主页的物品

  // 物品详情页数据
  final Rx<ItemModel?> currentItem = Rx<ItemModel?>(
    null,
  ); // 用于详情页的当前物品

  // 表格状态管理
  // 使用 Rx<UsageRecordDataSource?> 来允许它在初始化之前为 null
  Rx<UsageRecordDataSource?> usageRecordDataSource =
      Rx<UsageRecordDataSource?>(null);

  // 分页状态
  final RxInt rowsPerPage = 10.obs; // 每页行数，用户可选择
  final RxInt currentPage = 0.obs; // 当前页码 (从0开始)
  final RxInt currentRowsStartOffset = 0.obs; // 当前页数据的起始偏移量 (用于计算序号)

  @override
  void onInit() {
    super.onInit();

    // Future.delayed(Duration(milliseconds: 100), () {
    //   // Add a small delay to ensure initial DB writes from main are complete
    //   _loadAllItems();
    // });
    //_loadAllItems(); // 应用启动时加载所有物品

    // 监听排序和筛选变化，更新 displayedItems
    ever(
      _orderController.selectedOrderOption,
      (_) => _updateDisplayedItems(),
    );
    ever(
      _orderController.isAscending,
      (_) => _updateDisplayedItems(),
    );
    ever(_tagController.selectedTags, (_) => _updateDisplayedItems());
    // 监听 allItems 变化
    ever(allItems, (_) => _updateDisplayedItems());
    // 监听搜索查询的变化
    ever(
      _searchBarController.searchQuery,
      (_) => _updateDisplayedItems(),
    );

    // 当标签被添加、编辑或删除时，重新加载所有物品以更新其关联的标签信息
    ever(_tagController.allTags, (_) async {
      await loadAllItems();

      // If there's an item currently selected in details, refresh its data
      if (currentItem.value != null &&
          currentItem.value!.id != null) {
        await loadItemForDetails(currentItem.value!.id!);
      }
    });

    // --- 关键修改：currentItem 变化时重新创建 UsageRecordDataSource ---
    ever(currentItem, (item) {
      if (item != null && item.id != null) {
        // 获取 context 用于 TextStyle，确保在 UI 线程上获取
        final TextStyle style =
            Get.context != null
                ? Theme.of(
                  Get.context!,
                ).textTheme.bodyMedium! // 假设你有一个默认的文本样式
                : const TextStyle(fontSize: 14); // 备用样式

        // 每次 currentItem 变化，都创建一个新的 UsageRecordDataSource 实例
        usageRecordDataSource.value = UsageRecordDataSource(
          itemId: item.id!,
          onEdit: (record) => _showEditDialog(record),
          onDelete: (record) => _confirmDelete(record),
          textStyleMD: style, // 传入 TextStyle
        );
        // 立即加载第一页数据
        usageRecordDataSource.value!.loadData(
          currentPage.value,
          rowsPerPage.value,
        );
        currentRowsStartOffset.value =
            currentPage.value * rowsPerPage.value;
      } else {
        usageRecordDataSource.value = null; // 如果没有选中物品，清空数据源
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // This method is called after the first frame is rendered.
    // The database should be fully populated by now from main.
    loadAllItems(); // Now fetch the items from the database.
  }

  // 从数据库加载所有物品
  Future<void> loadAllItems() async {
    isLoading.value = true; // 开始加载
    try {
      final loadedItems = await _itemService.getAllItems();
      allItems.assignAll(loadedItems);
    } catch (e) {
      print('获取物品失败: $e');
      // 处理错误，例如显示错误消息给用户
    } finally {
      isLoading.value = false; // 结束加载
    }
    // _updateDisplayedItems 会在 _allItems 变化时自动被 ever 触发
  }

  // 更新主页显示的物品列表 (排序和筛选)
  void _updateDisplayedItems() {
    List<ItemModel> itemsToFilter = List.from(allItems);

    // 1. 标签筛选
    itemsToFilter = _tagController.filterItems(itemsToFilter);

    // 2. 搜索筛选
    final String query =
        _searchBarController.searchQuery.value.toLowerCase();
    if (query.isNotEmpty) {
      itemsToFilter =
          itemsToFilter.where((item) {
            // 你可以根据物品的名称、描述或任何其他字段进行搜索
            return item.name.toLowerCase().contains(query) ||
                (item.usageComment != null &&
                    item.usageComment!.toLowerCase().contains(query));
          }).toList();
    }

    // 3. 排序
    itemsToFilter.sort((a, b) {
      int compareResult = 0;
      switch (_orderController.selectedOrderOption.value) {
        case OrderType.name:
          compareResult = a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          );
          break;
        case OrderType.lastUsed:
          // 如果没有使用记录，排在后面
          if (a.usageRecords.isEmpty && b.usageRecords.isEmpty) {
            compareResult = 0;
          } else if (a.usageRecords.isEmpty) {
            compareResult = 1;
          } else if (b.usageRecords.isEmpty) {
            compareResult = -1;
          } else {
            compareResult = a.usageRecords.last.usedAt.compareTo(
              b.usageRecords.last.usedAt,
            );
          }
          break;
        case OrderType.frequency:
          // 使用频率高的排前面
          compareResult = a.usageFrequency.compareTo(
            b.usageFrequency,
          );
          break;
      }
      return _orderController.isAscending.value
          ? compareResult
          : -compareResult;
    });
    displayedItems.assignAll(itemsToFilter);
  }

  // 添加新物品
  Future<void> addNewItem(ItemModel newItem) async {
    final newId = await _itemService.saveItem(newItem);
    // 重新加载所有物品以更新列表
    await loadAllItems();
  }

  // 编辑物品
  Future<void> updateItem(ItemModel updatedItem) async {
    await _itemService.saveItem(updatedItem);
    await loadAllItems(); // 重新加载所有物品
    // 如果当前详情页显示的就是这个物品，也需要更新 currentItem
    if (currentItem.value?.id == updatedItem.id) {
      currentItem.value = await _itemService.getItemWithUsageRecords(
        updatedItem.id!,
      );
      currentItem.value!.invalidateCalculatedProperties();
    }
  }

  // 删除物品 (示例)
  Future<void> deleteItem(int itemId) async {
    await _itemService.deleteItem(itemId);
    await loadAllItems(); // 重新加载所有物品
    if (currentItem.value?.id == itemId) {
      currentItem.value = null; // 如果删除的是当前详情页的物品，清空
    }
  }

  // --- 物品详情页使用记录表格相关方法 ---

  // 加载物品及其使用记录（用于详情页）
  Future<void> loadItemForDetails(int itemId) async {
    final item = await _itemService.getItemWithUsageRecords(itemId);
    if (item != null) {
      currentItem.value = item;
      currentItem.value!.invalidateCalculatedProperties(); // 清除缓存
      // usageRecordDataSource 会在 currentItem 变化时自动初始化和加载数据
    } else {
      currentItem.value = null;
    }
  }

  // 添加使用记录
  Future<void> addUsageRecord(DateTime usedAt) async {
    if (currentItem.value == null) return;

    await _itemService.addUsageRecordAndRecalculate(
      currentItem.value!.id!,
      usedAt,
    );

    // 刷新数据源以更新表格
    await usageRecordDataSource.value!.refreshData();
    // 重新加载 ItemModel，更新其内部的 usageRecords 列表和计算属性
    currentItem.value = await _itemService.getItemWithUsageRecords(
      currentItem.value!.id!,
    );
    currentItem.value!.invalidateCalculatedProperties();
    await loadAllItems(); // 更新主页列表的 ItemModel
  }

  // 编辑使用记录的日期
  Future<void> _editUsageRecord(
    UsageRecordModel record,
    DateTime newUsedAt,
  ) async {
    if (currentItem.value == null) return;

    await _itemService.editUsageRecordAndRecalculate(
      record.id,
      currentItem.value!.id!,
      newUsedAt,
    );

    // 刷新数据源以更新表格
    await usageRecordDataSource.value!.refreshData();
    currentItem.value = await _itemService.getItemWithUsageRecords(
      currentItem.value!.id!,
    );
    currentItem.value!.invalidateCalculatedProperties();
    await loadAllItems(); // 更新主页列表的 ItemModel
  }

  // 删除使用记录
  Future<void> _deleteUsageRecord(UsageRecordModel record) async {
    if (currentItem.value == null) return;

    await _itemService.deleteUsageRecordAndRecalculate(
      record.id,
      currentItem.value!.id!,
    );

    // 刷新数据源以更新表格
    await usageRecordDataSource.value!.refreshData();
    currentItem.value = await _itemService.getItemWithUsageRecords(
      currentItem.value!.id!,
    );
    currentItem.value!.invalidateCalculatedProperties();
    await loadAllItems(); // 更新主页列表的 ItemModel
  }

  // 翻页回调
  void onPageChanged(int pageIndex) {
    currentPage.value = pageIndex;
    currentRowsStartOffset.value = pageIndex * rowsPerPage.value;
    usageRecordDataSource.value?.loadData(
      pageIndex,
      rowsPerPage.value,
    );
  }

  // 每页行数改变回调
  void onRowsPerPageChanged(int? value) {
    if (value != null) {
      rowsPerPage.value = value;
      currentPage.value = 0; // 改变每页行数时，重置回第一页
      currentRowsStartOffset.value = 0;
      usageRecordDataSource.value?.loadData(
        currentPage.value,
        rowsPerPage.value,
      );
    }
  }

  // 显示编辑对话框 (和之前一样)
  void _showEditDialog(UsageRecordModel record) {
    Get.defaultDialog(
      title: '编辑使用日期',
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: record.usedAt,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                Get.back();
                _editUsageRecord(record, pickedDate);
              }
            },
            child: Text('选择日期'),
          ),
        ],
      ),
      textConfirm: '取消',
      onConfirm: () => Get.back(),
    );
  }

  // 确认删除对话框 (和之前一样)
  void _confirmDelete(UsageRecordModel record) {
    Get.defaultDialog(
      title: '删除确认',
      content: Text('确定要删除这条使用记录吗？'),
      textConfirm: '删除',
      textCancel: '取消',
      onConfirm: () {
        Get.back();
        _deleteUsageRecord(record);
      },
      onCancel: () {},
    );
  }

  void selectItem(ItemModel item) {
    currentItem.value = item;
  }

  void clearSelection() {
    currentItem.value = null;
  }
}
