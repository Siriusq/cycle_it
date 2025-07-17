import 'dart:io';

import 'package:cycle_it/controllers/search_bar_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/usage_record_data_source.dart';
import '../database/database.dart';
import '../models/item_model.dart';
import '../models/usage_record_model.dart';
import '../services/item_service.dart';
import '../utils/responsive_style.dart';
import '../views/settings_page/widgets/restart_required_page.dart';
import 'item_list_order_controller.dart';

class ItemController extends GetxController {
  final ItemService _itemService = Get.find<ItemService>(); // 注入服务
  final ItemListOrderController _orderController =
      Get.find<ItemListOrderController>();
  final TagController _tagController = Get.find<TagController>();
  final SearchBarController _searchBarController =
      Get.find<SearchBarController>();
  final ResponsiveStyle style = ResponsiveStyle.to;

  // 获取 MyDatabase 实例
  late MyDatabase _db; // 将 final 改为 late，以便在导入后重新赋值

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

  // 用于管理使用记录表格的排序状态
  final RxString usageRecordsSortColumn = 'usedAt'.obs; // 默认按使用日期排序
  final RxBool usageRecordsSortAscending = true.obs; // 默认升序

  @override
  void onInit() {
    super.onInit();

    // 在 onInit 中获取 MyDatabase 实例
    _db = Get.find<MyDatabase>();

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
      if (currentItem.value != null &&
          currentItem.value!.id != null) {
        await loadItemForDetails(currentItem.value!.id!);
      }
    });

    // --- currentItem 变化时直接使用 item.usageRecords 初始化数据源 ---
    ever(currentItem, (item) {
      if (item != null && item.id != null) {
        usageRecordDataSource.value = UsageRecordDataSource(
          itemId: item.id!,
          initialRecords: item.usageRecords,
          initialSortColumn: usageRecordsSortColumn.value,
          initialSortAscending: usageRecordsSortAscending.value,
        );
      } else {
        usageRecordDataSource.value = null;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // 在首帧画面渲染完成后执行，此时数据库已完全加载，可以加载所有物品
    loadAllItems();
  }

  // 从数据库加载所有物品
  Future<void> loadAllItems() async {
    isLoading.value = true; // 开始加载
    try {
      final loadedItems = await _itemService.getAllItems();
      allItems.assignAll(loadedItems);
    } catch (e) {
      Get.snackbar('error'.tr, '$e');
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
      // 当 currentItem 变化时，如果数据源已存在，更新其记录
      if (usageRecordDataSource.value != null) {
        usageRecordDataSource.value!.updateRecords(item.usageRecords);
      }
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

    // 这一步是关键：需要确保数据源被告知排序变化，以便它重新排序内部数据
    // 然后数据源会调用 notifyListeners() 刷新 UI
    usageRecordDataSource.value?.sort(
      usageRecordsSortColumn.value,
      usageRecordsSortAscending.value,
    );
  }

  void selectItem(ItemModel item) {
    currentItem.value = item;
  }

  void clearSelection() {
    currentItem.value = null;
  }

  // 导出数据库
  Future<void> exportDatabase() async {
    isLoading.value = true;
    try {
      await _db.exportDatabase();
    } catch (e) {
      Get.snackbar('database_export_failed'.tr, '$e');
    } finally {
      isLoading.value = false;
    }
  }

  // 导入数据库
  Future<void> importDatabase() async {
    isLoading.value = true;
    String restartMessage = ''; // 用于存储传递给重启页面的消息

    try {
      // 请求存储权限
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar(
            'database_import_failed'.tr,
            'database_import_permission_error'.tr,
          );
          isLoading.value = false;
          return;
        }
      }

      //使用 file_picker 选择数据库文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['sqlite'],
      );

      if (result == null || result.files.single.path == null) {
        Get.snackbar(
          'database_import_failed'.tr,
          'database_import_canceled_error'.tr,
        );
        isLoading.value = false;
        return;
      }

      final selectedFile = File(result.files.single.path!);
      if (!await selectedFile.exists()) {
        Get.snackbar(
          'database_import_failed'.tr,
          'database_import_file_error'.tr,
        );
        isLoading.value = false;
        return;
      }

      // 关闭数据库连接
      await _db.close();

      // 执行文件替换操作 (重命名旧文件，复制新文件)
      final bool fileOpsSuccess = await _db.importDatabase(
        selectedFile,
      );

      if (fileOpsSuccess) {
        restartMessage = 'database_imported'.tr;
      } else {
        restartMessage = 'database_import_failed'.tr;
      }

      Get.offAll(
        () => RestartRequiredPage(
          succeed: fileOpsSuccess,
          message: restartMessage,
        ),
      );
    } catch (e) {
      Get.offAll(
        () => RestartRequiredPage(
          succeed: false,
          message: e.toString(),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
