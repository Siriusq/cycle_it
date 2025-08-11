import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/database_management_controller.dart';

class DatabaseManagementSection extends StatelessWidget {
  const DatabaseManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 定义屏幕宽度断点
    const double breakpoint = 600.0;
    final DatabaseManagementController controller =
        Get.find<DatabaseManagementController>();
    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > breakpoint) {
            // 宽屏布局
            return _buildWideLayout(context, controller, titleLG);
          } else {
            // 窄屏布局
            return _buildNarrowLayout(context, controller, titleLG);
          }
        },
      ),
    );
  }

  // 宽屏布局
  Widget _buildWideLayout(
    BuildContext context,
    DatabaseManagementController controller,
    TextStyle titleStyle,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('database'.tr, style: titleStyle),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: VerticalDivider(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildButtons(context, controller),
            ),
          ),
        ],
      ),
    );
  }

  // 窄屏布局
  Widget _buildNarrowLayout(
    BuildContext context,
    DatabaseManagementController controller,
    TextStyle titleStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Text('database'.tr, style: titleStyle)),
        const SizedBox(height: 16.0),
        ..._buildButtons(context, controller),
      ],
    );
  }

  // 构建按钮列表
  List<Widget> _buildButtons(
    BuildContext context,
    DatabaseManagementController controller,
  ) {
    return [
      // 导入数据按钮
      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () async {
            await controller.importDatabase();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          icon: const Icon(Icons.download),
          label: Text('data_import'.tr),
        ),
      ),
      const SizedBox(height: 8.0), // 按钮之间的间距
      // 导出数据按钮
      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () async {
            await controller.exportDatabase();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          icon: const Icon(Icons.upload),
          label: Text('data_export'.tr),
        ),
      ),
    ];
  }
}
