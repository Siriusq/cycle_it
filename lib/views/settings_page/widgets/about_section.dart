import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:cycle_it/utils/responsive_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 定义屏幕宽度断点
    final double breakpoint =
        ResponsiveStyle.to.settingsPageBreakpoint;
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
            return _buildWideLayout(context, titleLG);
          } else {
            // 窄屏布局
            return _buildNarrowLayout(context, titleLG);
          }
        },
      ),
    );
  }

  // 宽屏布局
  Widget _buildWideLayout(
    BuildContext context,
    TextStyle titleStyle,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('about'.tr, style: titleStyle),
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
              children: _buildButtons(context),
            ),
          ),
        ],
      ),
    );
  }

  // 窄屏布局
  Widget _buildNarrowLayout(
    BuildContext context,
    TextStyle titleStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Text('about'.tr, style: titleStyle)),
        const SizedBox(height: 16.0),
        ..._buildButtons(context),
      ],
    );
  }

  // 构建按钮列表
  List<Widget> _buildButtons(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      textStyle:
          Theme.of(
            context,
          ).textTheme.labelLarge!.useSystemChineseFont(),
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
    );

    return [
      // 检查更新按钮
      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed:
              () => _launchInBrowser(
                'https://github.com/Siriusq/cycle_it/releases',
              ),
          style: buttonStyle,
          icon: const Icon(Icons.sync),
          label: Text('check_update'.tr),
        ),
      ),
      const SizedBox(height: 8.0), // 按钮之间的间距
      // 使用说明按钮
      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed:
              () => _launchInBrowser(
                'https://github.com/Siriusq/cycle_it',
              ),
          style: buttonStyle,
          icon: const Icon(Icons.menu_book),
          label: Text('read_me'.tr),
        ),
      ),
    ];
  }

  Future<void> _launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'error'.tr,
        'cannot_open_url'.tr,
        duration: const Duration(seconds: 5),
      );
      throw '无法打开 $url';
    }
  }
}
