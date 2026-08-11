import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_date_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/wallet_controller.dart';
import 'gift_gold_bottom_sheet.dart';
import 'coin_delivery_bottom_sheet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/string_utils.dart';
import '../controllers/delivery_controller.dart';
import '../../../routes/app_routes.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeletonLoader(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: theme.colorScheme.primary,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: CustomScrollView(
                slivers: [
                  _buildHeader(context),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildMetalBreakdown(context),
                          const SizedBox(height: 24),
                          _buildCoinPortfolio(context),
                          const SizedBox(height: 24),
                          _buildActiveDeliveries(context),
                          const SizedBox(height: 24),
                          _buildCoinTransactions(context),
                          const SizedBox(height: 24),
                          _buildSIPBanner(context),
                          const SizedBox(height: 24),
                          _buildGoalsBanner(context),
                          const SizedBox(
                            height: 100,
                          ), // Bottom padding for FAB/Nav
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? theme.scaffoldBackgroundColor : null,
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFFFDF7DE),
                    Color(0xFFF6E7B8),
                    Color(0xFFEDD28D),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        child: Column(children: [_buildGlassmorphismOverview(context)]),
      ),
    );
  }

  Widget _buildGlassmorphismOverview(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldPct = controller.goldPercentage;
    final silverPct = controller.silverPercentage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL PORTFOLIO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? theme.colorScheme.primary
                          : const Color(0xFF5A4A1A),
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF8B6B00),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '₹${NumberFormat('#,##,##0').format(controller.totalValuation)}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _buildRatioBar(context, goldPct, silverPct),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRatioIndicator(
                    context,
                    'Gold',
                    goldPct,
                    const Color(0xFFD4AF37),
                  ),
                  _buildRatioIndicator(
                    context,
                    'Silver',
                    silverPct,
                    const Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildMetalCard(context, 'Gold Holdings', true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetalCard(context, 'Silver Holdings', false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatioBar(
    BuildContext context,
    double goldPct,
    double silverPct,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            flex: (goldPct * 100).toInt().clamp(1, 100),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [theme.colorScheme.primary, const Color(0xFFB8960C)]
                      : [const Color(0xFFE0BF6A), const Color(0xFF8B6B00)],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(4),
                ),
              ),
            ),
          ),
          Expanded(
            flex: (silverPct * 100).toInt().clamp(1, 100),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF94A3B8), const Color(0xFF64748B)]
                      : [const Color(0xFFCBD5E1), const Color(0xFF64748B)],
                ),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioIndicator(
    BuildContext context,
    String label,
    double pct,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label ${pct.toStringAsFixed(1)}%',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? theme.colorScheme.onSurfaceVariant
                    : const Color(0xFF5A4A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetalCard(BuildContext context, String label, bool isGold) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final balance = controller.walletBalance.value;
    final grams = isGold ? balance?.goldGrams ?? 0 : balance?.silverGrams ?? 0;
    final valuation = isGold
        ? balance?.goldValuation ?? 0
        : balance?.silverValuation ?? 0;
    final avgBuy = controller.walletStats.value?.avgBuyPrice ?? 0;
    final pl = isGold ? controller.goldProfitLoss : controller.silverProfitLoss;
    final plPct = isGold
        ? controller.goldProfitLossPercentage
        : controller.silverProfitLossPercentage;
    final positive = pl >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : null,
        gradient: isDark
            ? null
            : (isGold
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFFF8DC),
                        Color(0xFFF6E7B8),
                        Color(0xFFE6C873),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xFFF8FAFC),
                        Color(0xFFE2E8F0),
                        Color(0xFFA8B3C2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGold
              ? (isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.2)
                    : const Color(0xFFD4AF37).withValues(alpha: 0.4))
              : (isDark
                    ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                    : const Color(0xFF94A3B8).withValues(alpha: 0.4)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isGold
                      ? (isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : const Color(0xFF5A4A1A))
                      : (isDark
                            ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                            : const Color(0xFF334155)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 12,
                  color: isGold
                      ? (isDark
                            ? theme.colorScheme.primary
                            : const Color(0xFFFDE9A5))
                      : Colors.white,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 14,
                color: isGold
                    ? (isDark
                          ? theme.colorScheme.primary
                          : const Color(0xFF8B6B00))
                    : (isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF475569)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: isGold
                  ? (isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF5A4A1A))
                  : (isDark
                        ? theme.textTheme.bodySmall?.color
                        : const Color(0xFF334155)),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                grams.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                'g',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            '₹${NumberFormat('#,##,##0').format(valuation)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Divider(height: 16, color: theme.dividerColor.withValues(alpha: 0.1)),
          _buildPlInfo(
            context,
            'Avg Buy',
            '₹${NumberFormat('#,##,##0').format(avgBuy)}/g',
            isGold,
          ),
          const SizedBox(height: 4),
          _buildPlInfo(
            context,
            'P/L',
            '${positive ? '+' : ''}₹${NumberFormat('#,##,##0').format(pl.abs())} (${plPct.toStringAsFixed(2)}%)',
            isGold,
            isPl: true,
            positive: positive,
          ),
        ],
      ),
    );
  }

  Widget _buildPlInfo(
    BuildContext context,
    String label,
    String value,
    bool isGold, {
    bool isPl = false,
    bool positive = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isGold
                ? (isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : const Color(0xFF5A4A1A).withValues(alpha: 0.7))
                : (isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : const Color(0xFF334155).withValues(alpha: 0.7)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isPl
                ? (positive ? AppColors.success : theme.colorScheme.error)
                : (isDark
                      ? theme.colorScheme.onSurfaceVariant
                      : (isGold
                            ? const Color(0xFF3D2F0A)
                            : const Color(0xFF1E293B))),
          ),
        ),
      ],
    );
  }

  Widget _buildMetalBreakdown(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldGrams = controller.walletBalance.value?.goldGrams ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gold Breakdown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            context,
            'Free Gold',
            'Available for transactions',
            '$goldGrams gm',
            Icons.trending_up,
            isDark
                ? const Color(0xFF064E3B).withValues(alpha: 0.2)
                : const Color(0xFFF0FDF4),
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPortfolio(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.stars, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'My Coins',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: controller.refreshData,
              icon: Icon(
                Icons.refresh,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.coinInventory.isEmpty) {
            return _buildEmptyCoins(context);
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.coinInventory.length,
            itemBuilder: (context, index) {
              final coin = controller.coinInventory[index];
              return _buildCoinItem(context, coin);
            },
          );
        }),
      ],
    );
  }

  String _getCoinImage(int grams, String metal) {
    if (metal.toUpperCase() == 'SILVER') {
      return 'assets/images/silver-Zold-Bar.png';
    }
    switch (grams) {
      case 1:
        return 'assets/images/1gmZold.webp';
      case 2:
        return 'assets/images/2gmZold.webp';
      case 5:
        return 'assets/images/5gmZold.webp';
      case 10:
        return 'assets/images/10gmZold.webp';
      default:
        return 'assets/images/goldSilverCoins.png';
    }
  }

  Widget _buildCoinItem(BuildContext context, dynamic coin) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final imagePath = _getCoinImage(coin.coinGrams, coin.metal);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset(imagePath, height: 80),
          const SizedBox(height: 8),
          Text(
            '${coin.coinGrams}g ${StringUtils.capitalizeFirst(coin.metal.toLowerCase())}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            '${coin.quantity}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildActionButton(
                  context,
                  'Delivery',
                  Icons.local_shipping,
                  isDark ? theme.colorScheme.primary : Colors.black,
                  isDark ? Colors.black : Colors.white,
                  onTap: () {
                    Get.find<DeliveryController>().resetFields();
                    Get.bottomSheet(
                      CoinDeliveryBottomSheet(coin: coin),
                      isScrollControlled: true,
                    );
                  },
                ),
                const SizedBox(height: 4),
                _buildActionButton(
                  context,
                  'Gift',
                  Icons.card_giftcard,
                  isDark
                      ? theme.colorScheme.surface.withValues(alpha: 0.1)
                      : Colors.white,
                  isDark ? Colors.white : Colors.black,
                  border: true,
                  onTap: () => Get.bottomSheet(
                    const GiftGoldBottomSheet(),
                    isScrollControlled: true,
                    settings: RouteSettings(
                      arguments: {
                        'initialGiftType': 'coins',
                        'initialCoinGrams': coin.coinGrams,
                        'initialCoinQuantity': 1,
                        'metalType': coin.metal,
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color textColor, {
    bool border = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: border
              ? Border.all(color: theme.dividerColor.withValues(alpha: 0.1))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCoins(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 32,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Coins Yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buy coins to start your collection. Choose from 1g, 2g, 5g, or 10g coins.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDeliveries(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (controller.activeDeliveries.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
          boxShadow: theme.brightness == Brightness.dark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Active Deliveries',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.deliveries),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${controller.activeDeliveries.length} Active',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.activeDeliveries.map(
              (delivery) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDeliveryItem(
                  context,
                  '${delivery.coinGrams}g Coin',
                  delivery.address,
                  'User', // Could be from profile if available
                  delivery.status,
                  AppDateUtils.formatDate(delivery.createdAt),
                  delivery.status == 'READY_FOR_PICKUP',
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDeliveryItem(
    BuildContext context,
    String coin,
    String store,
    String receiver,
    String status,
    String date,
    bool isPickup,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 10,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            store,
                            style: TextStyle(
                              fontSize: 8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPickup
                          ? const Color(0xFF065F46).withValues(alpha: 0.2)
                          : const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isPickup
                            ? const Color(0xFF34D399)
                            : const Color(0xFF60A5FA),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 8,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 20, color: theme.dividerColor.withValues(alpha: 0.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Receiver: ',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    receiver,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.deliveries),
                child: Text(
                  'Track',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinTransactions(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Coin Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.coinTransactions.isEmpty) {
              return Center(
                child: Text(
                  'No transactions found',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.coinTransactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tx = controller.coinTransactions[index];
                final isPurchase = tx.type == 'BUY_WITH_RUPEES';
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isPurchase
                            ? const Color(0xFF064E3B).withValues(alpha: 0.2)
                            : const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPurchase ? Icons.trending_up : Icons.refresh,
                        size: 16,
                        color: isPurchase
                            ? const Color(0xFF34D399)
                            : const Color(0xFF60A5FA),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${isPurchase ? 'Purchased' : 'Converted'} ${tx.quantity}x ${tx.weight}g Coin',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            AppDateUtils.formatDate(tx.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isPurchase
                              ? '₹${NumberFormat('#,##,##0').format(tx.finalAmount)}'
                              : '${tx.weight * tx.quantity}g',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          isPurchase ? 'Test Wallet' : 'Wallet Gold',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSIPBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : null,
        gradient: isDark
            ? null
            : const RadialGradient(
                colors: [
                  Color(0xFFFDF7DE),
                  Color(0xFFF6E7B8),
                  Color(0xFFEDD28D),
                ],
                center: Alignment.center,
                radius: 1.0,
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIP Plans',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark
                          ? theme.colorScheme.primary
                          : const Color(0xFF5A4A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Systematic Investment Plans\nfor gold & silver',
                    style: TextStyle(
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF30280A).withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.calendar_today,
                size: 32,
                color: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF5A4A1A),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/sip'),
              style: theme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                foregroundColor: WidgetStateProperty.all(
                  theme.colorScheme.primary,
                ),
                elevation: WidgetStateProperty.all(0),
              ),
              child: const Text(
                'View SIPs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : null,
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFFFF9E8), Color(0xFFFDF7DE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B2942).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metal Goals',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF8B2942),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set targets for weddings,\nfestivals & more',
                    style: TextStyle(
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF8B2942).withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.track_changes,
                size: 32,
                color: Color(0xFF8B2942),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/goals'),
              style: theme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFF8B2942).withValues(alpha: 0.1),
                ),
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFF8B2942),
                ),
                elevation: WidgetStateProperty.all(0),
              ),
              child: const Text(
                'Manage Goals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.dividerColor.withValues(alpha: 0.1),
      highlightColor: theme.colorScheme.surface,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 100,
                    height: 20,
                    color: theme.colorScheme.surface,
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: 4,
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
