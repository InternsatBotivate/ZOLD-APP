import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/models/profile_models.dart';

class ChangePasswordController extends GetxController {
  final ProfileRepository _profileRepository;
  ChangePasswordController(this._profileRepository);

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final passwordStrength = 0.obs;

  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final password = newPasswordController.text;
    if (password.isEmpty) {
      passwordStrength.value = 0;
      return;
    }
    int strength = 0;
    if (password.length >= 8) strength += 25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 25;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) strength += 25;
    passwordStrength.value = strength;
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _profileRepository.updatePassword(
        PasswordRequest(
          oldPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        ),
      );
      if (response.success) {
        Get.back();
        SnackbarUtils.showSuccess('Password changed successfully');
      } else {
        errorMessage.value = response.message ?? 'Failed to change password';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
