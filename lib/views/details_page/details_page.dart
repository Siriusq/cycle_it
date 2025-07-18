import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/details_page/widgets/details_app_bar.dart';
import 'package:cycle_it/views/details_page/widgets/details_charts_group.dart';
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
    final style = ResponsiveStyle.to;
    final double spacingLG = style.spacingLG;
    final double spacingMD = style.spacingMD;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ResponsiveLayout.isSingleCol(context) &&
          Get.currentRoute == '/Details') {
        Get.back();
      }
    });

    return SafeArea(
      left: false,
      top: false,
      child: Scaffold(
        appBar: DetailsAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //标题、标签与图标
                    DetailsItemTitle(),
                    DetailsItemTags(),
                    SizedBox(height: spacingLG),

                    //图表
                    DetailsOverview(),
                    SizedBox(height: spacingMD),

                    // 使用记录
                    ResponsiveComponentGroup(
                      minComponentWidth: style.minComponentWidthMD,
                      aspectRation: 0.55,
                      children: [
                        UsageRecordsTable(),
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
    );
  }
}
