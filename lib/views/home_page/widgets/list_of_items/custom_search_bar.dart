import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/search_bar_controller.dart';
import '../../../../utils/responsive_style.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchBarController searchBarCtrl =
        Get.find<SearchBarController>();
    final ResponsiveStyle style = ResponsiveStyle.to;

    final double searchBarHeight = style.searchBarHeight;
    final double searchBarButtonSize = style.searchBarButtonSize;
    final TextStyle bodyLG = Theme.of(context).textTheme.bodyLarge!;

    return SizedBox(
      height: searchBarHeight,
      child: Obx(() {
        return TextField(
          style: bodyLG,
          textAlignVertical: TextAlignVertical.center,
          controller: searchBarCtrl.textController,
          onChanged: (value) {
            searchBarCtrl.performSearch();
          },
          decoration: InputDecoration(
            hintText: 'search'.tr,
            hintStyle: bodyLG,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 2.0,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 清除文字按钮 + 搜索图标
                SizedBox(
                  height: searchBarButtonSize,
                  width: searchBarButtonSize,
                  child:
                      searchBarCtrl.hasText.value
                          ? IconButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: () {
                              searchBarCtrl.clearText();
                              // 清除文本后立即执行一次搜索，以清除筛选结果
                              searchBarCtrl.performSearch();
                            },
                            icon: const Icon(Icons.clear),
                          )
                          : Icon(Icons.search),
                ),
                // 占位符
                const SizedBox(width: 6),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2.0,
              ),
            ),
          ),
        );
      }),
    );
  }
}
