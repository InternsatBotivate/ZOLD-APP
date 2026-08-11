import 'package:get/get.dart';
import '../controllers/auspicious_days_controller.dart';
import '../../../data/repositories/rate_repository.dart';

class AuspiciousDaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuspiciousDaysController>(
      () =>
          AuspiciousDaysController(rateRepository: Get.find<RateRepository>()),
    );
  }
}
