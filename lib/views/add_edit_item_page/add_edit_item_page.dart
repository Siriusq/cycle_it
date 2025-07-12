import 'package:cycle_it/views/add_edit_item_page/widgets/add_edit_item_app_bar.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/add_edit_item_desktop_layout.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/emoji_color_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/name_comment_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/notify_switch_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/tag_section.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

class AddEditItemPage extends StatelessWidget {
  const AddEditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final bool isMobileDevice = style.isMobileDevice;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar:
              isMobileDevice
                  ? AddEditItemAppBar()
                  : null, // 桌面端不显示 AppBar

          body: SafeArea(
            child:
                isMobileDevice
                    ? _buildContentColumn()
                    : AddEditItemDesktopLayout(
                      // 桌面布局
                      mainContent: _buildContentColumn(),
                    ),
          ),
        );
      },
    );
  }

  Widget _buildContentColumn() {
    final ResponsiveStyle style = ResponsiveStyle.to;
    final double spacingMD = style.spacingMD;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacingMD,
        vertical: spacingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. 图标与颜色选择器 ---
          const EmojiColorSection(),
          SizedBox(height: spacingMD * 2),
          // --- 2. 名称和注释输入 ---
          const NameCommentSection(),
          SizedBox(height: spacingMD),
          // --- 3. 标签 ---
          const TagSection(),
          SizedBox(height: spacingMD),
          // --- 4. 是否开启通知功能 ---
          const NotifySwitchSection(),
        ],
      ),
    );
  }
}
