import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.scaffoldBackgroundColor,
                    theme.colorScheme.surfaceContainerHighest,
                    theme.colorScheme.surface,
                  ]
                : [
                    AppColors.authGradientStart,
                    const Color(0xFF5C4E7F),
                    AppColors.authGradientEnd,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: isDark
                          ? theme.textTheme.bodySmall?.color
                          : Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.slides.length,
                  itemBuilder: (context, index) {
                    final slide = controller.slides[index];
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? theme.colorScheme.primary.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                slide['icon'] as IconData,
                                size: 80,
                                color: isDark
                                    ? theme.colorScheme.primary
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              slide['title'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? theme.colorScheme.onSurface
                                    : Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              slide['description'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? theme.textTheme.bodyMedium?.color
                                    : Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        controller.slides.length,
                        (index) => Obx(
                          () => Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: controller.currentPage.value == index
                                ? 32
                                : 8,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? (isDark
                                        ? theme.colorScheme.primary
                                        : Colors.white)
                                  : (isDark
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.3,
                                          )
                                        : Colors.white.withValues(alpha: 0.4)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? theme.colorScheme.primary
                              : Colors.white,
                          foregroundColor: isDark
                              ? theme.colorScheme.onPrimary
                              : AppColors.authGradientStart,
                          minimumSize: const Size(0, 48),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.currentPage.value ==
                                      controller.slides.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Text(
                      'ZOLD',
                      style: TextStyle(
                        color: isDark
                            ? theme.colorScheme.primary
                            : AppColors.primaryGold,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Gold for GenZ',
                      style: TextStyle(
                        color: isDark
                            ? theme.textTheme.bodySmall?.color
                            : Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
