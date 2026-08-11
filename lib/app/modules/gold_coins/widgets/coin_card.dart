import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/coin_models.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/gold_coins_controller.dart';
import '../../../core/theme/app_colors.dart';

class CoinCard extends StatelessWidget {
  final CoinType coin;

  const CoinCard({super.key, required this.coin});

  void _handleAddToCart() {
    final cartController = Get.find<CartController>();
    cartController.addItem(coin.grams, coin.metal);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoldCoinsController>();
    final cartController = Get.find<CartController>();
    final isGold = coin.metal == 'GOLD';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final inCart = cartController.cartItems.any(
        (i) => i.weight == coin.grams && i.metal.toUpperCase() == coin.metal,
      );
      final qty = inCart
          ? cartController.cartItems
                .firstWhere(
                  (i) =>
                      i.weight == coin.grams &&
                      i.metal.toUpperCase() == coin.metal,
                )
                .quantity
          : 0;

      final isWishlisted = controller.wishlist.contains(coin.grams);

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: inCart
                  ? (isGold ? AppColors.primaryGold : colorScheme.outline)
                  : colorScheme.outline.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: inCart ? 0.08 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {}, // For ripple
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Popular Badge
                          if (coin.isPopular)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isGold
                                      ? AppColors.primaryGold.withValues(
                                          alpha: 0.1,
                                        )
                                      : colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Popular',
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isGold
                                        ? AppColors.darkGold
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),

                          // Wishlist Icon
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  controller.toggleWishlist(coin.grams),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withValues(
                                    alpha: 0.9,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: Icon(
                                    isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    key: ValueKey(isWishlisted),
                                    size: 16,
                                    color: isWishlisted
                                        ? Colors.red
                                        : colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Product Image - Maximized size
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(
                                  isGold
                                      ? 'assets/images/${coin.grams.toInt()}gmZold.webp'
                                      : 'assets/images/silver-Zold-Bar.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: colorScheme.outline,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isGold
                                  ? AppColors.primaryGold.withValues(alpha: 0.1)
                                  : colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isGold ? '24K' : '999',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isGold
                                    ? AppColors.darkGold
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${coin.grams.toInt()}g ${isGold ? 'Gold' : 'Silver'}',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            coin.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${coin.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Action Button
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: inCart
                                ? _buildQuantityControl(
                                    context,
                                    qty,
                                    cartController,
                                  )
                                : _buildAddToCartButton(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAddToCartButton(BuildContext context) {
    final isGold = coin.metal == 'GOLD';
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      key: const ValueKey('add_to_cart'),
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: _handleAddToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGold
              ? AppColors.primaryGold
              : colorScheme.onSurface,
          foregroundColor: isGold ? Colors.black : colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 16),
            const SizedBox(width: 8),
            Text(
              'Add to Cart',
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl(
    BuildContext context,
    int qty,
    CartController cartController,
  ) {
    final isGold = coin.metal == 'GOLD';
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      key: const ValueKey('quantity_control'),
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGold
              ? AppColors.primaryGold.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => cartController.removeItem(coin.grams, coin.metal),
            icon: const Icon(Icons.remove, size: 16),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
            padding: EdgeInsets.zero,
            color: AppColors.primaryGold,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Text(
              '$qty',
              key: ValueKey(qty),
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => cartController.addItem(coin.grams, coin.metal),
            icon: const Icon(Icons.add, size: 16),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
            padding: EdgeInsets.zero,
            color: AppColors.primaryGold,
          ),
        ],
      ),
    );
  }
}
