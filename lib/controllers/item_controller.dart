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

  // 表格状态管理 (仅用于物品详情页的 UsageRecordsTable)
  late UsageRecordDataSource usageRecordDataSource;
  final RxInt rowsPerPage = 10.obs;
  final RxInt currentPage = 0.obs;
  final RxInt currentRowsStartOffset = 0.obs;

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

    // 监听 currentItem 变化，初始化或更新 UsageRecordDataSource
    ever(currentItem, (item) {
      if (item != null) {
        usageRecordDataSource = UsageRecordDataSource(
          itemId: item.id!,
          onEdit: (record) => _showEditDialog(record),
          onDelete: (record) => _confirmDelete(record),
        );
        // 加载表格数据
        usageRecordDataSource.loadData(
          currentPage.value,
          rowsPerPage.value,
        );
        currentRowsStartOffset.value =
            currentPage.value * rowsPerPage.value;
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

    // 2. 排序
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

  // 添加新物品 (示例，你可能需要单独的 AddItemController)
  Future<void> addNewItem(ItemModel newItem) async {
    final newId = await _itemService.saveItem(newItem);
    // 重新加载所有物品以更新列表
    await loadAllItems();
  }

  // 编辑物品 (示例)
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
    await usageRecordDataSource.refreshData();
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
    await usageRecordDataSource.refreshData();
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
    await usageRecordDataSource.refreshData();
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
    usageRecordDataSource.loadData(pageIndex, rowsPerPage.value);
  }

  // 每页行数改变回调
  void onRowsPerPageChanged(int? value) {
    if (value != null) {
      rowsPerPage.value = value;
      currentPage.value = 0;
      currentRowsStartOffset.value = 0;
      usageRecordDataSource.loadData(
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
