import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_charts/material_charts.dart';

import '../data/usage_record_data_source.dart';
import '../database/database.dart';
import '../models/item_model.dart';
import '../models/usage_record_model.dart';
import '../services/item_service.dart';
import '../utils/responsive_style.dart';
import 'item_list_order_controller.dart';

// 负载中增加 RootIsolateToken
class _ItemDetailsPayload {
  final int itemId;
  final RootIsolateToken rootIsolateToken;

  _ItemDetailsPayload(this.itemId, this.rootIsolateToken);
}

// 后台 Isolate 函数
Future<ItemModel?> _fetchItemDetailsInIsolate(
  _ItemDetailsPayload payload,
) async {
  // 在执行任何操作前，使用 Token 初始化平台通信
  BackgroundIsolateBinaryMessenger.ensureInitialized(
    payload.rootIsolateToken,
  );

  final db = MyDatabase();
  final service = ItemService(db);
  final item = await service.getItemWithUsageRecords(payload.itemId);
  await db.close();
  return item;
}

class ItemController extends GetxController {
  final ItemService _itemService = Get.find<ItemService>(); // 注入服务
  final ItemListOrderController _orderController =
      Get.find<ItemListOrderController>();
  final TagController _tagController = Get.find<TagController>();
  final SearchBarController _searchBarController =
      Get.find<SearchBarController>();
  final ResponsiveStyle style = ResponsiveStyle.to;

  // 主列表加载状态
  RxBool isListLoading = true.obs;

  // 详情页加载状态
  RxBool isDetailsLoading = false.obs;

  // 主页列表数据
  final RxList<ItemModel> allItems = <ItemModel>[].obs; // 存储所有加载的物品
  final RxList<ItemModel> displayedItems =
      <ItemModel>[].obs; // 经过排序和筛选后显示在主页的物品

  // 物品详情页数据
  // 在列表中标记哪个被选中
  final Rx<ItemModel?> selectedItemPreview = Rx<ItemModel?>(null);

  // 存储从数据库加载的完整物品详情
  final Rx<ItemModel?> currentItem = Rx<ItemModel?>(null);

  // 表格状态管理
  // 使用 Rx<UsageRecordDataSource?> 来允许它在初始化之前为 null
  Rx<UsageRecordDataSource?> usageRecordDataSource =
      Rx<UsageRecordDataSource?>(null);

  // 管理使用记录表格的排序状态
  final RxString usageRecordsSortColumn = 'usedAt'.obs; // 默认按使用日期排序
  final RxBool usageRecordsSortAscending = true.obs; // 默认升序

  // 热力图相关状态和方法
  final RxMap<DateTime, int> heatMapData =
      <DateTime, int>{}.obs; // 热力图数据
  final RxBool isLoadingHeatmapData = false.obs; // 热力图数据加载状态
  final RxString heatMapError = ''.obs; // 热力图数据加载错误信息

  // 月度使用图表相关状态
  final RxList<BarChartData> monthlyBarChartData =
      <BarChartData>[].obs;
  final RxBool isLoadingMonthlyChartData = false.obs;
  final RxString monthlyChartError = ''.obs;
  final RxDouble monthlyUsageSum = 0.0.obs; // 用于判断是否有数据

  @override
  void onInit() {
    super.onInit();

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
      // 如果详情页内有物品展示，刷新它的数据
      if (currentItem.value != null) {
        await loadItemForDetails(currentItem.value!.id!);
      }
    });

    // 当详情数据加载完成后，触发图表和表格数据的处理
    ever(currentItem, (item) async {
      if (item != null) {
        // 初始化使用记录数据源
        usageRecordDataSource.value = UsageRecordDataSource(
          itemId: item.id!,
          initialRecords: item.usageRecords,
          initialSortColumn: usageRecordsSortColumn.value,
          initialSortAscending: usageRecordsSortAscending.value,
        );
        // 处理热力图数据
        _loadHeatmapDataInIsolate(item.usageRecords);
        // 处理月度图表数据
        _loadMonthlyUsageDataInIsolate(item.usageRecords);
      } else {
        usageRecordDataSource.value = null;

        // 清空热力图数据和状态
        heatMapData.clear();
        isLoadingHeatmapData.value = false;
        heatMapError.value = '';

        // 清空月度图表数据和状态
        monthlyBarChartData.clear();
        isLoadingMonthlyChartData.value = false;
        monthlyChartError.value = '';
        monthlyUsageSum.value = 0.0;
      }
    });
  }

  // 从数据库加载所有物品
  Future<void> loadAllItems() async {
    isListLoading.value = true; // 开始加载
    try {
      final loadedItems = await _itemService.getAllItems();
      allItems.assignAll(loadedItems);
    } catch (e) {
      Get.snackbar('error'.tr, '$e');
    } finally {
      isListLoading.value = false; // 结束加载
    }
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
            // 可以根据物品的名称、描述或任何其他字段进行搜索
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
    await _itemService.saveItem(newItem);
    // 重新加载所有物品以更新列表
    await loadAllItems();
  }

  // 编辑物品（不包括使用记录）
  Future<void> updateItemDetails(ItemModel updatedItem) async {
    await _itemService.updateItemDetails(updatedItem);

    // 更新完成后，刷新主列表和详情页（如果正在显示）
    await loadAllItems();
    if (currentItem.value?.id == updatedItem.id) {
      await loadItemForDetails(updatedItem.id!);
    }
  }

  // 删除物品
  Future<void> deleteItem(int itemId) async {
    await _itemService.deleteItem(itemId);
    await loadAllItems();
    if (selectedItemPreview.value?.id == itemId) {
      clearSelection();
    }
  }

  // -------------------- 物品详情页使用记录表格相关方法 --------------------

  // 加载物品及其使用记录（用于详情页）
  Future<void> loadItemForDetails(int itemId) async {
    // 如果正在加载同一个物品，则不重复加载
    if (isDetailsLoading.value && currentItem.value?.id == itemId) {
      return;
    }

    isDetailsLoading.value = true;
    currentItem.value = null; // 先清空旧数据以显示加载指示器

    try {
      // 获取 RootIsolateToken，确保它不为 null
      final rootToken = RootIsolateToken.instance;
      if (rootToken == null) {
        throw Exception(
          "Could not get RootIsolateToken. Make sure this is running on the main isolate.",
        );
      }

      // 使用 compute 调用后台函数，并传递 Token
      final item = await compute(
        _fetchItemDetailsInIsolate,
        _ItemDetailsPayload(itemId, rootToken),
      );

      if (item != null) {
        currentItem.value = item;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar(
        'error'.tr,
        'failed_to_load_item_details'.trParams({
          'error': e.toString(),
        }),
      );
    } finally {
      if (isDetailsLoading.value) {
        isDetailsLoading.value = false;
      }
    }
  }

  // 添加使用记录
  Future<void> addUsageRecord(DateTime usedAt) async {
    if (currentItem.value == null) return;

    await _itemService.addUsageRecordAndRecalculate(
      currentItem.value!.id!,
      usedAt,
    );

    // 重新加载当前物品的详情，这将自动更新 usageRecordDataSource
    await loadItemForDetails(currentItem.value!.id!);
    await loadAllItems(); // 更新主页列表的 ItemModel
  }

  // 物品卡片快速添加使用记录
  Future<void> addUsageRecordFast(
    ItemModel item,
    DateTime usedAt,
  ) async {
    await _itemService.addUsageRecordAndRecalculate(item.id!, usedAt);
    if (currentItem.value?.id == item.id) {
      await loadItemForDetails(item.id!);
    }
    await loadAllItems(); // 更新主页列表的 ItemModel
  }

  // 编辑使用记录的日期
  Future<void> editUsageRecord(
    UsageRecordModel record,
    DateTime newUsedAt,
  ) async {
    if (currentItem.value == null) return;

    await _itemService.editUsageRecordAndRecalculate(
      record.id,
      currentItem.value!.id!,
      newUsedAt,
    );

    // 重新加载当前物品的详情，这将自动更新 usageRecordDataSource
    await loadItemForDetails(currentItem.value!.id!);
    await loadAllItems();
  }

  // 删除使用记录
  Future<void> deleteUsageRecord(UsageRecordModel record) async {
    if (currentItem.value == null) return;

    await _itemService.deleteUsageRecordAndRecalculate(
      record.id,
      currentItem.value!.id!,
    );

    // 重新加载当前物品的详情，这将自动更新 usageRecordDataSource
    await loadItemForDetails(currentItem.value!.id!);
    await loadAllItems();
  }

  // 处理使用记录表格排序的回调方法
  void onUsageRecordsSort(String columnName) {
    // 如果点击的是当前排序列，则切换排序方向
    if (usageRecordsSortColumn.value == columnName) {
      usageRecordsSortAscending.value =
          !usageRecordsSortAscending.value;
    } else {
      // 如果点击的是新的列，则将排序列更新为新列，并默认升序
      usageRecordsSortColumn.value = columnName;
      usageRecordsSortAscending.value = true;
    }

    // 确保数据源被告知排序变化，以便它重新排序内部数据
    usageRecordDataSource.value?.sort(
      usageRecordsSortColumn.value,
      usageRecordsSortAscending.value,
    );
  }

  void selectItem(ItemModel item) {
    selectedItemPreview.value = item;
    currentItem.value = item;
    loadItemForDetails(item.id!);
  }

  // 清除选中状态
  void clearSelection() {
    selectedItemPreview.value = null;
    currentItem.value = null;
  }

  // -------------------- 物品详情页图表相关方法 --------------------

  // 加载并处理热力图数据
  Future<void> _loadHeatmapDataInIsolate(
    List<UsageRecordModel> records,
  ) async {
    isLoadingHeatmapData.value = true;
    heatMapData.clear();

    try {
      if (records.isEmpty) {
        isLoadingHeatmapData.value = false;
        return;
      }

      final Map<DateTime, int> result = await compute(
        _processHeatmapDataInIsolate,
        records,
      );
      heatMapData.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('Error processing heatmap data in isolate: $e');
      }
    } finally {
      isLoadingHeatmapData.value = false;
    }
  }

  // 执行热力图数据处理。
  static Map<DateTime, int> _processHeatmapDataInIsolate(
    List<UsageRecordModel> records,
  ) {
    Map<DateTime, int> tempHeatMapData = {};

    for (var record in records) {
      DateTime day = DateTime(
        record.usedAt.year,
        record.usedAt.month,
        record.usedAt.day,
      );
      tempHeatMapData.update(
        day,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return tempHeatMapData;
  }

  // 加载并处理月度使用图表数据
  Future<void> _loadMonthlyUsageDataInIsolate(
    List<UsageRecordModel> records,
  ) async {
    isLoadingMonthlyChartData.value = true;
    monthlyBarChartData.clear();
    monthlyUsageSum.value = 0.0;

    try {
      if (records.isEmpty) {
        isLoadingMonthlyChartData.value = false;
        return;
      }

      final Map<String, dynamic> result = await compute(
        _processMonthlyUsageDataInIsolate,
        records,
      );

      final List<BarChartData> processedData =
          (result['data'] as List)
              .map(
                (item) => BarChartData(
                  value: item['value'],
                  label: item['label'],
                ),
              )
              .toList();
      final double sum = result['sum'];

      monthlyBarChartData.assignAll(processedData);
      monthlyUsageSum.value = sum;
    } catch (e) {
      if (kDebugMode) {
        print('Error processing monthly chart data in isolate: $e');
      }
    } finally {
      isLoadingMonthlyChartData.value = false;
    }
  }

  // 执行月度使用图表数据处理。
  static Map<String, dynamic> _processMonthlyUsageDataInIsolate(
    List<UsageRecordModel> records,
  ) {
    List<double> monthlyUsage = List.filled(13, 0);
    final int currentYear = DateTime.now().year;

    for (var record in records) {
      if (record.usedAt.year == currentYear) {
        monthlyUsage[record.usedAt.month]++;
      }
    }

    double usageSum = 0;
    for (var usage in monthlyUsage) {
      usageSum += usage;
    }

    final List<String> monthLabels = [
      '', //index placeholder
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final List<Map<String, dynamic>> barChartData = [];
    for (int i = 1; i <= 12; i++) {
      barChartData.add({
        'value': monthlyUsage[i],
        'label': monthLabels[i],
      });
    }

    return {'data': barChartData, 'sum': usageSum};
  }
}
