import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/auth_models.dart';

class KYCStatusView extends GetView<KYCController> {
  const KYCStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KYC Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              'Verify your identity',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final status = AuthService.to.kycStatus;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context, status),
              const SizedBox(height: 24),
              _buildProgressSection(context, status),
              const SizedBox(height: 32),
              _buildDocumentsSection(context, status),
              const SizedBox(height: 32),
              _buildBenefitsSection(context),
              const SizedBox(height: 32),
              _buildRecentActivity(context, status),
              const SizedBox(height: 32),
              _buildAdditionalActions(context, status),
              const SizedBox(height: 24),
              _buildHelpText(context),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(BuildContext context, KycStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color;
    Color bgColor;
    Color borderColor;
    IconData icon;
    String title;
    String description;

    switch (status) {
      case KycStatus.approved:
        color = const Color(0xFF16A34A);
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFFBBF7D0);
        icon = Icons.check_circle_outline;
        title = "KYC Verified";
        description =
            "You can now access all features and higher transaction limits.";
        break;
      case KycStatus.pending:
        color = const Color(0xFFCA8A04);
        bgColor = const Color(0xFFFEF9C3);
        borderColor = const Color(0xFFFEF08A);
        icon = Icons.watch_later_outlined;
        title = "Under Review";
        description =
            "Verification usually takes 24-48 hours. You'll be notified once completed.";
        break;
      case KycStatus.rejected:
        color = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFFECACA);
        icon = Icons.error_outline;
        title = "Rejected";
        description =
            "Your KYC was rejected. Please re-upload valid documents to continue.";
        break;
      default: // Incomplete
        color = const Color(0xFF4B5563);
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        icon = Icons.info_outline;
        title = "Incomplete";
        description =
            "Complete KYC to unlock all features and higher transaction limits.";
    }

    if (isDark) {
      bgColor = bgColor.withValues(alpha: 0.15);
      borderColor = borderColor.withValues(alpha: 0.2);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, KycStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = status == KycStatus.approved
        ? 1.0
        : status == KycStatus.pending
        ? 0.75
        : status == KycStatus.rejected
        ? 0.5
        : 0.25;

    final color = status == KycStatus.approved
        ? const Color(0xFF16A34A)
        : status == KycStatus.pending
        ? const Color(0xFFCA8A04)
        : status == KycStatus.rejected
        ? const Color(0xFFDC2626)
        : const Color(0xFF4B5563);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Verification Progress',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context, KycStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVerified = status == KycStatus.approved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 20,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              'Documents Required',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildDocumentItem(context, 'Aadhaar Card', isVerified),
        const SizedBox(height: 16),
        _buildDocumentItem(context, 'PAN Card', isVerified),
        const SizedBox(height: 16),
        _buildDocumentItem(
          context,
          'Photograph',
          isVerified,
          icon: Icons.camera_alt_outlined,
        ),
        const SizedBox(height: 16),
        _buildDocumentItem(context, 'Address Proof', isVerified),
      ],
    );
  }

  Widget _buildDocumentItem(
    BuildContext context,
    String title,
    bool verified, {
    IconData icon = Icons.file_present_outlined,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white60 : const Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  verified ? 'Verified' : 'Not Uploaded',
                  style: TextStyle(
                    fontSize: 13,
                    color: verified
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          if (verified)
            const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 24)
          else
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.authGradientStart,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon == Icons.camera_alt_outlined
                        ? Icons.photo_camera_outlined
                        : Icons.upload_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    icon == Icons.camera_alt_outlined ? 'Take Photo' : 'Upload',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: Color(0xFF374151),
              ),
              const SizedBox(width: 10),
              Text(
                'Benefits of KYC Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBenefitItem('Higher transaction limits'),
          _buildBenefitItem('Faster withdrawal processing'),
          _buildBenefitItem('Access to premium features'),
          _buildBenefitItem('Enhanced security and fraud protection'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, KycStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show activities only if not incomplete
    if (status == KycStatus.incomplete) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          context,
          'Document Submitted',
          'PAN Card uploaded for verification',
          '2 days ago',
          Icons.description_outlined,
          const Color(0xFF22C55E),
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          context,
          'KYC Process Started',
          'Submitted personal details',
          '5 days ago',
          Icons.person_outline,
          const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalActions(BuildContext context, KycStatus status) {
    if (status != KycStatus.approved) return const SizedBox.shrink();

    return Column(
      children: [
        _buildActionButton(
          context,
          'View Submitted Documents',
          Icons.visibility_outlined,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Download KYC Certificate',
          Icons.file_download_outlined,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white60 : const Color(0xFF374151),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white30 : Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        'Need help with KYC? Contact our support team at support@atplus.com or call 1800-XXX-XXXX. Documents are processed within 24-48 hours.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          height: 1.6,
        ),
      ),
    );
  }
}
