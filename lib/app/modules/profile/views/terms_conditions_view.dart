import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pdf_generator.dart';

class TermsConditionsView extends StatefulWidget {
  const TermsConditionsView({super.key});

  @override
  State<TermsConditionsView> createState() => _TermsConditionsViewState();
}

class _TermsConditionsViewState extends State<TermsConditionsView> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const Text(
              'Last updated: 7/29/2026',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: OutlinedButton(
              onPressed: () {
                PdfGenerator.generateAndShare(
                  title: 'Terms & Conditions',
                  subtitle: 'Last updated: 7/29/2026',
                  isAcknowledged: accepted,
                  sections: [
                    {
                      'title': '1. Acceptance of Terms',
                      'content':
                          'By accessing and using AT Plus Jewellers\' services, you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, you must not use our services.',
                    },
                    {
                      'title': '2. Account Registration',
                      'content':
                          'You must provide accurate, current, and complete information during registration and keep your account information updated.\n- You are responsible for maintaining the confidentiality of your account\n- You must be at least 18 years old to create an account\n- One account per individual is allowed',
                    },
                    {
                      'title': '8. Changes to Terms',
                      'content':
                          'We reserve the right to modify these terms at any time. We will notify users of any changes. Continued use of our services after changes constitutes acceptance.',
                    },
                    {
                      'title': 'Jurisdiction',
                      'content':
                          'In accordance with the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts in Mumbai.',
                    },
                  ],
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                side: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Download',
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 700;
          final horizontalPadding = isLargeScreen
              ? constraints.maxWidth * 0.15
              : 20.0;

          return Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      accepted ? 40 : 160,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedBanner(context),
                        const SizedBox(height: 32),
                        _buildSectionList(context),
                        const SizedBox(height: 16),
                        _buildContactInfo(context),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              if (!accepted)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomActions(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildStatusBanner(
        context,
        !accepted ? 'Please read and accept' : 'Terms Accepted',
        !accepted
            ? 'You need to accept Terms & Conditions to continue'
            : 'You have already accepted our terms and conditions.',
        !accepted
            ? (isDark ? const Color(0xFF451A03) : const Color(0xFFFFFBEB))
            : (isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5)),
        !accepted
            ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E))
            : (isDark ? const Color(0xFF34D399) : const Color(0xFF065F46)),
        !accepted ? Icons.info_outline : Icons.check_circle_outline,
      ),
    );
  }

  Widget _buildSectionList(BuildContext context) {
    return Column(
      children: [
        _buildTermSection(
          context,
          '1. Acceptance of Terms',
          'By accessing and using AT Plus Jewellers\' services, you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, you must not use our services.',
          icon: Icons.description_outlined,
          delay: 200,
        ),
        _buildTermSection(
          context,
          '2. Account Registration',
          'You must provide accurate, current, and complete information during registration and keep your account information updated.',
          bullets: [
            'You are responsible for maintaining the confidentiality of your account',
            'You must be at least 18 years old to create an account',
            'One account per individual is allowed',
          ],
          delay: 300,
        ),
        _buildTermSection(
          context,
          '8. Changes to Terms',
          'We reserve the right to modify these terms at any time. We will notify users of any changes. Continued use of our services after changes constitutes acceptance.',
          delay: 400,
        ),
        _buildTermSection(
          context,
          '',
          'in accordance with the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts in Mumbai.',
          delay: 500,
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 24),
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
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermSection(
    BuildContext context,
    String title,
    String content, {
    IconData? icon,
    List<String>? bullets,
    int delay = 0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : Colors.grey.shade200,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 22,
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: isDark ? Colors.white70 : const Color(0xFF4B5563),
              ),
            ),
            if (bullets != null) ...[
              const SizedBox(height: 20),
              ...bullets.map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          bullet,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF4B5563),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueStyle = TextStyle(
      fontSize: 15,
      height: 1.6,
      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'For questions about these Terms & Conditions, please contact us at:',
            style: valueStyle,
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Email:', 'legal@atplusjewellers.com', isDark),
          _buildInfoRow('Phone:', '1800-XXX-XXXX', isDark),
          _buildInfoRow('Address:', 'AT Plus Jewellers, Mumbai, India', isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF374151),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: (isDark ? Colors.black : Colors.white).withValues(
              alpha: 0.8,
            ),
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          accepted = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF312E81),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: const Color(
                          0xFF312E81,
                        ).withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'Accept Terms & Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'I\'ll Read Later',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
