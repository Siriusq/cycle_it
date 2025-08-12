import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/controllers/language_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 枚举语言选项
enum LanguageOption {
  simplifiedChinese,
  traditionalChinese,
  english,
  system,
}

class LanguageSwitchSection extends StatelessWidget {
  const LanguageSwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double breakpoint =
        ResponsiveStyle.to.settingsPageBreakpoint;

    final LanguageController languageController = Get.find();

    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();

    return Container(
      // 让容器撑满父容器的宽度
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
          // 根据宽度判断使用哪种布局
          if (constraints.maxWidth > breakpoint) {
            // 宽屏布局
            return _buildWideLayout(
              context,
              languageController,
              titleLG,
            );
          } else {
            // 窄屏布局
            return _buildNarrowLayout(
              context,
              languageController,
              titleLG,
            );
          }
        },
      ),
    );
  }

  // 宽屏布局：左右结构
  Widget _buildWideLayout(
    BuildContext context,
    LanguageController languageController,
    TextStyle titleStyle,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左侧：标题
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('language'.tr, style: titleStyle),
            ),
          ),
          // 中间：分割线
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: VerticalDivider(),
          ),
          // 右侧：按钮
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildButtons(languageController, context),
            ),
          ),
        ],
      ),
    );
  }

  // 窄屏布局：上下结构
  Widget _buildNarrowLayout(
    BuildContext context,
    LanguageController languageController,
    TextStyle titleStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 顶部：标题
        Center(child: Text('language'.tr, style: titleStyle)),
        const SizedBox(height: 16.0),
        // 底部：按钮
        ..._buildButtons(languageController, context),
      ],
    );
  }

  // 构建语言切换按钮列表
  List<Widget> _buildButtons(
    LanguageController languageController,
    BuildContext context,
  ) {
    return LanguageOption.values.map((option) {
      final bool isSelected =
          (option == LanguageOption.system &&
              languageController.isFollowingSystemLanguage()) ||
          (option == LanguageOption.simplifiedChinese &&
              languageController.currentLocale ==
                  const Locale('zh', 'CN')) ||
          (option == LanguageOption.traditionalChinese &&
              languageController.currentLocale ==
                  const Locale('zh', 'TW')) ||
          (option == LanguageOption.english &&
              languageController.currentLocale ==
                  const Locale('en', 'US'));

      final button = SizedBox(
        width: double.infinity, // 强制按钮宽度撑满
        child: TextButton.icon(
          onPressed:
              () => _onLanguageOptionPressed(
                option,
                languageController,
              ),
          style: TextButton.styleFrom(
            textStyle:
                Theme.of(
                  context,
                ).textTheme.labelLarge!.useSystemChineseFont(),
            foregroundColor:
                isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
            backgroundColor:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color:
                    isSelected
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.outline,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          icon: Icon(_getOptionIcon(option)),
          label: Text(_getOptionText(option)),
        ),
      );

      // 如果不是最后一个按钮，则在按钮之间添加间距
      if (option != LanguageOption.values.last) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: button,
        );
      }
      return button;
    }).toList();
  }

  // 按钮点击事件处理
  void _onLanguageOptionPressed(
    LanguageOption option,
    LanguageController languageController,
  ) {
    switch (option) {
      case LanguageOption.simplifiedChinese:
        languageController.changeLanguage('zh', countryCode: 'CN');
        break;
      case LanguageOption.traditionalChinese:
        languageController.changeLanguage('zh', countryCode: 'TW');
        break;
      case LanguageOption.english:
        languageController.changeLanguage('en', countryCode: 'US');
        break;
      case LanguageOption.system:
        languageController.setFollowSystemLanguage();
        break;
    }
  }

  // 获取选项的文本
  String _getOptionText(LanguageOption option) {
    switch (option) {
      case LanguageOption.simplifiedChinese:
        return 'simplified_chinese'.tr;
      case LanguageOption.traditionalChinese:
        return 'traditional_chinese'.tr;
      case LanguageOption.english:
        return 'english'.tr;
      case LanguageOption.system:
        return 'follow_system'.tr;
    }
  }

  // 获取选项的图标
  IconData _getOptionIcon(LanguageOption option) {
    switch (option) {
      case LanguageOption.simplifiedChinese:
        return Icons.translate;
      case LanguageOption.traditionalChinese:
        return Icons.g_translate;
      case LanguageOption.english:
        return Icons.font_download_outlined;
      case LanguageOption.system:
        return Icons.language;
    }
  }
}
