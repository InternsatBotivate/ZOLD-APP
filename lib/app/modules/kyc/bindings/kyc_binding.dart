import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';

class KYCBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KYCController>(() => KYCController());
  }
}
