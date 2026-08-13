import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/auth_models.dart';
import '../../../routes/app_routes.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/utils/snackbar_utils.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository;

  SignupController(this._authRepository);

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;
  late final TextEditingController cityController;
  late final TextEditingController referralController;

  final showReferral = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    cityController = TextEditingController();
    referralController = TextEditingController();
  }

  void toggleReferral() {
    showReferral.value = !showReferral.value;
  }

  Future<void> signup() async {
    if (!_validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authRepository.signup(
        SignupRequest(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          username: usernameController.text.trim(),
          password: passwordController.text,
          phone: phoneController.text.trim(),
          city: cityController.text.trim(),
          referralCode: showReferral.value
              ? referralController.text.trim()
              : null,
        ),
      );

      if (response.success) {
        isLoading.value = false;
        final role = response.data?['role'];
        if (role == 'ADMIN') {
          SnackbarUtils.showInfo(
            'Admin account requests need approval. Please check your email.',
          );
          Get.offAllNamed(Routes.login);
        } else {
          Get.toNamed(
            Routes.otpVerification,
            arguments: {'email': emailController.text.trim(), 'type': 'signup'},
          );
        }
      } else {
        errorMessage.value = response.message ?? 'Signup failed';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  bool _validate() {
    final nameError =
        AppValidators.required(nameController.text) ??
        AppValidators.name(nameController.text);
    final emailError = AppValidators.email(emailController.text);
    final usernameError = AppValidators.required(usernameController.text);
    final passwordError = AppValidators.password(passwordController.text);
    final phoneError = AppValidators.phone(phoneController.text);
    final cityError = AppValidators.required(cityController.text);

    if (nameError != null) {
      errorMessage.value = nameError;
      return false;
    }
    if (emailError != null) {
      errorMessage.value = emailError;
      return false;
    }
    if (usernameError != null) {
      errorMessage.value = 'Username is required';
      return false;
    }
    if (passwordError != null) {
      errorMessage.value = passwordError;
      return false;
    }
    if (phoneError != null) {
      errorMessage.value = phoneError;
      return false;
    }
    if (cityError != null) {
      errorMessage.value = 'City is required';
      return false;
    }
    return true;
  }

  void backToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    // Note: Manual disposal of TextEditingControllers in onClose can cause
    // "used after disposed" errors during page transitions in GetX.
    super.onClose();
  }
}
