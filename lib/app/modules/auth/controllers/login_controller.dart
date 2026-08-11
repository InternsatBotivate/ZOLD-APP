import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/auth_models.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter username and password';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authRepository.login(
        LoginRequest(
          username: usernameController.text.trim(),
          password: passwordController.text,
        ),
      );

      if (response.success && response.data != null) {
        await SecureStorage().saveToken(response.data!.token);

        // Fetch full profile and KYC status before navigation
        await AuthService.to.validateSession();

        // Set loading to false BEFORE navigation to avoid triggering Obx after disposal
        isLoading.value = false;

        // Parity with Next.js: Check KYC completion status
        if (AuthService.to.kycCompleted) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.kyc);
        }
      } else {
        errorMessage.value = response.message ?? 'Login failed';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }

  @override
  void onClose() {
    // Note: Manual disposal of TextEditingControllers in onClose can cause 
    // "used after disposed" errors during page transitions in GetX.
    // They will be garbage collected when this controller is removed from memory.
    super.onClose();
  }
}
