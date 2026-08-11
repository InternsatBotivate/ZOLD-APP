import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/security_privacy_controller.dart';
import '../../../data/models/profile_models.dart';
import '../../../core/theme/app_colors.dart';

class SecurityPrivacyView extends GetView<SecurityPrivacyController> {
  const SecurityPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isEditing = controller.isEditMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.bgDark : Colors.white,
          elevation: 0,
          toolbarHeight: 70, // Increased height to ensure title and button fit
          centerTitle: false,
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
                'Security & Privacy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Protect your account and data',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: controller.toggleEditMode,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text(
                      'Edit Settings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D3066),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cancel Button
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: OutlinedButton(
                        onPressed: controller.toggleEditMode,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : Colors.grey[300]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: isDark
                              ? AppColors.bgDarkSecondary
                              : Colors.white,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Save Button
                    ElevatedButton.icon(
                      onPressed: controller.saveSettings,
                      icon: const Icon(Icons.save_outlined, size: 16),
                      label: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Password Security Section
                    _buildSectionHeader(context, 'Password Security'),
                    _buildPasswordCard(context, isEditing),
                    const SizedBox(height: 24),

                    // Two-Factor Authentication Section
                    _buildSectionHeader(
                      context,
                      'Two-Factor Authentication',
                      badge: !isEditing
                          ? _buildBadge(
                              controller.twoFactorEnabled.value
                                  ? 'Enabled'
                                  : 'Disabled',
                              controller.twoFactorEnabled.value
                                  ? Colors.green
                                  : Colors.red,
                            )
                          : Switch(
                              value: controller.twoFactorEnabled.value,
                              onChanged: (val) =>
                                  controller.twoFactorEnabled.value = val,
                              activeThumbColor: Colors.green,
                              activeTrackColor: Colors.green.withValues(
                                alpha: 0.3,
                              ),
                            ),
                    ),
                    _buildTwoFactorCard(context, isEditing),
                    const SizedBox(height: 24),

                    // Privacy Settings Section
                    _buildSectionHeader(context, 'Privacy Settings'),
                    _buildPrivacyCard(context, isEditing),
                    const SizedBox(height: 24),

                    // Active Sessions Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Sessions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: controller.revokeAllSessions,
                          icon: const Icon(
                            Icons.refresh,
                            size: 16,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Logout All',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSessionsList(context),
                    const SizedBox(height: 24),

                    // Footer message/tips
                    if (isEditing)
                      _buildImportantMessage(context)
                    else
                      _buildSecurityTips(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    Widget? badge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          if (badge != null) badge,
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPasswordCard(BuildContext context, bool isEditing) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isEditing) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Changes require verification',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              context,
              label: 'Current Password',
              controller: controller.currentPasswordController,
              obscureText: !controller.showCurrentPassword.value,
              onToggle: () => controller.showCurrentPassword.toggle(),
              icon: Icons.key_outlined,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              context,
              label: 'New Password',
              controller: controller.newPasswordController,
              obscureText: !controller.showNewPassword.value,
              onToggle: () => controller.showNewPassword.toggle(),
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              context,
              label: 'Confirm New Password',
              controller: controller.confirmPasswordController,
              obscureText: !controller.showConfirmPassword.value,
              onToggle: () => controller.showConfirmPassword.toggle(),
              icon: Icons.lock_outline,
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              _buildBadge('Secure', Colors.green),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Click "Edit Settings" to change your password',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}',
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMutedDark : Colors.grey[400],
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: isDark ? AppColors.bgDark : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : Colors.grey[300]!,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: isDark ? AppColors.textMutedDark : Colors.grey[500],
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoFactorCard(BuildContext context, bool isEditing) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add an extra layer of security to your account',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Requires a verification code from your authenticator app when logging in',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context, bool isEditing) {
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
      child: Column(
        children: [
          // Profile Visibility
          _buildProfileVisibility(context, isEditing),
          const Divider(height: 32),
          // Read Receipts
          _buildPrivacySwitchItem(
            context,
            'Read Receipts',
            'Let others know when you\'ve read their messages',
            controller.readReceipts.value,
            isEditing,
            (val) => controller.readReceipts.value = val,
          ),
          const Divider(height: 32),
          // Data Sharing
          _buildPrivacySwitchItem(
            context,
            'Data Sharing',
            'Share anonymous usage data to improve services',
            controller.dataSharing.value,
            isEditing,
            (val) => controller.dataSharing.value = val,
            activeThumbColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileVisibility(BuildContext context, bool isEditing) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Profile Visibility',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDark : Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.borderDark : Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.profileVisibility.value,
                isExpanded: true,
                dropdownColor: isDark
                    ? AppColors.bgDarkSecondary
                    : Colors.white,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Everyone')),
                  DropdownMenuItem(
                    value: 'contacts',
                    child: Text('My Contacts Only'),
                  ),
                  DropdownMenuItem(value: 'none', child: Text('Nobody')),
                ],
                onChanged: (val) {
                  if (val != null) controller.profileVisibility.value = val;
                },
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 18,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              'Profile Visibility',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            controller.profileVisibility.value == 'public'
                ? 'Everyone'
                : controller.profileVisibility.value == 'contacts'
                ? 'My Contacts Only'
                : 'Nobody',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySwitchItem(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    bool isEditing,
    Function(bool) onChanged, {
    Color activeThumbColor = const Color(0xFF3D3066),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeThumbColor,
            activeTrackColor: activeThumbColor.withValues(alpha: 0.3),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildBadge(
          value ? 'On' : (title == 'Data Sharing' ? 'Disabled' : 'Off'),
          value ? Colors.green : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildSessionsList(BuildContext context) {
    if (controller.sessions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No active sessions',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = controller.sessions[index];
        return _buildSessionItem(context, session);
      },
    );
  }

  Widget _buildSessionItem(BuildContext context, UserSession session) {
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
              color: session.isActive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.deviceType == 'MOBILE' ? Icons.smartphone : Icons.laptop,
              color: session.isActive ? Colors.green : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.deviceName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      session.location ?? 'Unknown',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(session.lastActivity),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    if (session.isActive) ...[
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!session.isActive)
            TextButton(
              onPressed: () => controller.revokeSession(session.id),
              child: const Text('Revoke', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  Widget _buildSecurityTips(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF).withValues(alpha: isDark ? 0.1 : 1.0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Color(0xFF1D4ED8),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Security Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(context, 'Use a unique password for this account'),
          _buildTipItem(context, 'Enable two-factor authentication'),
          _buildTipItem(context, 'Review active sessions regularly'),
          _buildTipItem(context, 'Keep your recovery email updated'),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF1D4ED8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Important: Changing security settings may log you out from some devices. Make sure you have access to your recovery email and phone number.',
              style: TextStyle(
                color: Color(0xFFB45309),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
