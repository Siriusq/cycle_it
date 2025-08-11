import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestartRequiredPage extends StatelessWidget {
  final bool succeed;
  final String message;

  const RestartRequiredPage({
    super.key,
    required this.succeed,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle titleLG =
        Theme.of(
          context,
        ).textTheme.titleLarge!.useSystemChineseFont();
    final TextStyle bodyLarge =
        Theme.of(context).textTheme.bodyLarge!.useSystemChineseFont();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 状态图标
              Icon(
                succeed
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 80,
                color: succeed ? Colors.green : Colors.redAccent,
              ),
              const SizedBox(height: 24),
              Text(
                message, // 传递过来的消息
                style: titleLG,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // 重启提示
              Text(
                'restart_hint'.tr,
                style: bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
