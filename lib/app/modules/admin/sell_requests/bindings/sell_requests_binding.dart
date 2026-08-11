import 'package:get/get.dart';
import '../controllers/sell_requests_controller.dart';
import '../../../../data/repositories/admin_repository.dart';

class SellRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellRequestsController>(
      () =>
          SellRequestsController(adminRepository: Get.find<AdminRepository>()),
    );
  }
}
