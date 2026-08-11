import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class FAQItem {
  final int id;
  final String question;
  final String answer;
  final String category;
  final List<String> tags;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.tags,
  });
}

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  String searchQuery = '';
  String activeCategory = 'all';
  final List<int> expandedIds = [];

  final List<FAQItem> faqs = [
    FAQItem(
      id: 1,
      category: 'account',
      question: 'How do I create an account?',
      answer:
          "To create an account, download the AT Plus Jewellers app from the App Store or Google Play Store. Open the app and tap on 'Sign Up'. Enter your mobile number, verify it with the OTP, and complete your profile with basic details. You'll need to complete KYC verification to access all features.",
      tags: ['account', 'setup'],
    ),
    FAQItem(
      id: 2,
      category: 'kyc',
      question: 'What documents are required for KYC?',
      answer:
          "For KYC verification, you need:\n1. PAN Card (mandatory)\n2. Aadhaar Card (mandatory)\n3. Recent passport-size photograph\n4. Proof of address (if different from Aadhaar)\n\nAll documents should be clear, valid, and not expired. Ensure the name matches across all documents.",
      tags: ['kyc', 'verification', 'documents'],
    ),
    FAQItem(
      id: 3,
      category: 'kyc',
      question: 'How long does KYC verification take?',
      answer:
          "KYC verification typically takes 24-48 hours during business days. In some cases, it may take up to 72 hours. You'll receive notifications about the status of your verification. You can check your KYC status in the Profile section under 'KYC Status'.",
      tags: ['kyc', 'verification', 'time'],
    ),
    FAQItem(
      id: 4,
      category: 'transactions',
      question: 'How do I buy gold?',
      answer:
          "To buy gold:\n1. Go to the 'Buy Gold' section\n2. Choose the weight (grams) or amount (₹)\n3. Select payment method\n4. Review order details\n5. Confirm purchase\n\nYou can buy gold starting from as low as ₹100. The gold is stored securely in our vaults and allocated to your account.",
      tags: ['buy', 'gold', 'purchase'],
    ),
    FAQItem(
      id: 5,
      category: 'transactions',
      question: 'How do I sell gold?',
      answer:
          "To sell gold:\n1. Go to the 'Sell Gold' section\n2. Select the quantity you want to sell\n3. Choose bank account for payout\n4. Review current gold rate and estimated amount\n5. Confirm sale\n\nFunds are typically transferred within 2 Working Days to your registered bank account.",
      tags: ['sell', 'gold', 'withdrawal'],
    ),
    FAQItem(
      id: 6,
      category: 'transactions',
      question: 'Are there any transaction fees?',
      answer:
          "We charge:\n• Buying gold: 2% making charges (included in price)\n• Selling gold: 1% transaction fee\n• Storage: Free for first year, ₹99/year thereafter\n• No hidden charges\nAll fees are clearly displayed before you confirm any transaction.",
      tags: ['fees', 'charges', 'cost'],
    ),
    FAQItem(
      id: 7,
      category: 'security',
      question: 'How secure is my gold?',
      answer:
          "Your gold is:\n1. Insured for 100% value\n2. Stored in RBI-approved vaults\n3. Audited regularly\n4. Allocated specifically to your account\n\nWe maintain complete transparency about storage locations and insurance coverage. You can request a physical audit report.",
      tags: ['security', 'storage', 'insurance'],
    ),
    FAQItem(
      id: 8,
      category: 'security',
      question: 'What happens if I lose my phone?',
      answer:
          "If you lose your phone:\n1. Immediately contact our support team\n2. We'll temporarily freeze your account\n3. You'll need to verify identity for reactivation\n4. All sessions will be logged out\n\nEnable biometric authentication for added security. Your gold remains safe even if your phone is lost.",
      tags: ['security', 'lost', 'phone'],
    ),
    FAQItem(
      id: 9,
      category: 'account',
      question: 'How do I change my mobile number?',
      answer:
          "To change mobile number:\n1. Go to Profile → Personal Information\n2. Tap on phone number\n3. Enter new number\n4. Verify with OTP sent to new number\n5. Complete verification\n\nThis requires additional verification for security. You may need to provide supporting documents.",
      tags: ['account', 'mobile', 'update'],
    ),
    FAQItem(
      id: 10,
      category: 'account',
      question: 'Can I have multiple bank accounts?',
      answer:
          "Yes, you can add up to 3 bank accounts:\n1. Go to Profile → Bank Accounts\n2. Tap 'Add Bank Account'\n3. Enter bank details\n4. Verify with micro-deposit\n\nOnly verified bank accounts can be used for transactions. You can set one as primary for withdrawals.",
      tags: ['bank', 'accounts', 'withdrawal'],
    ),
    FAQItem(
      id: 11,
      category: 'account',
      question: 'Is there a minimum balance requirement?',
      answer:
          "No, there's no minimum balance requirement. You can start with as little as ₹100. There's no minimum holding period either - you can buy and sell as per market conditions. However, frequent trading is not recommended as gold is a long-term investment.",
      tags: ['minimum', 'balance', 'investment'],
    ),
    FAQItem(
      id: 12,
      category: 'security',
      question: 'How do I update my email address?',
      answer:
          "To update email:\n1. Go to Profile → Personal Information\n2. Tap on email address\n3. Enter new email\n4. Verify with OTP sent to new email\n\nEmail updates require verification for security. You'll receive notifications at both old and new email addresses during the transition period.",
      tags: ['email', 'update', 'security'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filtered = faqs.where((f) {
      final matchesSearch =
          f.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
          f.answer.toLowerCase().contains(searchQuery.toLowerCase()) ||
          f.tags.any(
            (t) => t.toLowerCase().contains(searchQuery.toLowerCase()),
          );
      final matchesCategory =
          activeCategory == 'all' || f.category == activeCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(context),
                    const SizedBox(height: 8),
                    _buildCategoriesHeader(context),
                    _buildCategories(context),
                    const SizedBox(height: 32),
                    Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (filtered.isEmpty)
                      _buildEmptyState(context)
                    else
                      ...filtered.map((faq) => _buildFAQCard(context, faq)),
                    const SizedBox(height: 32),
                    _buildContactSupportCard(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FAQ & Help Center',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                Text(
                  'Find answers to common questions',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF4D3F7F).withValues(alpha: 0.3)
                  : const Color(0xFF3D3066).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline,
              color: isDark ? const Color(0xFF8B7FA8) : const Color(0xFF3D3066),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFD1D5DB),
        ),
      ),
      child: TextField(
        onChanged: (val) => setState(() => searchQuery = val),
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Search questions...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                  onPressed: () => setState(() => searchQuery = ''),
                )
              : null,
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoriesHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        'Browse by Category',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = [
      {'id': 'all', 'name': 'All Questions', 'count': faqs.length},
      {
        'id': 'account',
        'name': 'Account',
        'count': faqs.where((f) => f.category == 'account').length,
      },
      {
        'id': 'transactions',
        'name': 'Transactions',
        'count': faqs.where((f) => f.category == 'transactions').length,
      },
      {
        'id': 'security',
        'name': 'Security',
        'count': faqs.where((f) => f.category == 'security').length,
      },
      {
        'id': 'kyc',
        'name': 'KYC',
        'count': faqs.where((f) => f.category == 'kyc').length,
      },
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: categories.map((c) {
        final isSelected = activeCategory == c['id'];
        return GestureDetector(
          onTap: () => setState(() => activeCategory = c['id'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3D3066)
                  : (isDark
                        ? AppColors.bgDarkSecondary
                        : const Color(0xFFF3F4F6)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c['name'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${c['count']}',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.7)
                        : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline,
            size: 64,
            color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 24),
          Text(
            'No questions found matching "$searchQuery"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or contact support',
            style: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, FAQItem faq) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isExpanded = expandedIds.contains(faq.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedIds.remove(faq.id);
                } else {
                  expandedIds.add(faq.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF4D3F7F).withValues(alpha: 0.3)
                                : const Color(
                                    0xFF3D3066,
                                  ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            faq.category.capitalizeFirst ?? faq.category,
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF8B7FA8)
                                  : const Color(0xFF3D3066),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          faq.question,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq.answer,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: faq.tags
                        .map((tag) => _buildTag(context, tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          color: isDark ? Colors.white38 : const Color(0xFF6B7280),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildContactSupportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D3066), Color(0xFF5C4E7F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Our support team is available 24/7',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.help_outline, color: Colors.white38, size: 32),
            ],
          ),
          const SizedBox(height: 24),
          _buildSupportOption(
            context,
            icon: Icons.phone_outlined,
            title: 'Call Support',
            subtitle: '1800-XXX-XXXX',
            onTap: () => _launchURL('tel:+911234567890'),
          ),
          _buildSupportOption(
            context,
            icon: Icons.chat_outlined,
            title: 'Chat Support',
            subtitle: 'Instant messaging',
            onTap: () => _launchURL('https://wa.me/+911234567890?text=Hello'),
          ),
          _buildSupportOption(
            context,
            icon: Icons.mail_outline,
            title: 'Email Support',
            subtitle: 'support@atplusjewellers.com',
            onTap: () => _launchURL('mailto:support@atplusjewellers.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.open_in_new, color: Colors.white70, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
