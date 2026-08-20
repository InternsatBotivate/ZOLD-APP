import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_verification_controller.dart';
import 'widgets/auth_background.dart';
import '../../../core/theme/app_colors.dart';

class OTPVerificationView extends GetView<OTPVerificationController> {
  const OTPVerificationView({super.key});

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
            controller.type == 'signup' ? 'Verify OTP' : 'Set New Password',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (controller.type == 'signup')
            Text(
              'Enter the 6-digit code sent to\n${controller.email}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                "If ${controller.email} is registered with us, we've sent a 6-digit code to that address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              GetBuilder<OTPVerificationController>(
                builder: (controller) => TextField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 12,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '------',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (controller.type == 'forgot_password') ...[
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => TextField(
                    controller: controller.newPasswordController,
                    obscureText: controller.obscurePassword.value,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
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
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.resendOtp,
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  color: isDark
                      ? theme.colorScheme.primary
                      : AppColors.authGradientStart,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.verify,
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
                      controller.isLoading.value
                          ? (controller.type == 'signup'
                              ? 'Verifying...'
                              : 'Resetting...')
                          : (controller.type == 'signup'
                              ? 'Verify'
                              : 'Reset Password'),
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
        ],
      ),
    );
  }
}
