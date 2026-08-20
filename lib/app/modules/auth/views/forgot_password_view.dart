import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import 'widgets/auth_background.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
            'Reset Password',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Enter your registered email and we'll send you a verification code.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              GetBuilder<ForgotPasswordController>(
                builder: (controller) => TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.sendCode,
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
                      controller.isLoading.value ? 'Sending...' : 'Send Code',
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
          const SizedBox(height: 24),
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
}
