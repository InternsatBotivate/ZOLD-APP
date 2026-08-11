import 'package:get/get.dart';
import '../controllers/sip_calculator_controller.dart';

class SipCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SipCalculatorController>(() => SipCalculatorController());
  }
}
