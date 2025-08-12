import 'package:cycle_it/controllers/add_edit_item_controller.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showEmojiPickerDialog() {
  final AddEditItemController controller =
      Get.find<AddEditItemController>();
  final ResponsiveStyle style = ResponsiveStyle.to;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      clipBehavior: Clip.antiAlias, // 防止内容超出圆角
      child: Builder(
        builder: (context) {
          return SizedBox(
            height: Get.height * 0.7, // 占据屏幕高度的 70%
            width: style.dialogWidth, // 占据屏幕宽度的 90%
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                controller.chooseEmoji(emoji.emoji); // 更新选中的 emoji
                Get.back(); // 关闭对话框
              },
              config: Config(
                checkPlatformCompatibility: true,
                locale: Get.locale ?? const Locale('en'),

                categoryViewConfig: CategoryViewConfig(
                  initCategory: Category.RECENT,
                  // 默认显示最近使用的表情
                  iconColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  iconColorSelected:
                      Theme.of(context).colorScheme.primary,
                  indicatorColor:
                      Theme.of(context).colorScheme.primaryFixed,
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  backgroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                  extraTab: CategoryExtraTab.SEARCH, // 启用搜索标签
                ),

                skinToneConfig: SkinToneConfig(
                  dialogBackgroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                  indicatorColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),

                // 移除底部动作栏
                bottomActionBarConfig: BottomActionBarConfig(
                  enabled: false,
                ),

                searchViewConfig: SearchViewConfig(
                  hintText: 'search_emoji'.tr,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainer,
                  buttonIconColor:
                      Theme.of(context).colorScheme.onSurface,
                ),

                emojiViewConfig: EmojiViewConfig(
                  columns: style.emojiColCount,
                  // 使用 ResponsiveStyle 的列数
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainer,
                  emojiSizeMax:
                      32.0 *
                      (defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.20
                          : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  recentsLimit: 28,
                  noRecents: Text(
                    'no_recent_used_emoji'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  replaceEmojiOnLimitExceed: true,
                  buttonMode: ButtonMode.MATERIAL,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
