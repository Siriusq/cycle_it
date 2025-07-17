import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestartRequiredPage extends StatelessWidget {
  final bool succeed;
  final String message;

  const RestartRequiredPage({
    super.key,
    required this.succeed,
    required this.message,
  }); // 更新构造函数

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // 重启提示
              Text(
                'restart_hint'.tr,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
