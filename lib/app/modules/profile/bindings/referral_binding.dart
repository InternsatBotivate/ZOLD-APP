import 'package:get/get.dart';
import '../controllers/referral_controller.dart';

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReferralController>(ReferralController());
  }
}
