import 'package:get/get.dart';
import '../controllers/gold_coins_controller.dart';

class GoldCoinsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoldCoinsController>(
      () => GoldCoinsController(Get.find(), Get.find()),
    );
  }
}
