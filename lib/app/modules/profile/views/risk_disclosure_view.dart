import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/pdf_generator.dart';

class RiskDisclosureView extends StatefulWidget {
  const RiskDisclosureView({super.key});

  @override
  State<RiskDisclosureView> createState() => _RiskDisclosureViewState();
}

class _RiskDisclosureViewState extends State<RiskDisclosureView> {
  bool acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Disclosure',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            Text(
              'Important - Please read carefully',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          _buildAppBarAction(Icons.print_outlined, isDark, () {
            PdfGenerator.printLayout(
              title: 'Risk Disclosure',
              subtitle: 'Important - Please read carefully',
              isAcknowledged: acknowledged,
              sections: [
                {
                  'title': 'Introduction',
                  'content':
                      'This document outlines the key risks associated with purchasing, holding, and selling jewelry through AT Plus Jewellers. By using our services, you acknowledge these risks.',
                },
                {
                  'title': 'Market Risk',
                  'content':
                      'Jewelry prices fluctuate based on gold/silver market prices, demand, and economic conditions.',
                },
                {
                  'title': 'Valuation Risk',
                  'content':
                      'Appraisal values may differ from actual resale/market values at time of sale.',
                },
                {
                  'title': 'Regulatory Risk',
                  'content':
                      'Changes in laws, taxes, or regulations may affect jewelry transactions.',
                },
                {
                  'title': 'Key Considerations',
                  'content':
                      '- Invest only what you can afford to hold long-term\n- Get independent valuations for high-value items\n- Maintain proper insurance coverage\n- Diversify your investments beyond jewelry',
                },
              ],
            );
          }),
          _buildAppBarAction(Icons.download_outlined, isDark, () {
            PdfGenerator.generateAndShare(
              title: 'Risk Disclosure',
              subtitle: 'Important - Please read carefully',
              isAcknowledged: acknowledged,
              sections: [
                {
                  'title': 'Introduction',
                  'content':
                      'This document outlines the key risks associated with purchasing, holding, and selling jewelry through AT Plus Jewellers. By using our services, you acknowledge these risks.',
                },
                {
                  'title': 'Market Risk',
                  'content':
                      'Jewelry prices fluctuate based on gold/silver market prices, demand, and economic conditions.',
                },
                {
                  'title': 'Valuation Risk',
                  'content':
                      'Appraisal values may differ from actual resale/market values at time of sale.',
                },
                {
                  'title': 'Regulatory Risk',
                  'content':
                      'Changes in laws, taxes, or regulations may affect jewelry transactions.',
                },
                {
                  'title': 'Key Considerations',
                  'content':
                      '- Invest only what you can afford to hold long-term\n- Get independent valuations for high-value items\n- Maintain proper insurance coverage\n- Diversify your investments beyond jewelry',
                },
              ],
            );
          }),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningBanner(context),
            const SizedBox(height: 16),
            if (acknowledged)
              _buildStatusBanner(
                context,
                'Risk Disclosure Acknowledged',
                'Date: ${DateFormat.yMd().format(DateTime.now())}',
                const Color(0xFFF0FDF4),
                const Color(0xFF15803D),
                Icons.check_circle,
              )
            else
              _buildStatusBanner(
                context,
                'Not Acknowledged',
                'Please read and acknowledge below',
                const Color(0xFFFFFBEB),
                const Color(0xFF92400E),
                Icons.cancel_outlined,
              ),
            const SizedBox(height: 24),
            _buildIntroduction(context),
            const SizedBox(height: 24),
            _buildRiskItem(
              context,
              'Market Risk',
              'Jewelry prices fluctuate based on gold/silver market prices, demand, and economic conditions.',
              const Color(0xFFFEF2F2),
              const Color(0xFFDC2626),
              Icons.warning_amber_rounded,
            ),
            _buildRiskItem(
              context,
              'Valuation Risk',
              'Appraisal values may differ from actual resale/market values at time of sale.',
              const Color(0xFFFEF2F2),
              const Color(0xFFDC2626),
              Icons.info_outline_rounded,
            ),
            _buildRiskItem(
              context,
              'Regulatory Risk',
              'Changes in laws, taxes, or regulations may affect jewelry transactions.',
              const Color(0xFFEFF6FF),
              const Color(0xFF2563EB),
              Icons.info_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildKeyPoints(context),
            const SizedBox(height: 24),
            _buildDisclaimer(context),
            const SizedBox(height: 32),
            if (!acknowledged) ...[
              _buildPrimaryButton(
                'I Understand & Accept Risks',
                _showSuccessDialog,
              ),
              const SizedBox(height: 12),
              _buildSecondaryButton("I'll Read Later", () => Get.back()),
            ],
            const SizedBox(height: 40),
            Center(
              child: Text(
                'AT Plus Jewellers • Risk Disclosure v1.0',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarAction(
    IconData icon,
    bool isDark,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isDark ? Colors.white70 : Colors.black87,
          size: 20,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Widget _buildWarningBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF450A0A).withValues(alpha: 0.3)
            : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFB91C1C),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Important Notice',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB91C1C),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Investing in jewelry involves risks. Please understand all risks before proceeding.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFFB91C1C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(
    BuildContext context,
    String title,
    String subtitle,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? bgColor.withValues(alpha: 0.1) : bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon == Icons.cancel_outlined ? Icons.cancel : icon,
            color: textColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Text(
        'This document outlines the key risks associated with purchasing, holding, and selling jewelry through AT Plus Jewellers. By using our services, you acknowledge these risks.',
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: isDark ? Colors.white70 : const Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildRiskItem(
    BuildContext context,
    String title,
    String content,
    Color iconBgColor,
    Color iconColor,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? iconBgColor.withValues(alpha: 0.2) : iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = const Color(0xFF1E40AF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E3A8A).withValues(alpha: 0.2)
            : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Considerations',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? const Color(0xFF60A5FA) : primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckItem(
            context,
            'Invest only what you can afford to hold long-term',
            isDark,
          ),
          _buildCheckItem(
            context,
            'Get independent valuations for high-value items',
            isDark,
          ),
          _buildCheckItem(
            context,
            'Maintain proper insurance coverage',
            isDark,
          ),
          _buildCheckItem(
            context,
            'Diversify your investments beyond jewelry',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text, bool isDark) {
    final blueColor = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF2563EB);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: blueColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : const Color(0xFF1E40AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Text(
        'This disclosure does not cover all risks. Market conditions change, and past performance doesn\'t guarantee future results. Consider seeking independent financial advice.',
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF3D3066,
          ), // Dark Purple from screenshot
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF374151),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    setState(() {
      acknowledged = true;
    });
    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                'Risk Disclosure Acknowledged',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for reviewing the risks. You may now proceed.',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
