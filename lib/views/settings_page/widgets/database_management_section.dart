import 'package:cycle_it/controllers/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_style.dart';

class DatabaseManagementSection extends StatelessWidget {
  const DatabaseManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.find<ItemController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final TextStyle titleTextStyle = style.titleTextMD;
    final TextStyle bodyTextStyle = style.bodyText;
    final double spacingMD = style.spacingMD;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('database'.tr, style: titleTextStyle)],
          ),
          SizedBox(height: spacingMD),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 导出数据
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.importDatabase();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurface,
                    backgroundColor:
                        Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    elevation: 2,
                  ),
                  child: Text('data_import'.tr, style: bodyTextStyle),
                ),
              ),
              // 导入数据
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.exportDatabase();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurface,
                    backgroundColor:
                        Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    elevation: 2,
                  ),
                  child: Text('data_export'.tr, style: bodyTextStyle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
