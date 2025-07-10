import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_edit_item_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive_style.dart';

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
      child: SizedBox(
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
              initCategory: Category.RECENT, // 默认显示最近使用的表情
              iconColor: kGrayColor,
              iconColorSelected: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              backgroundColor: kBgDarkColor,
              extraTab: CategoryExtraTab.SEARCH, // 启用搜索标签
            ),

            skinToneConfig: SkinToneConfig(
              dialogBackgroundColor: kBgLightColor,
              indicatorColor: kGrayColor,
            ),

            // 移除底部动作栏
            bottomActionBarConfig: BottomActionBarConfig(
              enabled: false,
            ),

            searchViewConfig: SearchViewConfig(
              hintText:
                  Get.locale?.languageCode == 'zh'
                      ? '搜索表情...'
                      : 'Search emoji...',
              backgroundColor: Colors.white,
              buttonIconColor: kPrimaryColor,
              // 添加更详细的搜索框样式
              // searchBoxDecoration: InputDecoration(
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10.0),
              //     borderSide: BorderSide.none,
              //   ),
              //   filled: true,
              //   fillColor: Colors.grey.shade200,
              //   hintText: Get.locale?.languageCode == 'zh' ? '搜索...' : 'Search...',
              //   prefixIcon: const Icon(Icons.search, color: Colors.grey),
              //   suffixIcon: const Icon(Icons.clear, color: Colors.grey),
              // ),
            ),

            emojiViewConfig: EmojiViewConfig(
              columns: style.emojiColCount, // 使用 ResponsiveStyle 的列数
              backgroundColor: kBgLightColor,
              emojiSizeMax:
                  32.0 *
                  (defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              recentsLimit: 28,
              noRecents: Text(
                Get.locale?.languageCode == 'zh'
                    ? '无最近使用'
                    : 'No Recents',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black26,
                ),
              ),
              replaceEmojiOnLimitExceed: true,
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        ),
      ),
    ),
  );
}
