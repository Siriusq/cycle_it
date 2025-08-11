import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/database_management_controller.dart';

class DatabaseManagementSection extends StatelessWidget {
  const DatabaseManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseManagementController controller =
        Get.find<DatabaseManagementController>();

    final TextStyle titleMD =
        Theme.of(
          context,
        ).textTheme.titleMedium!.useSystemChineseFont();

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
        spacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('database'.tr, style: titleMD)],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
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
                label: Text('data_import'.tr),
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
                label: Text('data_export'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
