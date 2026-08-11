import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../modules/main/controllers/main_controller.dart';
import '../../core/services/auth_service.dart';
import '../../routes/app_routes.dart';

class HomeDrawer extends GetView<MainController> {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.to.user.value;
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            _buildBrand(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _buildSectionLabel(context, 'MENU'),
                  Obx(
                    () => _buildDrawerItem(
                      context,
                      Icons.home_outlined,
                      'Home',
                      () {
                        Get.back();
                        controller.changeTabIndex(0);
                        if (Get.currentRoute != Routes.home) {
                          Get.offAllNamed(Routes.home);
                        }
                      },
                      isActive:
                          Get.currentRoute == Routes.home &&
                          controller.currentIndex.value == 0,
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.swap_horiz,
                    'Buy / Sell',
                    () => Get.toNamed(Routes.buySell),
                    isActive: Get.currentRoute == Routes.buySell,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.monetization_on_outlined,
                    'Buy Coins',
                    () => Get.toNamed(Routes.goldCoins),
                    isActive: Get.currentRoute == Routes.goldCoins,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.history_outlined,
                    'History',
                    () => Get.toNamed(Routes.history),
                    isActive: Get.currentRoute == Routes.history,
                  ),
                  Obx(
                    () => _buildDrawerItem(
                      context,
                      Icons.account_balance_wallet_outlined,
                      'Portfolio',
                      () {
                        Get.back();
                        controller.changeTabIndex(1);
                        if (Get.currentRoute != Routes.home) {
                          Get.offAllNamed(Routes.home);
                        }
                      },
                      isActive:
                          Get.currentRoute == Routes.home &&
                          controller.currentIndex.value == 1,
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.location_on_outlined,
                    'Partners',
                    () => Get.toNamed(Routes.partners),
                    isActive: Get.currentRoute == Routes.partners,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.local_shipping_outlined,
                    'Deliveries',
                    () => Get.toNamed(Routes.deliveries),
                    isActive: Get.currentRoute == Routes.deliveries,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.track_changes_outlined,
                    'Goals',
                    () => Get.toNamed(Routes.goals),
                    isActive: Get.currentRoute == Routes.goals,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.card_giftcard_outlined,
                    'Gift Gold',
                    () => Get.toNamed(Routes.giftGold),
                    isActive: Get.currentRoute == Routes.giftGold,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.handshake_outlined,
                    'SIP',
                    () => Get.toNamed(Routes.sip),
                    isActive: Get.currentRoute == Routes.sip,
                  ),
                  Obx(
                    () => _buildDrawerItem(
                      context,
                      Icons.person_outline,
                      'Profile',
                      () {
                        Get.back();
                        controller.changeTabIndex(2);
                        if (Get.currentRoute != Routes.home) {
                          Get.offAllNamed(Routes.home);
                        }
                      },
                      isActive:
                          Get.currentRoute == Routes.home &&
                          controller.currentIndex.value == 2,
                    ),
                  ),
                  if (user?.role == 'ADMIN') ...[
                    _buildAdminSeparator(context),
                    _buildDrawerItem(
                      context,
                      Icons.people_outline,
                      'Users',
                      () => Get.toNamed(Routes.adminUsers),
                      isActive: Get.currentRoute == Routes.adminUsers,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.receipt_long_outlined,
                      'Sell Requests',
                      () => Get.toNamed(Routes.adminSellRequests),
                      isActive: Get.currentRoute == Routes.adminSellRequests,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.currency_exchange_outlined,
                      'Metal Prices',
                      () => Get.toNamed(Routes.adminMetalPrices),
                      isActive: Get.currentRoute == Routes.adminMetalPrices,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.trending_up_outlined,
                      'Manage GST',
                      () => Get.toNamed(Routes.adminManageGst),
                      isActive: Get.currentRoute == Routes.adminManageGst,
                    ),
                  ],
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.1),
            ),
            _buildLogoutButton(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/02.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zold',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              Text(
                'Metal',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodySmall?.color,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildAdminSeparator(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerColor.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'ADMIN',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodySmall?.color,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: dividerColor)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? theme.colorScheme.primary : null,
              gradient: isDark
                  ? null
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        const Color(0xFFFDF7DE).withValues(alpha: 0.5),
                        const Color(0xFFF1DDA5).withValues(alpha: 0.8),
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.35 : 0.1,
                  ),
                  blurRadius: isDark ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? (isDark ? const Color(0xFF1A1200) : const Color(0xFF8B6B00))
              : theme.textTheme.bodySmall?.color,
          size: 22,
        ),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? (isDark
                      ? const Color(0xFF1A1200)
                      : theme.colorScheme.onSurface)
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
        trailing: isActive
            ? Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFFF0D060)
                      : const Color(0xFFC9A227),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
      title: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.redAccent,
        ),
      ),
      onTap: () => AuthService.to.logout(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      dense: true,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        Icons.chevron_left,
        color: theme.textTheme.bodySmall?.color,
        size: 22,
      ),
      title: Text(
        'Collapse',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodySmall?.color,
        ),
      ),
      onTap: () => Get.back(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      dense: true,
    );
  }
}
