import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';
import '../../shared_widgets/delete_confirm_dialog.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double horizontalSpacing = isMobile ? 4 : spacingLG;
    final double verticalSpacing = isMobile ? 0 : spacingLG;

    // 使用 Obx 监听 itemCtrl.currentItem，以便在 item 删除时页面可以响应
    return Obx(() {
      final ItemModel? item = itemCtrl.currentItem.value;
      if (item == null) {
        return const SizedBox.shrink(); // 如果 item 为空则不显示导航栏
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalSpacing,
          vertical: verticalSpacing,
        ),
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              BackButton(
                onPressed: () {
                  _handleBack(itemCtrl);
                },
              ),
              const Spacer(),
              IconButton(
                onPressed:
                    () => _handleDelete(context, itemCtrl, item),
                icon: const Icon(Icons.delete_outline),
              ),
              IconButton(
                onPressed: () => _handleEdit(itemCtrl, item),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _handleBack(ItemController itemCtrl) {
    if (Get.currentRoute == '/Details') {
      Get.back();
      // 动画结束后再清空，防止出现页面提前销毁导致的黑屏闪烁
      Future.delayed(const Duration(milliseconds: 300), () {
        itemCtrl.clearSelection();
      });
    } else {
      itemCtrl.clearSelection();
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    ItemController itemCtrl,
    ItemModel item,
  ) async {
    final bool? confirmed = await showDeleteConfirmDialog(
      deleteTargetName: item.name,
    );
    if (confirmed == true) {
      if (Get.currentRoute == '/Details') {
        Get.back();
        // 动画结束后再删除，防止出现页面提前销毁导致的黑屏闪烁
        Future.delayed(const Duration(milliseconds: 300), () {
          itemCtrl.deleteItem(item.id!);
        });
      } else {
        itemCtrl.deleteItem(item.id!);
      }
      Get.snackbar('删除成功', '物品 ${item.name} 已删除！');
    }
  }

  Future<void> _handleEdit(
    ItemController itemCtrl,
    ItemModel item,
  ) async {
    final result = await Get.toNamed('/AddEditItem', arguments: item);
    if (result != null && result['success']) {
      Get.snackbar('成功', '${result['message']}');
    }
  }
}
