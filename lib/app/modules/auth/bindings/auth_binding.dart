import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/signup_controller.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/otp_verification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(Get.find()));
    Get.lazyPut<SignupController>(() => SignupController(Get.find()));
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find()),
    );
    Get.lazyPut<OTPVerificationController>(
      () => OTPVerificationController(Get.find()),
    );
  }
}
