import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/details_page/widgets/details_charts_group.dart';
import 'package:cycle_it/views/details_page/widgets/details_header.dart';
import 'package:cycle_it/views/details_page/widgets/details_item_tags.dart';
import 'package:cycle_it/views/details_page/widgets/details_item_title.dart';
import 'package:cycle_it/views/details_page/widgets/details_overview.dart';
import 'package:cycle_it/views/details_page/widgets/usage_records_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/responsive_layout.dart';
import '../shared_widgets/responsive_component_group.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final double spacingMD = style.spacingMD;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ResponsiveLayout.isSingleCol(context) &&
          Get.currentRoute == '/Details') {
        Get.back();
      }
    });

    return PopScope(
      canPop: true,
      child: Obx(() {
        final ItemModel? item = itemCtrl.currentItem.value;
        if (item == null) {
          return Container(color: kPrimaryBgColor);
        }

        return Scaffold(
          body: SafeArea(
            left: false,
            child: Container(
              color: kPrimaryBgColor,
              child: Column(
                children: [
                  // 顶栏
                  DetailsHeader(),

                  // 分割线
                  const Divider(height: 0),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacingLG,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //标题、标签与图标
                          DetailsItemTitle(item: item),
                          DetailsItemTags(item: item),
                          SizedBox(height: spacingLG),

                          //图表
                          DetailsOverview(item: item),
                          SizedBox(height: spacingMD),

                          // 使用记录
                          ResponsiveComponentGroup(
                            minComponentWidth:
                                style.minComponentWidthMD,
                            aspectRation: 0.55,
                            children: [
                              UsageRecordsTable(currentItem: item),
                              const DetailsChartsGroup(),
                            ],
                          ),
                          SizedBox(height: spacingLG),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
