import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class LanguagesView extends StatelessWidget {
  const LanguagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedLanguage = 'English'.obs;

    final languages = [
      {'name': 'English', 'native': 'English'},
      {'name': 'Hindi', 'native': 'हिन्दी'},
      {'name': 'Marathi', 'native': 'मराठी'},
      {'name': 'Gujarati', 'native': 'ગુજરાતી'},
      {'name': 'Bengali', 'native': 'বাংলা'},
      {'name': 'Tamil', 'native': 'தமிழ்'},
      {'name': 'Telugu', 'native': 'తెలుగు'},
      {'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
      {'name': 'Malayalam', 'native': 'മലയാളം'},
      {'name': 'Spanish', 'native': 'Español'},
      {'name': 'French', 'native': 'Français'},
      {'name': 'German', 'native': 'Deutsch'},
    ];

    // Define colors based on design
    final primaryColor = const Color(0xFF3D3066); // Using authGradientStart
    final selectedBg = primaryColor.withValues(alpha: 0.08);
    final iconBg = primaryColor.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 60,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Language Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const Text(
              'Choose your preferred language',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Current Language Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.language,
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
                                'Current Language',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                              const Text(
                                'English',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'US',
                          style: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.1),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Available Languages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Language List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      return Obx(() {
                        final isSelected =
                            selectedLanguage.value == lang['name'];
                        return GestureDetector(
                          onTap: () => selectedLanguage.value = lang['name']!,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                        ? primaryColor.withValues(alpha: 0.15)
                                        : selectedBg)
                                  : (isDark
                                        ? AppColors.bgDarkSecondary
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark
                                          ? AppColors.borderDark
                                          : const Color(0xFFE5E7EB)),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang['name']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF111827),
                                        ),
                                      ),
                                      Text(
                                        lang['native']!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isSelected
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.withValues(
                                              alpha: 0.4,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? AppColors.borderDark
                      : const Color(0xFFF3F4F6),
                  width: 1,
                ),
              ),
            ),
            child: OutlinedButton(
              onPressed: () {
                selectedLanguage.value = 'English';
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Reset to Default Settings',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
