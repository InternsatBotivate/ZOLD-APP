import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/pdf_generator.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  int _activeTabIndex = 0;
  final ScrollController _tabScrollController = ScrollController();

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Overview', 'icon': Icons.shield_outlined},
    {'title': 'Data Collection', 'icon': Icons.storage_outlined},
    {'title': 'Data Usage', 'icon': Icons.visibility_outlined},
    {'title': 'Data Protection', 'icon': Icons.lock_outline},
    {'title': 'Your Rights', 'icon': Icons.person_outline},
    {'title': 'Cookies', 'icon': Icons.notifications_none},
  ];

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

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
              'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const Text(
              'Effective: 7/29/2026',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              PdfGenerator.printLayout(
                title: 'Privacy Policy',
                subtitle: 'Effective: 7/29/2026',
                sections: [
                  {
                    'title': 'Our Commitment',
                    'content':
                        'AT Plus Jewellers is committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our services.',
                  },
                  {
                    'title': 'How We Use Your Information',
                    'content':
                        '- Service Provision: To provide, maintain, and improve our services.\n- Security & Verification: To verify your identity and prevent fraud.\n- Communication: To send important notifications.\n- Legal Compliance: To comply with legal obligations.',
                  },
                ],
              );
            },
            icon: Icon(
              Icons.print_outlined,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          IconButton(
            onPressed: () {
              PdfGenerator.generateAndShare(
                title: 'Privacy Policy',
                subtitle: 'Effective: 7/29/2026',
                sections: [
                  {
                    'title': 'Our Commitment',
                    'content':
                        'AT Plus Jewellers is committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our services.',
                  },
                  {
                    'title': 'How We Use Your Information',
                    'content':
                        '- Service Provision: To provide, maintain, and improve our services.\n- Security & Verification: To verify your identity and prevent fraud.\n- Communication: To send important notifications.\n- Legal Compliance: To comply with legal obligations.',
                  },
                ],
              );
            },
            icon: Icon(
              Icons.download_outlined,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 800;
          final horizontalPadding = isLargeScreen
              ? constraints.maxWidth * 0.1
              : 20.0;

          return Column(
            children: [
              _buildTabHeader(context),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          _buildLastViewedBanner(context),
                          const SizedBox(height: 32),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.05, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                            child: KeyedSubtree(
                              key: ValueKey<int>(_activeTabIndex),
                              child: _buildActiveTabContent(context),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            'This Privacy Policy was last updated on 7/29/2026',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : Colors.white,
                                foregroundColor: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: isDark
                                        ? Colors.white10
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.chevron_left, color: Colors.grey.shade400),
          Expanded(
            child: ListView.builder(
              controller: _tabScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final isActive = _activeTabIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeTabIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF312E81)
                          : (isDark ? Colors.white10 : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: const Color(
                              0xFF312E81,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _tabs[index]['icon'],
                          size: 18,
                          color: isActive
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _tabs[index]['title'],
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black54),
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildLastViewedBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.blue.shade700;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? primaryColor.withValues(alpha: 0.15)
            : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.visibility_outlined,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Viewed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? primaryColor.withValues(alpha: 0.9)
                        : primaryColor,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '7/29/2026',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.blue.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Important',
              style: TextStyle(
                color: isDark
                    ? primaryColor.withValues(alpha: 0.9)
                    : primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(BuildContext context) {
    switch (_activeTabIndex) {
      case 0:
        return _buildOverviewContent(context);
      case 1:
        return _buildDataCollectionContent(context);
      case 2:
        return _buildDataUsageContent(context);
      case 3:
        return _buildDataProtectionContent(context);
      case 4:
        return _buildYourRightsContent(context);
      case 5:
        return _buildCookiesContent(context);
      default:
        return _buildOverviewContent(context);
    }
  }

  Widget _buildOverviewContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _buildContentCard(
          context,
          icon: Icons.shield_outlined,
          iconColor: Colors.purple,
          title: 'Our Commitment',
          content:
              'AT Plus Jewellers is committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our services.',
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSimpleInfo(
                'Scope',
                'Applies to all users of AT Plus Jewellers platform',
                isDark,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSimpleInfo(
                'Compliance',
                'Compliant with Indian data protection regulations',
                isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataCollectionContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildContentCard(
      context,
      title: 'Information We Collect',
      children: [
        _buildUsageItem(
          'Personal Information',
          'Full name, email address, phone number, and date of birth during registration.',
          isDark,
        ),
        _buildUsageItem(
          'KYC Documents',
          'Identity and address proof as required for regulatory compliance.',
          isDark,
        ),
        _buildUsageItem(
          'Financial Data',
          'Bank account details and transaction history related to your purchases.',
          isDark,
        ),
        _buildUsageItem(
          'Device Information',
          'IP address, device type, browser information, and application usage patterns.',
          isDark,
        ),
      ],
    );
  }

  Widget _buildDataUsageContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildContentCard(
      context,
      title: 'How We Use Your Information',
      children: [
        _buildUsageItem(
          'Service Provision',
          'To provide, maintain, and improve our services including order processing, account management, and customer support.',
          isDark,
        ),
        _buildUsageItem(
          'Security & Verification',
          'To verify your identity, prevent fraud, detect security incidents, and protect against malicious activity.',
          isDark,
        ),
        _buildUsageItem(
          'Communication',
          'To send important notifications, updates, and marketing communications (with your consent).',
          isDark,
        ),
        _buildUsageItem(
          'Legal Compliance',
          'To comply with legal obligations, regulatory requirements, and government requests.',
          isDark,
        ),
      ],
    );
  }

  Widget _buildDataProtectionContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _buildContentCard(
          context,
          icon: Icons.lock_outline,
          iconColor: Colors.green,
          title: 'Security Measures',
          children: [
            _buildColoredCard(
              'Encryption',
              'All sensitive data is encrypted using industry-standard AES-256 encryption both in transit and at rest.',
              Colors.green,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildColoredCard(
              'Access Controls',
              'Strict access controls and authentication mechanisms ensure only authorized personnel can access your data.',
              Colors.blue,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildColoredCard(
              'Regular Audits',
              'Regular security audits and vulnerability assessments to maintain the highest security standards.',
              Colors.purple,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildColoredCard(
              'Data Retention',
              'We retain your personal data only as long as necessary for the purposes outlined in this policy or as required by law.',
              Colors.orange,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYourRightsContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildContentCard(
      context,
      title: 'Your Rights & Choices',
      children: [
        _buildNumberedRight(
          '1',
          'Access & Rectification',
          'Right to access your personal data and request corrections if inaccurate.',
          Colors.blue.shade700,
          isDark,
        ),
        _buildNumberedRight(
          '2',
          'Data Portability',
          'Right to receive your data in a structured, commonly used format.',
          Colors.green.shade700,
          isDark,
        ),
        _buildNumberedRight(
          '3',
          'Right to Erasure',
          'Right to request deletion of your personal data under certain circumstances.',
          Colors.red.shade700,
          isDark,
        ),
        _buildNumberedRight(
          '4',
          'Consent Withdrawal',
          'Right to withdraw consent for data processing at any time.',
          Colors.purple.shade700,
          isDark,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'To exercise any of these rights, please contact our Data Protection Officer at privacy@atplusjewellers.com',
            style: TextStyle(
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCookiesContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _buildContentCard(
          context,
          icon: Icons.cookie_outlined,
          iconColor: Colors.orange,
          title: 'Cookies & Tracking',
          children: [
            _buildUsageItem(
              'Essential Cookies',
              'Required for basic functionality like authentication and security. Cannot be disabled.',
              isDark,
            ),
            _buildUsageItem(
              'Analytics Cookies',
              'Help us understand how users interact with our platform to improve user experience.',
              isDark,
            ),
            _buildUsageItem(
              'Marketing Cookies',
              'Used to deliver relevant advertisements and track campaign performance. You can opt-out.',
              isDark,
            ),
            _buildUsageItem(
              'Cookie Management',
              'You can manage cookie preferences through your browser settings or our privacy controls.',
              isDark,
            ),
            const SizedBox(height: 16),
            _buildContactInfoBox(context),
          ],
        ),
      ],
    );
  }

  Widget _buildContentCard(
    BuildContext context, {
    IconData? icon,
    Color? iconColor,
    required String title,
    String? content,
    List<Widget>? children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.blue).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          if (content != null)
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: isDark ? Colors.white70 : const Color(0xFF4B5563),
              ),
            ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildSimpleInfo(String title, String description, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isDark ? Colors.white60 : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageItem(String title, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white60 : const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredCard(
    String title,
    String content,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color.withValues(alpha: isDark ? 0.9 : 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedRight(
    String number,
    String title,
    String description,
    Color color,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : const Color(0xFF4B5563),
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

  Widget _buildContactInfoBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            'For privacy-related inquiries or concerns:',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : const Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 20),
          _buildSmallInfoRow('Email:', 'privacy@atplusjewellers.com', isDark),
          _buildSmallInfoRow('Phone:', '+91 22-XXXX-XXXX', isDark),
          _buildSmallInfoRow(
            'Address:',
            'Data Protection Officer, AT Plus Jewellers, Mumbai',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white60 : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
