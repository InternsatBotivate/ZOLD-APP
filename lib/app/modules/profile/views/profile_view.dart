import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/auth_models.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        // Ensure listeners are registered at the top level
        AuthService.to.user.value;
        AuthService.to.kycStatus;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildSection(context, 'Account', [
                      _buildMenuItem(
                        context,
                        Icons.person_outline,
                        'Personal Information',
                        () => Get.toNamed(Routes.personalInformation),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.shield_outlined,
                        'KYC Status',
                        () {
                          final status = AuthService.to.kycStatus;
                          if (status == KycStatus.approved ||
                              status == KycStatus.pending) {
                            Get.toNamed(Routes.kycStatus);
                          } else {
                            Get.toNamed(Routes.kyc);
                          }
                        },
                        trailing: _buildKYCBadge(),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.location_on_outlined,
                        'Saved Addresses',
                        () => Get.toNamed(Routes.savedAddresses),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection(context, 'Settings', [
                      _buildMenuItem(
                        context,
                        Icons.palette_outlined,
                        'Theme',
                        () => _showThemeSelectionSheet(context),
                        value: controller.currentThemeMode.name.capitalizeFirst,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.notifications_none_outlined,
                        'Notifications',
                        () => Get.toNamed(Routes.notificationsSettings),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.lock_outline,
                        'Security & Privacy',
                        () => Get.toNamed(Routes.securitySettings),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.language_outlined,
                        'Languages',
                        () => Get.toNamed(Routes.languages),
                        value: 'English',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection(context, 'Help & Support', [
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'FAQ',
                        () => Get.toNamed(Routes.faq),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'Chat Support',
                        controller.openChatSupport,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.help_outline,
                        'Call Support',
                        controller.openCallSupport,
                        value: '1800-XXX-XXXX',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSection(context, 'Legal', [
                      _buildMenuItem(
                        context,
                        Icons.description_outlined,
                        'Terms & Conditions',
                        () => Get.toNamed(Routes.terms),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.description_outlined,
                        'Privacy Policy',
                        () => Get.toNamed(Routes.privacy),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.description_outlined,
                        'Risk Disclosure',
                        () => Get.toNamed(Routes.riskDisclosure),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildAppInfo(context),
                    const SizedBox(height: 24),
                    _buildLogoutButton(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.backgroundDark,
                  AppColors.backgroundDarkSecondary,
                  theme.scaffoldBackgroundColor,
                ]
              : [
                  AppColors.bgLightSecondary,
                  AppColors.bgLightSecondary,
                  theme.scaffoldBackgroundColor,
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),
          _buildUserCard(context),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    final user = AuthService.to.user.value;
    final kycStatus = AuthService.to.kycStatus;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: isDark ? 0.3 : 0.7),
          width: 2,
        ),
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF2A2410), Color(0xFF2A2410)],
              )
            : const RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFFFDF7DE),
                  Color(0xFFF6E7B8),
                  Color(0xFFEDD28D),
                ],
                stops: [0.0, 0.4, 0.8],
              ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user?.profilePictureUrl != null) {
                          _showImagePreviewDialog(
                            context,
                            user!.profilePictureUrl!,
                          );
                        } else {
                          _showImagePickerOptions(context);
                        }
                      },
                      child: Hero(
                        tag: 'profile_image',
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.primaryGold.withValues(alpha: 0.5)
                                  : Colors.white,
                              width: 3,
                            ),
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: user?.profilePictureUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: user!.profilePictureUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 40,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : Colors.black54,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImagePickerOptions(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF2A2410)
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'User Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phone ?? user?.email ?? '+91 98765 43210',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kycStatus == KycStatus.approved
                  ? AppColors.success.withValues(alpha: 0.1)
                  : kycStatus == KycStatus.pending
                  ? AppColors.warning.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              border: Border(
                top: BorderSide(
                  color: kycStatus == KycStatus.approved
                      ? AppColors.success.withValues(alpha: 0.2)
                      : kycStatus == KycStatus.pending
                      ? const Color(0xFFFDE047).withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(22),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  kycStatus == KycStatus.approved
                      ? Icons.check_circle
                      : kycStatus == KycStatus.pending
                      ? Icons.warning_amber
                      : Icons.error_outline,
                  color: kycStatus == KycStatus.approved
                      ? (isDark
                            ? const Color(0xFF34D399)
                            : const Color(0xFF059669))
                      : kycStatus == KycStatus.pending
                      ? (isDark
                            ? const Color(0xFFFACC15)
                            : const Color(0xFF854D0E))
                      : (isDark
                            ? const Color(0xFFF87171)
                            : const Color(0xFFB91C1C)),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  kycStatus == KycStatus.approved
                      ? 'KYC Verified'
                      : kycStatus == KycStatus.pending
                      ? 'KYC Under Review'
                      : 'KYC Not Complete',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontSize: 13,
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

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final widget = entry.value;
            return Container(
              decoration: BoxDecoration(
                border: idx == 0
                    ? null
                    : Border(
                        top: BorderSide(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                          width: 1,
                        ),
                      ),
              ),
              child: widget,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
    String? value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing],
                ],
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'App Version',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
          Text(
            '1.0.0',
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKYCBadge() {
    final status = AuthService.to.kycStatus;
    final isDark = Get.isDarkMode;
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case KycStatus.approved:
        bgColor = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        textColor = isDark ? const Color(0xFF34D399) : const Color(0xFF15803D);
        text = 'Verified';
        break;
      case KycStatus.pending:
        bgColor = isDark ? const Color(0xFF713F12) : const Color(0xFFFEF9C3);
        textColor = isDark ? const Color(0xFFFACC15) : const Color(0xFF854D0E);
        text = 'Pending';
        break;
      default:
        bgColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        textColor = isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C);
        text = 'Incomplete';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: controller.logout,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          foregroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        'Powered by AT Plus Jewellers',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  void _showThemeSelectionSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 24),
            _buildThemeOption(
              context,
              ThemeMode.system,
              'System Default',
              Icons.brightness_auto_outlined,
            ),
            _buildThemeOption(
              context,
              ThemeMode.light,
              'Light Mode',
              Icons.wb_sunny_outlined,
            ),
            _buildThemeOption(
              context,
              ThemeMode.dark,
              'Dark Mode',
              Icons.dark_mode_outlined,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = controller.currentThemeMode == mode;

    return ListTile(
      onTap: () {
        controller.setThemeMode(mode);
        Get.back();
      },
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primaryGold
            : (isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? AppColors.primaryGold
              : (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primaryGold)
          : null,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final isDark = Get.isDarkMode;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  Icons.camera_alt_outlined,
                  'Camera',
                  () {
                    Get.back();
                    controller.uploadProfilePicture(ImageSource.camera);
                  },
                ),
                _buildPickerOption(
                  context,
                  Icons.photo_library_outlined,
                  'Gallery',
                  () {
                    Get.back();
                    controller.uploadProfilePicture(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = Get.isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showImagePreviewDialog(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.to(
      () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Profile photo',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => _showImagePickerOptions(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'profile_image',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGold,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: isDark ? Colors.white : Colors.black,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
    );
  }
}
