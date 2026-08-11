import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../wallet/views/wallet_view.dart';
import '../../profile/views/profile_view.dart';
import '../../cart/widgets/cart_drawer.dart';
import '../../../core/widgets/home_drawer.dart';
import '../../../routes/app_routes.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const HomeDrawer(),
      endDrawer: const CartDrawer(),
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const HomeView();
          case 1:
            return const WalletView();
          case 2:
            return const ProfileView();
          default:
            return const HomeView();
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildBuyNowButton(context),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBuyNowButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.buySell),
      child: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? theme.colorScheme.surface : Colors.white,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(
              alpha: isDark ? 0.4 : 0.3,
            ),
            width: 1,
          ),
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFFDF7DE), Color(0xFFEDD28D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BUY',
              style: TextStyle(
                color: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF8B6B00),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
            Text(
              'NOW',
              style: TextStyle(
                color: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF8B6B00),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withValues(alpha: isDark ? 0.3 : 0.1),
            ),
          ),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_outlined, 'Home', 0),
              _buildNavItem(
                context,
                Icons.account_balance_wallet_outlined,
                'Portfolio',
                1,
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(context, Icons.person_outline, 'Profile', 2),
              _buildMoreItem(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = controller.currentIndex.value == index;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => controller.changeTabIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreItem(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) => InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu, color: theme.colorScheme.onSurfaceVariant, size: 24),
            Text(
              'More',
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
