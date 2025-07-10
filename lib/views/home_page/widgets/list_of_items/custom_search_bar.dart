import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/search_bar_controller.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/responsive_style.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchBarController searchBarCtrl =
        Get.find<SearchBarController>();
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isMobile = style.isMobileDevice;

    final double searchBarHeight = style.searchBarHeight;
    final double searchBarIconSize = style.searchBarIconSize;
    final double searchBarButtonSize = style.searchBarButtonSize;
    final TextStyle searchBarHintStyle = style.searchBarHintStyle;

    return Expanded(
      child: SizedBox(
        height: searchBarHeight,
        child: Obx(() {
          return TextField(
            style: searchBarHintStyle,
            textAlignVertical:
                isMobile
                    ? TextAlignVertical.bottom
                    : TextAlignVertical.center,
            controller: searchBarCtrl.textController,
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: searchBarHintStyle,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: kSelectedBorderColor,
                  width: 2.0,
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 清除文字按钮
                  SizedBox(
                    height: searchBarButtonSize,
                    width: searchBarButtonSize,
                    child:
                        searchBarCtrl.hasText.value
                            ? IconButton(
                              padding: const EdgeInsets.all(0.0),
                              iconSize: searchBarIconSize,
                              onPressed: () {
                                searchBarCtrl.clearText();
                                // 清除文本后立即执行一次搜索，以清除筛选结果
                                searchBarCtrl.performSearch();
                              },
                              icon: const Icon(Icons.clear),
                            )
                            : null,
                  ),
                  // 搜索按钮
                  SizedBox(
                    height: searchBarButtonSize,
                    width: searchBarButtonSize,
                    child:
                        searchBarCtrl.hasText.value
                            ? IconButton(
                              padding: const EdgeInsets.all(0.0),
                              iconSize: searchBarIconSize,
                              onPressed: () {
                                searchBarCtrl
                                    .performSearch(); // 点击搜索按钮时执行搜索
                              },
                              icon: const Icon(Icons.search),
                            )
                            : Icon(
                              Icons.search,
                              size: searchBarIconSize,
                            ),
                  ),
                  // 占位符
                  const SizedBox(width: 6),
                ],
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: kBorderColor,
                  width: 2.0,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
