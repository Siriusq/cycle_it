import 'package:cycle_it/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/item_controller.dart';
import '../../../models/item_model.dart';
import '../../../utils/responsive_style.dart';
import '../../shared_widgets/delete_confirm_dialog.dart';

class DetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemCtrl = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double appBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;
    // final bool isPrimary =
    //     GetPlatform.isAndroid ||
    //     (GetPlatform.isIOS && ResponsiveLayout.isSingleCol(context));

    // 使用 Obx 监听 itemCtrl.currentItem，以便在 item 删除或加载时可以动态更新 AppBar 的内容
    return Obx(() {
      final ItemModel? item = itemCtrl.currentItem.value;

      return AppBar(
        primary: ResponsiveLayout.isSingleCol(context),
        automaticallyImplyLeading: false,
        // 防止滚动时变色
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        toolbarHeight: appBarHeight,
        // 左侧返回按钮
        leading: BackButton(
          onPressed: () {
            _handleBack(itemCtrl);
          },
        ),
        // 标题显示物品名称
        title:
            item != null
                ? Text(
                  item.name,
                  overflow: TextOverflow.ellipsis, // 防止文本过长溢出
                )
                : null,
        // 如果 item 为空，则不显示标题
        centerTitle: true,
        // 标题居中
        // AppBar底部的分割线
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 0),
        ),
        // 右侧删除与编辑按钮，仅当 item 不为空时显示
        actions:
            item != null
                ? [
                  IconButton(
                    onPressed:
                        () => _handleDelete(context, itemCtrl, item),
                    icon: const Icon(Icons.delete_outline),
                  ),
                  IconButton(
                    onPressed: () => _handleEdit(itemCtrl, item),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  SizedBox(width: isMobile ? 4 : spacingLG), // 右侧间距
                ]
                : [], // 如果 item 为空，则不显示任何操作按钮
      );
    });
  }

  // 定义 AppBar 的首选大小
  @override
  Size get preferredSize {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingSM = style.spacingSM;
    final double spacingLG = style.spacingLG;
    final bool isMobile = style.isMobileDevice;
    final double appBarHeight =
        style.searchBarHeight +
        (isMobile ? spacingSM : spacingLG) * 2;

    // AppBar 高度设置
    return Size.fromHeight(appBarHeight + 1);
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
      Get.snackbar(
        'deleted_successfully'.tr,
        'item_changed_successfully'.trParams({
          'name': item.name,
          'action': 'delete'.tr,
        }),
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _handleEdit(
    ItemController itemCtrl,
    ItemModel item,
  ) async {
    final result = await Get.toNamed('/AddEditItem', arguments: item);
    if (result != null && result['success']) {
      Get.snackbar(
        'success'.tr,
        '${result['message']}',
        duration: const Duration(seconds: 1),
      );
    }
  }
}
