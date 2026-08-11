import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class SnackbarUtils {
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 24),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      dismissDirection: DismissDirection.vertical,
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.info_outline, color: Colors.white, size: 24),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      dismissDirection: DismissDirection.vertical,
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
      duration: const Duration(seconds: 5),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      dismissDirection: DismissDirection.vertical,
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }
}
