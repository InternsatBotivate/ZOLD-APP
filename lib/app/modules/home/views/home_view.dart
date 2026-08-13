import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/coin_models.dart';
import '../../cart/widgets/cart_button.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: AppColors.primaryGold,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              _buildTopBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeroSection(context),
                    _buildMainContent(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: theme.appBarTheme.backgroundColor,
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Zold',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF8B6B00),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      actions: [
        const CartButton(),
        Stack(
          children: [
            IconButton(
              onPressed: () => Get.toNamed(Routes.notifications),
              icon: Icon(
                Icons.notifications_none,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Obx(
              () => controller.unreadNotificationsCount.value > 0
                  ? Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 1.5,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.profile),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(
              () {
                final user = AuthService.to.user.value;
                final imageUrl = user?.profilePictureUrl;
                
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: isDark ? Colors.white10 : theme.dividerColor,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  child: imageUrl == null || imageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 20,
                          color: theme.textTheme.bodySmall?.color,
                        )
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    theme.scaffoldBackgroundColor,
                    theme.colorScheme.surfaceContainerHighest,
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
        ),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            controller.isLoading.value
                ? _buildShimmerLiveRateHeader(context)
                : _buildLiveRateHeader(context),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: controller.isLoading.value
                        ? _buildShimmerRateCard(context)
                        : _buildRateCard(
                            context,
                            'GOLD',
                            controller.goldBuyPrice.value,
                            true,
                            onTap: controller.onBuyGold,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: controller.isLoading.value
                        ? _buildShimmerRateCard(context)
                        : _buildRateCard(
                            context,
                            'SILVER',
                            controller.silverBuyPrice.value,
                            false,
                            onTap: controller.onBuySilver,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: controller.isLoading.value
                        ? _buildShimmerPortfolioCard(context)
                        : _buildPortfolioCard(
                            context,
                            'Gold Portfolio',
                            controller.goldPortfolioValue.value,
                            controller.userGoldGrams.value,
                            controller.goldCoins,
                            true,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: controller.isLoading.value
                        ? _buildShimmerPortfolioCard(context)
                        : _buildPortfolioCard(
                            context,
                            'Silver Portfolio',
                            controller.silverPortfolioValue.value,
                            controller.userSilverGrams.value,
                            controller.silverCoins,
                            false,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveRateHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                SpinKitPulse(
                  color: theme.colorScheme.error.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(width: 6),
            Text(
              'Live Rate',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '24K · 999.0',
                style: TextStyle(
                  color: isDark
                      ? theme.colorScheme.primary
                      : const Color(0xFF9A7700),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.priceChange.value >= 0
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: controller.priceChange.value >= 0
                  ? AppColors.success
                  : theme.colorScheme.error,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${controller.priceChange.value >= 0 ? '+' : ''}${controller.priceChange.value}%',
              style: TextStyle(
                color: controller.priceChange.value >= 0
                    ? AppColors.success
                    : theme.colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRateCard(
    BuildContext context,
    String metal,
    double price,
    bool isGold, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? theme.colorScheme.surface : null,
          border: Border.all(
            color: isGold
                ? theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.3 : 0.7,
                  )
                : theme.dividerColor.withValues(alpha: isDark ? 0.3 : 0.9),
            width: 2,
          ),
          gradient: isDark
              ? null
              : RadialGradient(
                  colors: isGold
                      ? [
                          const Color(0xFFFDF7DE),
                          const Color(0xFFF6E7B8),
                          const Color(0xFFEDD28D),
                        ]
                      : [
                          const Color(0xFFF3F5F8),
                          const Color(0xFFE1E5EB),
                          const Color(0xFFC3CAD4),
                        ],
                  center: Alignment.center,
                  radius: 1.0,
                ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          metal,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isGold
                                ? (isDark
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.85,
                                        ))
                                : (isDark
                                      ? const Color(0xFFC8D4E0)
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.8,
                                        )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '24K | 999',
                        style: TextStyle(
                          fontSize: 8,
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '/gm',
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(
    BuildContext context,
    String title,
    double value,
    double grams,
    List<CoinInventory> coins,
    bool isGold,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? theme.colorScheme.surface : null,
        border: Border.all(
          color: isGold
              ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.7)
              : theme.dividerColor.withValues(alpha: isDark ? 0.3 : 0.9),
          width: 2,
        ),
        gradient: isDark
            ? null
            : RadialGradient(
                colors: isGold
                    ? [
                        const Color(0xFFFDF7DE),
                        const Color(0xFFF6E7B8),
                        const Color(0xFFEDD28D),
                      ]
                    : [
                        const Color(0xFFF3F5F8),
                        const Color(0xFFE1E5EB),
                        const Color(0xFFC3CAD4),
                      ],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: isGold
                  ? (isDark
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface)
                  : (isDark
                        ? const Color(0xFFC8D4E0)
                        : theme.colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            grams > 0 ? '₹${NumberFormat('#,##,##0.00').format(value)}' : '₹0',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: grams > 0
                  ? (isDark
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6))
                  : (isDark
                        ? theme.disabledColor
                        : theme.disabledColor.withValues(alpha: 0.4)),
            ),
          ),
          const SizedBox(height: 6),
          if (grams > 0) ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isGold
                          ? (isDark
                                ? Colors.black26
                                : const Color(
                                    0xFF2D2510,
                                  ).withValues(alpha: 0.1))
                          : (isDark
                                ? Colors.black26
                                : Colors.black.withValues(alpha: 0.08)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 12,
                              color: isGold
                                  ? (isDark
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.7,
                                          )
                                        : const Color(
                                            0xFF8B6B00,
                                          ).withValues(alpha: 0.7))
                                  : (isDark
                                        ? const Color(0xFF8A9AB0)
                                        : theme.textTheme.bodyMedium?.color),
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                isGold ? 'Gold Bar' : 'Silver Bar',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isGold
                                      ? (isDark
                                            ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.7)
                                            : const Color(
                                                0xFF8B6B00,
                                              ).withValues(alpha: 0.7))
                                      : (isDark
                                            ? const Color(0xFF8A9AB0)
                                            : theme
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${grams.toStringAsFixed(3)}g',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isGold
                          ? (isDark
                                ? Colors.black26
                                : const Color(
                                    0xFF2D2510,
                                  ).withValues(alpha: 0.1))
                          : (isDark
                                ? Colors.black26
                                : Colors.black.withValues(alpha: 0.08)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 12,
                              color: isGold
                                  ? (isDark
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.7,
                                          )
                                        : const Color(
                                            0xFF8B6B00,
                                          ).withValues(alpha: 0.7))
                                  : (isDark
                                        ? const Color(0xFF8A9AB0)
                                        : theme.textTheme.bodyMedium?.color),
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                'Coins',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isGold
                                      ? (isDark
                                            ? theme.colorScheme.primary
                                                  .withValues(alpha: 0.7)
                                            : const Color(
                                                0xFF8B6B00,
                                              ).withValues(alpha: 0.7))
                                      : (isDark
                                            ? const Color(0xFF8A9AB0)
                                            : theme
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${coins.fold<int>(0, (sum, c) => sum + c.quantity)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (coins.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: coins
                      .map(
                        (coin) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isGold
                                ? (isDark
                                      ? Colors.white10
                                      : const Color(
                                          0xFF2D2510,
                                        ).withValues(alpha: 0.15))
                                : (isDark
                                      ? Colors.white10
                                      : Colors.black.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${coin.coinGrams}g × ${coin.quantity}',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ] else
            TextButton(
              onPressed: isGold ? controller.onBuyGold : controller.onBuySilver,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Start buying',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isGold
                          ? (isDark
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.6,
                                  )
                                : const Color(0xFF8B7A3A))
                          : (isDark
                                ? const Color(0xFF8A9AB0)
                                : theme.textTheme.bodyMedium?.color),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 12,
                    color: isGold
                        ? (isDark
                              ? theme.colorScheme.primary.withValues(alpha: 0.6)
                              : const Color(0xFF8B7A3A))
                        : (isDark
                              ? const Color(0xFF8A9AB0)
                              : theme.textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickTrade(context),
          const SizedBox(height: 24),
          Text(
            'Quick Actions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildPriceChart(context),
          const SizedBox(height: 24),
          _buildPromotions(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickTrade(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTradeButton(
                  context,
                  'Buy Gold',
                  'assets/images/doubleZoldGold2.png',
                  controller.onBuyGold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTradeButton(
                  context,
                  'Sell Gold',
                  'assets/images/Sell-Gold.png',
                  controller.onSellGold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTradeButton(
                  context,
                  'Buy Coins',
                  'assets/images/goldSilverCoins.png',
                  controller.onBuyCoins,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTradeButton(
                  context,
                  'Buy Silver',
                  'assets/images/doubleZoldSIlver.png',
                  controller.onBuySilver,
                  isSilver: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTradeButton(
                  context,
                  'Sell Silver',
                  'assets/images/Sell-Silver.png',
                  controller.onSellSilver,
                  isSilver: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTradeButton(
    BuildContext context,
    String label,
    String imagePath,
    VoidCallback onTap, {
    bool isSilver = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSilver
                    ? const Color(
                        0xFFD6DBE3,
                      ).withValues(alpha: isDark ? 0.3 : 0.7)
                    : const Color(
                        0xFFEAD69C,
                      ).withValues(alpha: isDark ? 0.3 : 0.7),
              ),
              gradient: isDark
                  ? null
                  : LinearGradient(
                      colors: isSilver
                          ? [
                              Colors.white,
                              const Color(0xFFE1E5EB),
                              const Color(0xFFC3CAD4),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFFAF3D6),
                              const Color(0xFFF7EAC8),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: 65,
                width: 65,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark
                ? theme.colorScheme.primary
                : Colors.black.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildActionItem(
            context,
            Icons.track_changes,
            'Goals',
            const Color(0xFFF43F5E), // Pink
            controller.onOpenGoals,
          ),
          const SizedBox(width: 12),
          _buildActionItem(
            context,
            Icons.card_giftcard,
            'Gift',
            const Color(0xFFEAB308), // Gold/Yellow
            controller.onOpenGiftGold,
          ),
          const SizedBox(width: 12),
          _buildActionItem(
            context,
            Icons.people_outline,
            'Refer',
            const Color(0xFF3B82F6), // Blue
            controller.onOpenReferral,
          ),
          const SizedBox(width: 12),
          _buildActionItem(
            context,
            Icons.insert_chart_outlined,
            'SIP',
            const Color(0xFF10B981), // Green
            controller.onOpenSIP,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 85, // Fixed width for scrollable row consistency
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : theme.dividerColor.withValues(alpha: 0.1),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Price Chart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: ['1D', '1W', '1M', '1Y'].map((tf) {
                    final isSelected = controller.chartTimeframe.value == tf;
                    return GestureDetector(
                      onTap: () => controller.setChartTimeframe(tf),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.grey[800] : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isSelected && !isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          tf,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? (isDark ? Colors.white : Colors.black)
                                : theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Obx(
              () => controller.isLoading.value
                  ? _buildShimmerPriceChart(context)
                  : controller.priceHistory.length < 2
                  ? const Center(child: Text('Insufficient data for chart'))
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: isDark,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: Colors.white10,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minY:
                            (controller.priceHistory
                                .map((e) => e.buyRate)
                                .reduce((a, b) => a < b ? a : b) *
                            0.999),
                        maxY:
                            (controller.priceHistory
                                .map((e) => e.buyRate)
                                .reduce((a, b) => a > b ? a : b) *
                            1.001),
                        lineBarsData: [
                          LineChartBarData(
                            spots: controller.priceHistory.asMap().entries.map((
                              e,
                            ) {
                              return FlSpot(e.key.toDouble(), e.value.buyRate);
                            }).toList(),
                            isCurved: true,
                            color: theme.colorScheme.primary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0,
                                  ),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotions(BuildContext context) {
    return Column(
      children: [
        _buildAuspiciousDaysBanner(context),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return Row(
                children: [
                  Expanded(child: _buildAkshayaTritiyaCard(context)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildReferAndEarnCard(context)),
                ],
              );
            }
            return Column(
              children: [
                _buildAkshayaTritiyaCard(context),
                const SizedBox(height: 12),
                _buildReferAndEarnCard(context),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAuspiciousDaysBanner(BuildContext context) {
    return InkWell(
      onTap: controller.onOpenAuspiciousDays,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF7A1F38), Color(0xFF5A1528)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'शुभ मुहूर्त',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Auspicious Days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    controller.nextAuspiciousDayDate.value.isEmpty
                        ? controller.nextAuspiciousDayName.value
                        : '${controller.nextAuspiciousDayName.value} · ${controller.nextAuspiciousDayDate.value}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAkshayaTritiyaCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akshaya Tritiya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '0% making charges up to 10g',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.onOpenGiftGold,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Explore',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.auto_awesome,
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildReferAndEarnCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, const Color(0xFFB8960C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refer & Earn',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Get ₹100 gold for each referral',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.onOpenReferral,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: theme.colorScheme.primary,
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Refer Now',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.people,
            color: Colors.black.withValues(alpha: 0.15),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLiveRateHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, color: Colors.white),
              const SizedBox(width: 6),
              Container(width: 60, height: 12, color: Colors.white),
              const SizedBox(width: 8),
              Container(width: 70, height: 14, color: Colors.white),
            ],
          ),
          Container(width: 40, height: 12, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerRateCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildShimmerPortfolioCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildShimmerPriceChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 160,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }
}
