import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart'; // 导入主题控制器

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('主题切换')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '当前主题模式:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Obx(
              () => Text(
                themeController.currentThemeModeOption.name,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 按钮组
            Container(
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    ThemeModeOption.values.map((option) {
                      return Obx(() {
                        final bool isSelected =
                            themeController.currentThemeModeOption ==
                            option;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                () =>
                                    themeController.setTheme(option),
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                              backgroundColor:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.primary
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              elevation: isSelected ? 5 : 2,
                            ),
                            child: Text(_getOptionText(option)),
                          ),
                        );
                      });
                    }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            // 示例 UI 元素，展示主题效果
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '这是一个卡片示例',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '此文本的颜色和样式会随主题变化。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('示例按钮'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取主题选项的显示文本
  String _getOptionText(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return '亮色';
      case ThemeModeOption.dark:
        return '暗色';
      case ThemeModeOption.system:
        return '跟随系统';
    }
  }
}
