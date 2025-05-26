import 'package:get/get.dart';

class ResponsiveController extends GetxController {
  var shouldJumpToDetails = true.obs;

  void resetShouldJumpStates() {
    shouldJumpToDetails = true.obs;
  }

  void hadJumped() {
    shouldJumpToDetails = false.obs;
  }
}
