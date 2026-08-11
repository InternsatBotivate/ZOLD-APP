import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

class NotificationsSettingsView extends GetView<ProfileController> {
  const NotificationsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.notificationSettings.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGold),
          );
        }

        final settings = controller.notificationSettings.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(context, 'Alerts', [
                _buildSwitchTile(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: 'Price Alerts',
                  subtitle:
                      'Notify me when gold/silver prices change significantly',
                  value: settings.priceAlerts,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(priceAlerts: val),
                  ),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Transaction Alerts',
                  subtitle:
                      'Get updates on your buy, sell and SIP transactions',
                  value: settings.transactionAlerts,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(transactionAlerts: val),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Promotions', [
                _buildSwitchTile(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  title: 'Offers & Rewards',
                  subtitle:
                      'Receive updates on new offers and referral rewards',
                  value: settings.offersRewards,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(offersRewards: val),
                  ),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context,
                  icon: Icons.newspaper_outlined,
                  title: 'News & Updates',
                  subtitle: 'Stay updated with latest news and market insights',
                  value: settings.newsUpdates,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(newsUpdates: val),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context, 'Channels', [
                _buildSwitchTile(
                  context,
                  icon: Icons.app_settings_alt_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: settings.pushEnabled,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(pushEnabled: val),
                  ),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context,
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Notifications',
                  subtitle: 'Receive updates on your registered email',
                  value: settings.emailEnabled,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(emailEnabled: val),
                  ),
                ),
                _buildDivider(context),
                _buildSwitchTile(
                  context,
                  icon: Icons.message_outlined,
                  title: 'WhatsApp Updates',
                  subtitle: 'Get important updates on WhatsApp',
                  value: settings.whatsappEnabled,
                  onChanged: (val) => controller.updateNotificationSetting(
                    settings.copyWith(whatsappEnabled: val),
                  ),
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryGold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.2
                      : 0.05,
                ),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      endIndent: 16,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Improved color logic for better visibility of disabled states
    final titleColor = value
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

    final subtitleColor = value
        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
              .withValues(alpha: 0.9);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: value
                ? AppColors.primaryGold.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: value ? AppColors.primaryGold : Colors.grey,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: subtitleColor, height: 1.4),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primaryGold.withValues(alpha: 0.4),
        activeThumbColor: AppColors.primaryGold,
        inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
        inactiveThumbColor: isDark ? Colors.grey[600] : Colors.grey[400],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
