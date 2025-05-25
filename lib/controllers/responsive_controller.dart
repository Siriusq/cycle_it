import 'package:get/get.dart';

class ResponsiveController extends GetxController {
  var shouldJumpToDetails = true.obs;

  void resetStates() {
    shouldJumpToDetails = true.obs;
  }

  void hadJumped() {
    shouldJumpToDetails = false.obs;
  }
}
