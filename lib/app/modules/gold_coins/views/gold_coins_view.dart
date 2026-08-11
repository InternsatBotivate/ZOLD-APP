import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/gold_coins_controller.dart';
import '../widgets/coin_card.dart';
import '../../cart/widgets/cart_drawer.dart';
import '../../cart/widgets/cart_button.dart';
import '../../../core/widgets/shimmer_wrapper.dart';
import '../../../core/theme/app_colors.dart';

class GoldCoinsView extends GetView<GoldCoinsController> {
  const GoldCoinsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      endDrawer: const CartDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildMetalToggle(context),
            Expanded(
              child: Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildBody(context),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return _buildShimmerGrid(context, key: const ValueKey('loading'));
    }

    if (controller.error.isNotEmpty) {
      return _buildErrorState(context, key: const ValueKey('error'));
    }

    final coins = controller.coins;
    if (coins.isEmpty) {
      return _buildEmptyState(context, key: const ValueKey('empty'));
    }

    return RefreshIndicator(
      key: ValueKey('content_${controller.selectedMetal.value}'),
      onRefresh: controller.loadData,
      color: AppColors.primaryGold,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildProductGrid(context, coins),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        onPressed: () => Get.back(),
      ),
      title: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/02.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      centerTitle: false,
      actions: const [CartButton(), SizedBox(width: 8)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: colorScheme.outline.withValues(alpha: 0.1),
          height: 1,
        ),
      ),
    );
  }

  Widget _buildMetalToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      child: Obx(() {
        final selected = controller.selectedMetal.value;
        final isGold = selected == 'GOLD';

        return Row(
          children: [
            _buildTabItem(context, 'GOLD', isGold, AppColors.primaryGold),
            _buildTabItem(context, 'SILVER', !isGold, const Color(0xFF64748B)),
          ],
        );
      }),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String label,
    bool isSelected,
    Color activeColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: () => controller.switchMetal(label),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              width: isSelected
                  ? 120
                  : 0, // Increased width for better visibility
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGold = controller.selectedMetal.value == 'GOLD';
    final metalName = isGold ? 'Gold' : 'Silver';
    final purity = isGold ? '24K' : '999';
    final rate = isGold
        ? controller.cartController.goldRate.value
        : controller.cartController.silverRate.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$metalName Coins',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isGold
                          ? colorScheme.onSurface
                          : (Get.isDarkMode
                                ? colorScheme.onSurface
                                : const Color(0xFF334155)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$purity CERTIFIED · DELIVERED TO YOUR DOOR',
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            _buildLiveRateBadge(context, rate, isGold),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            _buildTrustBadge(
              context,
              Icons.verified_user_outlined,
              'BIS Hallmarked',
              AppColors.success,
            ),
            _buildTrustBadge(
              context,
              Icons.local_shipping_outlined,
              'Free Delivery',
              AppColors.info,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustBadge(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 11,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveRateBadge(BuildContext context, double rate, bool isGold) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: isGold
            ? AppColors.primaryGold.withValues(alpha: 0.1)
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGold
              ? AppColors.primaryGold.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(
            color: isGold
                ? AppColors.primaryGold
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '₹${rate.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/g',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isGold
                    ? (isDark ? AppColors.lightGold : AppColors.darkGold)
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List coins) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 1200
        ? 5
        : (width > 900 ? 4 : (width > 600 ? 3 : 2));

    // Calculate aspect ratio based on width to maintain layout consistency
    double aspectRatio = 0.65;
    if (width > 600 && width <= 900) aspectRatio = 0.7;
    if (width > 900) aspectRatio = 0.75;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: coins.length,
      itemBuilder: (context, index) {
        return CoinCard(coin: coins[index]);
      },
    );
  }

  Widget _buildShimmerGrid(BuildContext context, {required Key key}) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    double aspectRatio = 0.65;
    if (width > 600 && width <= 900) aspectRatio = 0.7;
    if (width > 900) aspectRatio = 0.75;

    return ListView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        ShimmerWrapper(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => ShimmerWrapper(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, {required Key key}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required Key key}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No coins available',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new arrivals',
            style: GoogleFonts.lato(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.2).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
