import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_style.dart';

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
    final LanguageController languageController = Get.find();
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
            children: [Text('language'.tr, style: titleTextStyle)],
          ),
          SizedBox(height: spacingMD),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                LanguageOption.values.map((option) {
                  final bool isSelected =
                      (option == LanguageOption.system &&
                          languageController
                              .isFollowingSystemLanguage()) ||
                      (option == LanguageOption.simplifiedChinese &&
                          languageController.currentLocale ==
                              const Locale('zh', 'CN')) ||
                      (option == LanguageOption.traditionalChinese &&
                          languageController.currentLocale ==
                              const Locale('zh', 'TW')) ||
                      (option == LanguageOption.english &&
                          languageController.currentLocale ==
                              const Locale('en', 'US'));

                  return TextButton.icon(
                    onPressed: () {
                      switch (option) {
                        case LanguageOption.simplifiedChinese:
                          languageController.changeLanguage(
                            'zh',
                            countryCode: 'CN',
                          );
                          break;
                        case LanguageOption.traditionalChinese:
                          languageController.changeLanguage(
                            'zh',
                            countryCode: 'TW',
                          );
                          break;
                        case LanguageOption.english:
                          languageController.changeLanguage(
                            'en',
                            countryCode: 'US',
                          );
                          break;
                        case LanguageOption.system:
                          languageController
                              .setFollowSystemLanguage();
                          break;
                      }
                    },
                    style: TextButton.styleFrom(
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
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : Theme.of(
                                    context,
                                  ).colorScheme.outline,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(_getOptionIcon(option)),
                    label: Text(
                      _getOptionText(option),
                      style: bodyTextStyle,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // 文本选项
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

  // 图标选项
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
