import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';
import '../../../core/theme/app_colors.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => controller.errorMessage.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[100]!),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            _buildTextField(
              'Current Password',
              controller.currentPasswordController,
              'Enter current password',
              controller.showCurrentPassword,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              'New Password',
              controller.newPasswordController,
              'Enter new password',
              controller.showNewPassword,
            ),
            const SizedBox(height: 12),
            _buildStrengthMeter(),
            const SizedBox(height: 24),
            _buildTextField(
              'Confirm New Password',
              controller.confirmPasswordController,
              'Confirm new password',
              controller.showConfirmPassword,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authGradientStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController textController,
    String hint,
    RxBool showPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: textController,
            obscureText: !showPassword.value,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => showPassword.value = !showPassword.value,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthMeter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password strength:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Obx(
              () => Text(
                _getStrengthText(controller.passwordStrength.value),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getStrengthColor(controller.passwordStrength.value),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => LinearProgressIndicator(
            value: controller.passwordStrength.value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStrengthColor(controller.passwordStrength.value),
            ),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 12),
        _buildStrengthRule(
          'At least 8 characters',
          controller.newPasswordController.text.length >= 8,
        ),
        _buildStrengthRule(
          'One uppercase letter',
          controller.newPasswordController.text.contains(RegExp(r'[A-Z]')),
        ),
        _buildStrengthRule(
          'One number',
          controller.newPasswordController.text.contains(RegExp(r'[0-9]')),
        ),
        _buildStrengthRule(
          'One special character',
          controller.newPasswordController.text.contains(
            RegExp(r'[^A-Za-z0-9]'),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthRule(String rule, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            size: 12,
            color: isValid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            rule,
            style: TextStyle(
              fontSize: 11,
              color: isValid ? Colors.green : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getStrengthText(int strength) {
    if (strength < 25) return 'Very Weak';
    if (strength < 50) return 'Weak';
    if (strength < 75) return 'Good';
    if (strength < 100) return 'Strong';
    return 'Very Strong';
  }

  Color _getStrengthColor(int strength) {
    if (strength < 50) return Colors.red;
    if (strength < 75) return Colors.yellow[700]!;
    return Colors.green;
  }
}
