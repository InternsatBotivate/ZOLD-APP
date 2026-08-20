import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/auth_models.dart';
import '../../../routes/app_routes.dart';

class OTPVerificationController extends GetxController {
  final AuthRepository _authRepository;

  OTPVerificationController(this._authRepository);

  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  late String email;
  late String type; // 'signup' or 'forgot_password'

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? '';
    type = args?['type'] ?? 'signup';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> verify() async {
    if (otpController.text.length != 6) {
      errorMessage.value = 'Please enter a valid 6-digit OTP';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (type == 'signup') {
        final response = await _authRepository.verifyOtp(
          VerifyOtpRequest(email: email, otp: otpController.text),
        );
        if (response.success) {
          SnackbarUtils.showSuccess(
            response.message ?? 'Email verified successfully! Please login.',
          );
          Get.offAllNamed(Routes.login);
        } else {
          errorMessage.value = response.message ?? 'Invalid OTP';
          SnackbarUtils.showError(errorMessage.value);
        }
      } else {
        // Forgot password - Reset password
        if (newPasswordController.text.isEmpty) {
          errorMessage.value = 'Please enter a new password';
          isLoading.value = false;
          return;
        }
        final response = await _authRepository.resetPassword(
          ResetPasswordRequest(
            enteredOtp: otpController.text,
            newPassword: newPasswordController.text,
          ),
        );
        if (response.success) {
          SnackbarUtils.showSuccess('Password reset successfully');
          Get.offNamed(Routes.resetPassword, arguments: {'success': true});
        } else {
          errorMessage.value = response.message ?? 'Invalid or expired code';
          SnackbarUtils.showError(errorMessage.value);
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      SnackbarUtils.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _authRepository.resendOtp(email);
      if (response.success) {
        SnackbarUtils.showSuccess('OTP resent successfully!');
      } else {
        errorMessage.value = response.message ?? 'Failed to resend OTP';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Manual disposal of TextEditingControllers in onClose can cause
    // "used after disposed" errors during page transitions in GetX.
    super.onClose();
  }
}
