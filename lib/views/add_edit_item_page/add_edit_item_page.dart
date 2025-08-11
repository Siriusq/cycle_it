import 'package:cycle_it/views/add_edit_item_page/widgets/add_edit_item_app_bar.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/add_edit_item_desktop_layout.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/emoji_color_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/name_comment_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/notification_options_section.dart';
import 'package:cycle_it/views/add_edit_item_page/widgets/tag_section.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive_style.dart';

class AddEditItemPage extends StatelessWidget {
  const AddEditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobileDevice = ResponsiveStyle.to.isMobileDevice;

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
    final double spacingLG = ResponsiveStyle.to.spacingLG;
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacingLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. 图标与颜色选择器 ---
          const EmojiColorSection(),
          const SizedBox(height: 24),
          // --- 2. 名称和注释输入 ---
          const NameCommentSection(),
          const SizedBox(height: 12),
          // --- 3. 标签 ---
          const TagSection(),
          const SizedBox(height: 16),
          // --- 4. 是否开启通知功能 ---
          const NotificationOptionsSection(),
        ],
      ),
    );
  }
}
