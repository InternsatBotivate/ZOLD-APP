import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import 'widgets/auth_background.dart';
import '../../../core/theme/app_colors.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AuthBackground(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/02.png', height: 80, fit: BoxFit.contain),
          const SizedBox(height: 24),
          Obx(
            () => controller.errorMessage.isNotEmpty
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.error.withValues(alpha: 0.1)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? theme.colorScheme.error.withValues(alpha: 0.3)
                            : const Color(0xFFFFCDD2),
                      ),
                    ),
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            context,
            'Full Name *',
            controller.nameController,
            'Enter full name',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            'Email Address *',
            controller.emailController,
            'Enter email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            'Username *',
            controller.usernameController,
            'Choose a username',
          ),
          const SizedBox(height: 16),
          // Special handling for password field with visibility toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: theme.textTheme.bodySmall?.color,
                        size: 20,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone Number *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surfaceContainerHighest
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+91',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '10 digit number',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            'City *',
            controller.cityController,
            'Enter your city',
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.showReferral.value
                ? _buildTextField(
                    context,
                    'Referral Code (Optional)',
                    controller.referralController,
                    'Enter code',
                    textCapitalization: TextCapitalization.characters,
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: controller.toggleReferral,
                      child: Text(
                        'Have a referral code?',
                        style: TextStyle(
                          color: isDark
                              ? theme.colorScheme.primary
                              : AppColors.authGradientStart,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? theme.colorScheme.primary
                      : AppColors.authGradientStart,
                  foregroundColor: isDark
                      ? theme.colorScheme.onPrimary
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.isLoading.value ? 'Sending OTP...' : 'Get OTP',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (controller.isLoading.value)
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: isDark
                              ? theme.colorScheme.onPrimary
                              : Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: controller.backToLogin,
            child: Text(
              'Back to Login',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController textController,
    String hint, {
    bool obscureText = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
          ),
        ),
      ],
    );
  }
}
