import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/details_page/widgets/details_app_bar.dart';
import 'package:cycle_it/views/details_page/widgets/details_charts_group.dart';
import 'package:cycle_it/views/details_page/widgets/details_item_tags.dart';
import 'package:cycle_it/views/details_page/widgets/details_item_title.dart';
import 'package:cycle_it/views/details_page/widgets/details_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../utils/responsive_layout.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final double spacingMD = style.spacingMD;
    final ItemController itemCtrl = Get.find<ItemController>();

    // 这个回调用于在宽屏布局下，如果从详情页返回，则清除选中状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ResponsiveLayout.isSingleCol(context) &&
          Get.previousRoute == '/Details') {
        itemCtrl.clearSelection();
      }
    });

    return SafeArea(
      left: false,
      top: !ResponsiveLayout.isSingleCol(context),
      bottom: false,
      child: Scaffold(
        appBar: DetailsAppBar(),
        body: Obx(() {
          final bool isLoading = itemCtrl.isDetailsLoading.value;
          final item = itemCtrl.currentItem.value;

          // 如果正在加载，显示加载指示器
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 如果没有数据（加载失败或未选择），显示提示信息
          if (item == null) {
            return Center(
              child: Text('no_item_details_available'.tr),
            );
          }

          // 数据加载完成，显示页面内容
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacingLG,
                  ),
                  children: [
                    DetailsItemTitle(),
                    DetailsItemTags(),
                    SizedBox(height: spacingLG),
                    DetailsOverview(),
                    SizedBox(height: spacingMD),
                    DetailsChartsGroup(),
                    if (ResponsiveLayout.isSingleCol(context))
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: spacingMD,
                        ),
                        child: Center(
                          child: Text('reached_end_hint'.tr),
                        ),
                      ),
                    SizedBox(height: spacingLG),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
