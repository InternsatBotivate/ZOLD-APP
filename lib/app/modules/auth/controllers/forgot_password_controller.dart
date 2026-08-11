import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/auth_models.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository;

  ForgotPasswordController(this._authRepository);

  final emailController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> sendCode() async {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // The Next.js code always advances to OTP step even if email doesn't exist
      // (privacy measure)
      await _authRepository.forgotPassword(
        ForgotPasswordRequest(email: emailController.text.trim()),
      );

      Get.toNamed(
        Routes.otpVerification,
        arguments: {
          'email': emailController.text.trim(),
          'type': 'forgot_password',
        },
      );
    } catch (e) {
      // Still advance as per Next.js logic, or handle real network error
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void backToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
