import 'package:get/get.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is int) {
        currentIndex.value = Get.arguments as int;
      } else if (Get.arguments is Map && Get.arguments['tab'] != null) {
        currentIndex.value = Get.arguments['tab'] as int;
      }
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
