import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  final textController = TextEditingController();
  final hasText = false.obs;

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
}
