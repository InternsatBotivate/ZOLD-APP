import 'package:get/get.dart';
import '../controllers/coin_checkout_controller.dart';

class CoinCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoinCheckoutController>(
      () => CoinCheckoutController(Get.find()),
    );
  }
}
