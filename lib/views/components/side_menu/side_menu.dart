import 'package:cycle_it/controllers/item_list_order_controller.dart';
import 'package:cycle_it/controllers/tag_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:cycle_it/views/components/dialog/add_tag_dialog.dart';
import 'package:cycle_it/views/components/side_menu/order_by_option.dart';
import 'package:cycle_it/views/components/side_menu/tag_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../settings_page.dart';

class SideMenu extends StatelessWidget {
  final itemListOrderCtrl = Get.find<ItemListOrderController>();
  final tagCtrl = Get.find<TagController>();

  SideMenu({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;
    final double spacingLG = style.spacingLG;
    final double appIconSize = style.appIconSize;
    final TextStyle titleTextEX = style.titleTextEX;
    final TextStyle titleTextMD = style.titleTextMD;
    final double iconSizeMD = style.iconSizeMD;
    final double iconSizeLG = style.iconSizeLG;

    return Container(
      height: double.infinity,
      color: kSecondaryBgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题图标、设置按钮
              Padding(
                padding: EdgeInsets.all(spacingLG),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      //App 图标
                      Image.asset(
                        "assets/images/logo_transparent.png",
                        width: appIconSize,
                        height: appIconSize,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: spacingMD),
                      // 中间文字
                      Expanded(
                        child: Text(
                          "Cycle It",
                          style: titleTextEX,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //设置按钮
                      SizedBox(
                        height: iconSizeLG,
                        width: iconSizeLG,
                        child: IconButton(
                          iconSize: iconSizeMD,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed:
                              () => Get.to(() => SettingsPage()),
                          icon: const Icon(
                            Icons.tune,
                            color: kTitleTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 分割线
              const Divider(height: 0),

              //排序
              Padding(
                padding: EdgeInsets.all(spacingLG),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sort),
                        const SizedBox(width: 5),
                        Text("Order By", style: titleTextMD),
                      ],
                    ),
                    //SizedBox(height: spacingMD),
                    OrderByOption(
                      orderType: OrderType.name,
                      icon: Icons.sort_by_alpha,
                      title: "Names",
                    ),
                    OrderByOption(
                      orderType: OrderType.lastUsed,
                      icon: Icons.event,
                      title: "Recent Used",
                    ),
                    OrderByOption(
                      orderType: OrderType.frequency,
                      icon: Icons.equalizer,
                      title: "Frequency",
                    ),
                  ],
                ),
              ),

              // 分割线
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacingLG),
                child: const Divider(height: 0),
              ),

              //标签
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacingLG,
                  vertical: spacingMD,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bookmark_outline),
                        const SizedBox(width: 5),
                        Text("Tags", style: titleTextMD),
                        Spacer(),
                        SizedBox(
                          height: iconSizeLG,
                          width: iconSizeLG,
                          child: IconButton(
                            iconSize: iconSizeMD,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final result = await Get.dialog(
                                AddTagDialog(),
                              );
                              if (result != null &&
                                  result['success']) {
                                Get.snackbar(
                                  'success'.tr,
                                  '${result['message']}',
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      return Column(
                        children:
                            tagCtrl.allTags.map((tag) {
                              return TagOption(
                                tagName: tag.name,
                                color: tag.color,
                              );
                            }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
