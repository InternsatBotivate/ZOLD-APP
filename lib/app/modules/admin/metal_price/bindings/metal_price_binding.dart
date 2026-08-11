import 'package:get/get.dart';
import '../controllers/metal_price_controller.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../data/repositories/rate_repository.dart';

class MetalPriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MetalPriceController>(
      () => MetalPriceController(
        adminRepository: Get.find<AdminRepository>(),
        rateRepository: Get.find<RateRepository>(),
      ),
    );
  }
}
