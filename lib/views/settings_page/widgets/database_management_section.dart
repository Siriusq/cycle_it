import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/database_management_controller.dart';
import '../../../utils/responsive_style.dart';

class DatabaseManagementSection extends StatelessWidget {
  const DatabaseManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseManagementController controller =
        Get.find<DatabaseManagementController>();
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
            spacing: spacingMD,
            children: [
              // 导出数据
              TextButton.icon(
                onPressed: () async {
                  await controller.importDatabase();
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurface,
                  backgroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.download),
                label: Text('data_import'.tr, style: bodyTextStyle),
              ),
              // 导入数据
              TextButton.icon(
                onPressed: () async {
                  await controller.exportDatabase();
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurface,
                  backgroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.upload),
                label: Text('data_export'.tr, style: bodyTextStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
