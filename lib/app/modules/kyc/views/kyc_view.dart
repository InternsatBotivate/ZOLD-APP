import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';
import '../../../core/theme/app_colors.dart';

class KYCView extends GetView<KYCController> {
  const KYCView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.step.value) {
        case 'intro':
          return _buildIntro(context);
        case 'pan':
          return _buildStepLayout(
            context: context,
            title: 'PAN Card Details',
            subtitle: 'Enter your PAN card information',
            content: _buildPanForm(context),
            onContinue: controller.isPanValid ? controller.goToAadhaar : null,
          );
        case 'aadhaar':
          return _buildStepLayout(
            context: context,
            title: 'Aadhaar Card',
            subtitle: 'Upload your Aadhaar card for identity verification',
            content: _buildAadhaarForm(context),
            onContinue: controller.isAadhaarValid ? controller.submitKYC : null,
            buttonText: 'Submit for Verification',
          );
        case 'complete':
          return _buildComplete(context);
        default:
          return const SizedBox.shrink();
      }
    });
  }

  Widget _buildIntro(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: controller.skipKYC,
                icon: Icon(Icons.close, color: theme.iconTheme.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.bgDarkSecondary
                          : const Color(0xFFF3F1F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 64,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Complete KYC', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(
                    'Verify your identity to unlock all features and higher transaction limits.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  _buildFeatureItem(
                    context,
                    'Higher Transaction Limits',
                    'Buy and sell larger amounts of gold',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureItem(
                    context,
                    'Faster Withdrawals',
                    'Quick and secure money transfers',
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: controller.startKYC,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Complete KYC Now'),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: controller.skipKYC,
                    child: Text(
                      'Skip, Do Later',
                      style: TextStyle(color: theme.textTheme.bodySmall?.color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: AppColors.success, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLayout({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget content,
    VoidCallback? onContinue,
    String buttonText = 'Continue',
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('KYC Verification'),
        actions: [
          TextButton(onPressed: controller.skipKYC, child: const Text('Skip')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: List.generate(
                    controller.totalSteps,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index == controller.totalSteps - 1 ? 0 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: index < controller.currentStepNumber
                              ? AppColors.primaryGold
                              : (isDark
                                    ? AppColors.borderDark
                                    : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step ${controller.currentStepNumber} of ${controller.totalSteps}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.bgDarkSecondary
                          : const Color(0xFFF3F1F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.upload_file_outlined,
                      size: 32,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  content,
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: onContinue,
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PAN Number', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => controller.panNumber.value = v.toUpperCase(),
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
          decoration: const InputDecoration(
            counterText: '',
            hintText: 'ABCDE1234F',
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Name as per PAN',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => controller.panName.value = v,
          decoration: const InputDecoration(hintText: 'Enter name'),
        ),
        const SizedBox(height: 24),
        const Text(
          'Upload PAN Card',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        _buildUploadBox(
          context,
          controller.panFileName,
          controller.pickDocument,
        ),
      ],
    );
  }

  Widget _buildAadhaarForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aadhaar Number',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => controller.aadhaarNumber.value = v,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: const InputDecoration(
            counterText: '',
            hintText: 'XXXX XXXX XXXX',
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Upload Aadhaar Card',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        _buildUploadBox(
          context,
          controller.aadhaarFileName,
          controller.pickDocument,
        ),
      ],
    );
  }

  Widget _buildUploadBox(
    BuildContext context,
    RxString fileName,
    Function(RxString) onUpload,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onUpload(fileName),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : Colors.grey[50],
          border: Border.all(color: theme.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Obx(
              () => fileName.value.isEmpty
                  ? Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: theme.dividerColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Click to upload',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'PNG, JPG (max. 5MB)',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 40,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          fileName.value,
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Click to change',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplete(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                      : const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 80,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text('KYC Submitted!', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Your documents are under review. Verification usually takes 24-48 hours.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: controller.completeKYC,
                child: const Text('Continue to App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
