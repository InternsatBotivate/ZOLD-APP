import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../../../data/models/coin_models.dart';
import '../controllers/coin_checkout_controller.dart';
import '../../../core/widgets/shimmer_wrapper.dart';
import '../../../routes/app_routes.dart';

class CoinCheckoutView extends GetView<CoinCheckoutController> {
  const CoinCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildBody(context),
              );
            }),
            // ...
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value && controller.session.value == null) {
      return _buildShimmerLoading(context, key: const ValueKey('loading'));
    }

    if (controller.sessionExpired.value) {
      return _buildExpiredState(context, key: const ValueKey('expired'));
    }

    if (controller.paid.value) {
      return _buildSuccessState(context, key: const ValueKey('success'));
    }

    final session = controller.session.value;
    if (session == null) {
      return const Center(
        key: ValueKey('none'),
        child: Text('No active session found'),
      );
    }

    return SafeArea(
      child: Scrollbar(
        thickness: 4,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          key: const ValueKey('content'),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummary(context, session),
              const SizedBox(height: 16),
              _buildRazorpayInfo(context),
              const SizedBox(height: 16),
              _buildSessionWarning(),
              const SizedBox(height: 24),
              _buildPayButton(context, session),
              const SizedBox(height: 16),
              _buildCancelButton(),
              const SizedBox(height: 24),
              _buildTrustBadges(context),
              const SizedBox(height: 24),
              _buildAssuranceCard(context, session),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: 40,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => controller.cancelSession(),
      ),
      title: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/02.png', height: 30),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ZOLD GOLD',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ Secure Checkout',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Obx(() {
          final timeLeft = controller.remainingTime.value;
          final color = timeLeft <= 60
              ? Colors.red
              : (timeLeft <= 120 ? Colors.orange : Colors.green[600]!);
          final bg = timeLeft <= 60
              ? Colors.red.withValues(alpha: 0.1)
              : (timeLeft <= 120
                    ? Colors.orange.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1));
          final border = timeLeft <= 60
              ? Colors.red.withValues(alpha: 0.2)
              : (timeLeft <= 120
                    ? Colors.orange.withValues(alpha: 0.2)
                    : Colors.green.withValues(alpha: 0.2));

          final minutes = timeLeft ~/ 60;
          final seconds = timeLeft % 60;

          return Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Theme.of(context).dividerColor, height: 1),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CoinPurchaseSession session) {
    final totalItems = session.items.fold(0, (sum, i) => sum + i.quantity);
    final totalWeight = session.items.fold(
      0.0,
      (sum, i) => sum + (i.weight * i.quantity),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: 8),
                Text(
                  'Order Summary',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '$totalItems items',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: session.items.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              final item = session.items[index];
              final isSilver = item.metal == 'SILVER';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Image.asset(
                        isSilver
                            ? 'assets/images/silver-Zold-Bar.png'
                            : 'assets/images/${item.weight.toInt()}gmZold.webp',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ZG ${item.weight.toInt()}g ${isSilver ? 'Silver' : 'Gold'} Mint Bar',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${(item.basePrice + item.gst).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              children: [
                _summaryRow(
                  'Subtotal (${totalWeight.toInt()}g total)',
                  '₹${session.totalBasePrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  'GST (3%)',
                  '₹${session.totalGst.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '₹${session.totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRazorpayInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, size: 20, color: Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure payment by Razorpay',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  'Choose UPI, card, net banking or wallet in the next step.',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionWarning() {
    return Obx(() {
      if (controller.remainingTime.value > 60) return const SizedBox.shrink();

      final timeLeft = controller.remainingTime.value;
      final minutes = timeLeft ~/ 60;
      final seconds = timeLeft % 60;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Only ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} left! Complete payment or cart will be cleared.',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPayButton(BuildContext context, CoinPurchaseSession session) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (controller.isProcessing.value || controller.paid.value)
            ? null
            : controller.initiatePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: AppColors.primaryGold.withValues(alpha: 0.3),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkGold, AppColors.primaryGold],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: controller.isProcessing.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: isDark ? Colors.black : Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Proceed to Pay ₹${session.totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: controller.isProcessing.value
            ? null
            : () => controller.cancelSession(),
        child: Text(
          'Cancel',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: controller.isProcessing.value ? Colors.grey : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadges(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _trustItem(context, Icons.verified_user, 'Secure', Colors.green),
        const SizedBox(width: 24),
        _trustItem(context, Icons.lock, 'Encrypted', Colors.blue),
        const SizedBox(width: 24),
        _trustItem(
          context,
          Icons.local_shipping,
          'Insured',
          AppColors.primaryGold,
        ),
      ],
    );
  }

  Widget _trustItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildAssuranceCard(
    BuildContext context,
    CoinPurchaseSession session,
  ) {
    final hasGold = session.items.any((i) => i.metal == 'GOLD');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFFAEBB1),
        ),
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFDFCF5), Colors.white],
              ),
      ),
      child: Column(
        children: [
          _assuranceItem(
            context,
            hasGold
                ? '24K certified gold — 999.9 purity'
                : '999 fine silver certified purity',
          ),
          const SizedBox(height: 8),
          _assuranceItem(context, 'Tamper-proof packaging & insured delivery'),
          const SizedBox(height: 8),
          _assuranceItem(context, 'Easy buyback at live market rates'),
          const SizedBox(height: 8),
          _assuranceItem(context, '7-day return & quality guarantee'),
        ],
      ),
    );
  }

  Widget _assuranceItem(BuildContext context, String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 14, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiredState(BuildContext context, {required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, size: 40, color: Colors.red),
          ),
          const SizedBox(height: 24),
          Text(
            'Session Expired',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your 5-minute checkout session has expired and your cart has been cleared for security.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              'Returning to shop in ${controller.expiredCountdown.value}s...',
              style: GoogleFonts.lato(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () =>
                  Get.until((route) => Get.currentRoute == Routes.goldCoins),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Return to Shop',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, {required Key key}) {
    final session = controller.session.value!;
    final totalAmount = session.totalAmount;
    final orderId =
        'ZG${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      key: key,
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.darkGold,
                      AppColors.primaryGold,
                      AppColors.darkGold,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColors.primaryGold,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Purchase Complete!',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your coins have been added to your inventory',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.bgDark.withValues(alpha: 0.5)
                            : Colors.amber[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ...session.items.map(
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${i.quantity}x ${i.weight.toInt()}g ${i.metal == 'SILVER' ? 'Silver' : 'Gold'} Coin',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '₹${(i.basePrice).toInt().toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 16,
                            color: Theme.of(context).dividerColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Paid',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '₹${totalAmount.toInt().toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Order #$orderId',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.offAllNamed(
                              Routes.home,
                              arguments: {'tab': 1},
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Portfolio',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.offAllNamed(Routes.home),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Obx(
                              () => Text(
                                'Home (${controller.popupCountdown.value}s)',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildShimmerLoading(BuildContext context, {required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerWrapper(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShimmerWrapper(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShimmerWrapper(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.lato(color: color, fontSize: 14)),
        Text(value, style: GoogleFonts.lato(color: color, fontSize: 14)),
      ],
    );
  }
}
