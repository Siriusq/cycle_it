import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  final textController = TextEditingController();
  final hasText = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    textController.addListener(() {
      hasText.value = textController.text.isNotEmpty;
    });
    super.onInit();
  }

  void clearText() {
    textController.clear();
  }

  // 当点击搜索按钮时调用此方法
  void performSearch() {
    searchQuery.value = textController.text;
  }
}
