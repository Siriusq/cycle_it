import 'package:cycle_it/controllers/item_controller.dart';
import 'package:cycle_it/models/item_model.dart';
import 'package:cycle_it/utils/constants.dart';
import 'package:cycle_it/views/components/details_page/usage_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'components/details_page/details_header.dart';
import 'components/icon_label.dart';
import 'components/responsive_component_group.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCtrl = Get.find<ItemController>();

    return Obx(() {
      final ItemModel? item = itemCtrl.selectedItem.value;
      if (item == null) {
        return const SizedBox.shrink();
      }

      return Scaffold(
        body: Container(
          color: kPrimaryBgColor,
          child: SafeArea(
            child: Column(
              children: [
                DetailsHeader(),
                Divider(thickness: 1),
                //标题、标签与图标
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        //标题
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: SvgPicture.asset(
                                  item.iconPath,
                                  colorFilter: ColorFilter.mode(kIconColor, BlendMode.srcIn),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(color: kTitleTextColor, fontWeight: FontWeight.w600, fontSize: 20),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //标签
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 5,
                              children:
                                  item.tags.map((tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: IconLabel(icon: Icons.bookmark, label: tag.name, iconColor: tag.color),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: kDefaultPadding),

                        //图表
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: Wrap(
                            children: [
                              ResponsiveComponentGroup(
                                minComponentWidth: 200, // 组件最小宽度
                                children: List.generate(4, (i) => _buildComponent('大组件 ${i + 1}')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildComponent(String text) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white))),
    );
  }
}
