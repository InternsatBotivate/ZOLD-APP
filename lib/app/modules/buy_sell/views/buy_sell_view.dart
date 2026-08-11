import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/purchase_models.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/buy_sell_controller.dart';
import '../../../routes/app_routes.dart';
import 'widgets/metal_button.dart';

class BuySellView extends GetView<BuySellController> {
  const BuySellView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.handleClose();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Obx(() {
            final session = controller.session.value;
            // Always prioritize backend session data for UI state
            final isGold = session != null 
                ? session.metalType.toUpperCase() == 'GOLD'
                : controller.metalType.value == 'GOLD';
            final isBuy = session != null
                ? session.transactionType.toUpperCase() == 'BUY'
                : controller.actionType.value == 'BUY';

            return Stack(
              children: [
                // Background Gradient/Color
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      gradient: isDark
                          ? null
                          : LinearGradient(
                              colors: isGold
                                  ? [
                                      const Color(0xFFFFFDF5),
                                      const Color(0xFFFDF7DE),
                                      const Color(0xFFF6E7B8),
                                    ]
                                  : [
                                      const Color(0xFFF4F6F8),
                                      const Color(0xFFE2E8F0),
                                      const Color(0xFFA8B3C2),
                                    ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    _buildHeader(context, isGold, isBuy),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: controller.isError.value
                                ? _buildErrorState(
                                    context,
                                    key: const ValueKey('error'),
                                  )
                                : _buildMainContent(
                                    context,
                                    isGold,
                                    isBuy,
                                    key: const ValueKey('content'),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Leave Confirmation Dialog
                if (controller.showLeaveDialog.value)
                  _buildLeaveDialog(context),

                // Payment Processing Overlay
                Obx(
                  () => PaymentProcessingOverlay(
                    statusText: controller.paymentStatus.value,
                    isVisible: controller.isProcessing.value,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    bool isGold,
    bool isBuy, {
    Key? key,
  }) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: AppColors.primaryGold,
      child: Scrollbar(
        thickness: 4,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          key: key,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 24.0,
            bottom: MediaQuery.of(context).padding.bottom + 24.0,
          ),
          child: Column(
            children: [
              // Only show input cards when in input state
              if (controller.currentState.value == BuySellState.input) ...[
                if (!isBuy) _buildSellCards(context, isGold),
                if (isBuy) _buildLiveRateCard(context, isGold, isBuy),
                const SizedBox(height: 24),
                _buildAmountInputSection(context, isGold),

                // Range Error Banner (Buy)
                if (controller.rangeError.value.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      controller.rangeError.value,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Insufficient Balance Banner (Sell)
                if (controller.isInsufficientBalance.value)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      'Insufficient ${isGold ? 'Gold' : 'Silver'}. Available: ${controller.currentBalance.value.toStringAsFixed(3)}g',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],

              // States: Review or Success
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: controller.currentState.value == BuySellState.review
                    ? _buildReviewState(
                        context,
                        isGold,
                        isBuy,
                        key: const ValueKey('review'),
                      )
                    : controller.currentState.value == BuySellState.success
                    ? _buildSuccessState(
                        context,
                        isGold,
                        isBuy,
                        key: const ValueKey('success'),
                      )
                    : _buildInputComponents(
                        context,
                        isGold,
                        isBuy,
                        key: const ValueKey('input'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, {Key? key}) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: AppColors.primaryGold,
      child: SingleChildScrollView(
        key: key,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: controller.retry,
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Or pull down to refresh',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputComponents(
    BuildContext context,
    bool isGold,
    bool isBuy, {
    Key? key,
  }) {
    return Column(
      key: key,
      children: [
        if (controller.totalAmount.value > 0)
          _buildPriceBreakdown(context, isBuy, isGold),
        const SizedBox(height: 16),
        if (isGold) _buildPurityCard(context),
        const SizedBox(height: 12),
        _buildImportantNotes(context, isBuy, isGold),
        const SizedBox(height: 24),
        if (!isBuy) _buildProceedCheckbox(context, isGold),
        const SizedBox(height: 16),
        MetalButton(
          text: _getButtonText(isBuy, isGold),
          isGold: isGold,
          isLoading: controller.isProcessing.value,
          onTap: (controller.isInputValid && !controller.isProcessing.value)
              ? controller.proceedToReview
              : null,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isGold, bool isBuy) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headerGradient = isDark
        ? LinearGradient(
            colors: isGold
                ? [const Color(0xFFEBD89E), const Color(0xFFF1DDA5)]
                : [const Color(0xFFB0B8C6), const Color(0xFF9EA8B7)],
          )
        : isGold
        ? const LinearGradient(colors: [Color(0xFFF6E8BD), Color(0xFFF1DDA5)])
        : const LinearGradient(colors: [Color(0xFFD7DDE6), Color(0xFFB0B8C6)]);

    final textColor = const Color(0xFF1A1A2E);

    return Container(
      decoration: BoxDecoration(
        gradient: headerGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  // Balanced Header: Back button on left, empty space of same size on right
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: controller.handleClose,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMetalTab(context, 'GOLD', isGold, isDark),
                        const SizedBox(width: 32),
                        _buildMetalTab(context, 'SILVER', !isGold, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to balance the back button
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final tabWidth = constraints.maxWidth / 2;
                      return Stack(
                        children: [
                          Row(
                            children: [
                              _buildActionTab(context, 'BUY', isBuy, isDark),
                              _buildActionTab(context, 'SELL', !isBuy, isDark),
                            ],
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            bottom: 0,
                            left: isBuy ? 0 : tabWidth,
                            child: Container(
                              height: 2,
                              width: tabWidth,
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetalTab(
    BuildContext context,
    String metal,
    bool isActive,
    bool isDark,
  ) {
    final textColor = const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: () {
        if (controller.session.value == null && !isActive) {
          FocusScope.of(context).unfocus();
          controller.metalType.value = metal;
        }
      },
      child: Column(
        children: [
          Text(
            metal,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: isActive ? textColor : textColor.withValues(alpha: 0.35),
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: textColor.withValues(alpha: 0.7),
            ),
        ],
      ),
    );
  }

  Widget _buildActionTab(
    BuildContext context,
    String action,
    bool isActive,
    bool isDark,
  ) {
    final textColor = const Color(0xFF1A1A2E);
    return Expanded(
      child: InkWell(
        onTap: () {
          if (controller.session.value == null && !isActive) {
            FocusScope.of(context).unfocus();
            controller.actionType.value = action;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Text(
            action,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? textColor : textColor.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }

  String _getButtonText(bool isBuy, bool isGold) {
    if (controller.currentRate.value <= 0) return 'Rate Unavailable';
    if (controller.metalGrams.value <= 0) return 'Enter an amount';
    final amount = isBuy
        ? controller.finalPayable
        : controller.totalAmount.value;
    return '${isBuy ? 'Buy' : 'Sell'} ${isGold ? 'Gold' : 'Silver'} • ₹${NumberFormat('#,##,##0').format(amount)}';
  }

  Widget _buildSellCards(BuildContext context, bool isGold) {
    final accentColor = isGold
        ? const Color(0xFFEEC762)
        : const Color(0xFF9EA8B7);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 350;
        return Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                context,
                isGold: isGold,
                title: 'Available to Sell',
                value: '${controller.currentBalance.value.toStringAsFixed(3)}g',
                subValue:
                    '≈ ₹${NumberFormat('#,##,##0').format(controller.currentBalance.value * controller.sellPrice.value)}',
                icon: Icons.account_balance_wallet_outlined,
                iconColor: accentColor,
                isSmall: isSmall,
                isLoading: controller.isLoading.value && controller.currentBalance.value <= 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                context,
                isGold: isGold,
                title: 'Sell Rate',
                value:
                    '₹${NumberFormat('#,##,##0').format(controller.sellPrice.value)}/g',
                subValue:
                    '-${controller.spreadPercentage.toStringAsFixed(2)}% spread',
                icon: Icons.trending_down,
                iconColor: Colors.red,
                showPing: true,
                isSmall: isSmall,
                isLoading: controller.isLoading.value && controller.sellPrice.value <= 0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required bool isGold,
    required String title,
    required String value,
    required String subValue,
    required IconData icon,
    required Color iconColor,
    bool showPing = false,
    bool isSmall = false,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.1 : 0.2),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showPing) ...[
                const _PulseDot(),
                const SizedBox(width: 4),
              ] else
                Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmall ? 8 : 10,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (isLoading || (controller.isLoading.value && (value.contains('0') || value.isEmpty)))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: _buildShimmerSkeleton(
                context,
                height: isSmall ? 14 : 16,
                width: 80,
                isGold: isGold,
                borderRadius: 4,
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: isSmall ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          const SizedBox(height: 2),
          if (isLoading || (controller.isLoading.value && (subValue.contains('0') || subValue.isEmpty)))
            _buildShimmerSkeleton(
              context,
              height: isSmall ? 8 : 10,
              width: 60,
              isGold: isGold,
              borderRadius: 2,
            )
          else
            Text(
              subValue,
              style: TextStyle(
                fontSize: isSmall ? 8 : 10,
                color: title.contains('Rate')
                    ? Colors.red
                    : theme.textTheme.bodySmall?.color,
                fontWeight: title.contains('Rate')
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountInputSection(BuildContext context, bool isGold) {
    final accentColor = isGold
        ? const Color(0xFFEEC762)
        : const Color(0xFFADB8BF);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isInputEnabled =
        controller.session.value == null && !controller.isProcessing.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : const Color(0xFFFDF8E8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? theme.dividerColor
              : const Color(0xFFE4CD8E).withValues(alpha: 0.5),
        ),
      ),
      child: Opacity(
        opacity: isInputEnabled ? 1.0 : 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? theme.textTheme.bodyMedium?.color
                    : const Color(0xFF5A4A1A),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    context,
                    controller: controller.amountController,
                    focusNode: controller.amountFocusNode,
                    prefix: '₹',
                    hint: 'Amount',
                    isGold: isGold,
                    enabled: isInputEnabled,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: isInputEnabled ? controller.handleSwap : null,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.swap_horiz,
                        color: isDark
                            ? theme.colorScheme.primary
                            : const Color(0xFF1A1A2E),
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildInputField(
                    context,
                    controller: controller.gramsController,
                    focusNode: controller.gramsFocusNode,
                    suffix: 'g',
                    hint: 'Grams',
                    isGold: isGold,
                    enabled: isInputEnabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildAmountPresets(
              context,
              isGold,
              accentColor,
              enabled: isInputEnabled,
            ),
            const SizedBox(height: 12),
            _buildGramsPresets(
              context,
              isGold,
              accentColor,
              enabled: isInputEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    FocusNode? focusNode,
    String? prefix,
    String? suffix,
    required String hint,
    required bool isGold,
    bool enabled = true,
  }) {
    final accentColor = isGold
        ? const Color(0xFFEEC762)
        : const Color(0xFF9EA8B7);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: prefix != null
              ? Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    prefix,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              : null,
          suffixIcon: suffix != null
              ? Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    suffix,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              : null,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isGold
                  ? (isDark ? theme.colorScheme.primary : accentColor)
                  : accentColor,
              width: 2,
            ),
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildAmountPresets(
    BuildContext context,
    bool isGold,
    Color accentColor, {
    bool enabled = true,
  }) {
    final amounts = [1000.0, 5000.0, 25000.0, 100000.0];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: List.generate(amounts.length * 2 - 1, (index) {
        if (index.isOdd) return const SizedBox(width: 12);

        final amountIndex = index ~/ 2;
        final amount = amounts[amountIndex];
        final label = amount >= 100000
            ? '₹${(amount / 100000).toStringAsFixed(0)}L'
            : '₹${(amount / 1000).toStringAsFixed(0)}k';
        final isSelected =
            (double.tryParse(
                  controller.amountController.text.replaceAll(',', ''),
                ) ??
                0) ==
            amount;

        return Expanded(
          child: _buildPresetButton(
            label: label,
            isSelected: isSelected,
            onTap: enabled ? () => controller.selectAmount(amount) : () {},
            theme: theme,
            isDark: isDark,
            accentColor: accentColor,
            isGold: isGold,
          ),
        );
      }),
    );
  }

  Widget _buildGramsPresets(
    BuildContext context,
    bool isGold,
    Color accentColor, {
    bool enabled = true,
  }) {
    final grams = [1.0, 2.0, 5.0, 10.0];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: List.generate(grams.length * 2 - 1, (index) {
        if (index.isOdd) return const SizedBox(width: 12);

        final gramIndex = index ~/ 2;
        final g = grams[gramIndex];
        final isSelected =
            (double.tryParse(controller.gramsController.text) ?? 0) == g;

        return Expanded(
          child: _buildPresetButton(
            label: '${g.toStringAsFixed(0)}g',
            isSelected: isSelected,
            onTap: enabled ? () => controller.selectGrams(g) : () {},
            theme: theme,
            isDark: isDark,
            accentColor: accentColor,
            isGold: isGold,
          ),
        );
      }),
    );
  }

  Widget _buildPresetButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
    required Color accentColor,
    required bool isGold,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isGold
                    ? (isDark ? theme.colorScheme.primary : accentColor)
                    : accentColor)
              : (isDark
                    ? theme.colorScheme.surface
                    : Colors.white.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? (isGold
                            ? (isDark ? theme.colorScheme.primary : accentColor)
                            : accentColor)
                        .withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isSelected
                  ? (isGold
                        ? (isDark ? Colors.black : const Color(0xFF1A1A2E))
                        : (isDark ? Colors.white : const Color(0xFF1A1A2E)))
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(BuildContext context, bool isBuy, bool isGold) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Improved high-contrast colors for visibility
    final titleColor = isDark ? Colors.white60 : Colors.black45;
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    final totalValueColor = isGold
        ? (isDark ? theme.colorScheme.primary : const Color(0xFF8B6B00))
        : (isDark ? Colors.white : const Color(0xFF1A202C));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          if (controller.isLoading.value && controller.totalAmount.value <= 0)
            Column(
              children: [
                _buildShimmerSkeleton(context, height: 14, isGold: isGold, borderRadius: 4),
                const SizedBox(height: 12),
                _buildShimmerSkeleton(context, height: 14, isGold: isGold, borderRadius: 4),
                const SizedBox(height: 12),
                Divider(color: theme.dividerColor),
                const SizedBox(height: 12),
                _buildShimmerSkeleton(context, height: 20, isGold: isGold, borderRadius: 6),
              ],
            )
          else ...[
            _buildSummaryRow(
              context,
              '${isGold ? 'Gold' : 'Silver'} Value (${controller.metalGrams.value.toStringAsFixed(3)}g)',
              '₹${NumberFormat('#,##,##0').format(controller.totalAmount.value)}',
              labelColor: labelColor,
            ),
            if (isBuy) ...[
              const SizedBox(height: 12),
              _buildSummaryRow(
                context,
                'GST (${controller.gstRate.value.toStringAsFixed(0)}%)',
                '₹${NumberFormat('#,##,##0').format(controller.gstAmount)}',
                labelColor: labelColor,
              ),
              const SizedBox(height: 12),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '₹${NumberFormat('#,##,##0').format(controller.finalPayable)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: totalValueColor,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              _buildSummaryRow(
                context,
                'GST',
                'Not applicable',
                valueColor: Colors.green,
                labelColor: labelColor,
              ),
              const SizedBox(height: 12),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '₹${NumberFormat('#,##,##0').format(controller.totalAmount.value)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: totalValueColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    Color? labelColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: labelColor ?? theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPurityCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1C15) : const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '24K',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '24 Carat Gold (99.9% Purity)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFEBD89E)
                        : const Color(0xFF3D2F0A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Hallmarked & BIS certified',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotes(BuildContext context, bool isBuy, bool isGold) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1B2333)
            : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Important Notes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isBuy
                      ? 'Stored securely in Zold Vault with AT Plus Jewellers'
                      : 'Amount will be credited within 2 Working Days',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.8)
                        : Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedCheckbox(BuildContext context, bool isGold) {
    final isValidAmount =
        controller.metalGrams.value > 0 &&
        !controller.isInsufficientBalance.value;
    if (!isValidAmount) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: controller.isProceedChecked.value,
            onChanged: (v) => controller.isProceedChecked.value = v ?? false,
            activeColor: isGold
                ? const Color(0xFFEEC762)
                : const Color(0xFF9EA8B7),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I understand that by proceeding, I am selling ${controller.metalGrams.value.toStringAsFixed(3)} grams of ${isGold ? 'gold' : 'silver'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This action is irreversible. Your metal will be deducted from your vault balance and amount will be credited within 2 Working Days.',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveRateCard(BuildContext context, bool isGold, bool isBuy) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isGold 
              ? const Color(0xFFE4CD8E).withValues(alpha: 0.3)
              : theme.dividerColor,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _PulseDot(),
              const SizedBox(width: 8),
              Text(
                'Live ${isGold ? 'Gold' : 'Silver'} Rate',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.isLoading.value && controller.buyPrice.value <= 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _buildShimmerSkeleton(
                context,
                height: 32,
                width: 180,
                isGold: isGold,
                borderRadius: 8,
              ),
            )
          else
            SizedBox(
              height: 40,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  '₹${NumberFormat('#,##,##0').format(controller.buyPrice.value)}/g',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            isGold ? '24K · 99.9% Pure' : '99.9% Fine Silver',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSkeleton(
    BuildContext context, {
    required double height,
    double? width,
    required bool isGold,
    double borderRadius = 20,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return _ShimmerWrapper(
      isGold: isGold,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: (isGold ? const Color(0xFFEEC762) : const Color(0xFF9EA8B7))
                .withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewState(
    BuildContext context,
    bool isGold,
    bool isBuy, {
    Key? key,
  }) {
    final session = controller.session.value;
    if (session == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isGold
        ? (isDark ? theme.colorScheme.primary : const Color(0xFF8B6B00))
        : (isDark ? Colors.white : const Color(0xFF2D3748));

    return Column(
      key: key,
      children: [
        _buildReviewCard(context, session, isBuy, accentColor, isDark),
        const SizedBox(height: 24),
        if (!isBuy) _buildIrreversibleWarning(context, session, isGold, isDark),
        const SizedBox(height: 24),
        if (isBuy) _buildSecurePaymentInfo(isDark),
        const SizedBox(height: 32),
        MetalButton(
          text: isBuy
              ? 'Pay ₹${NumberFormat('#,##,##0').format(session.finalAmount)}'
              : 'Confirm Sale • ₹${NumberFormat('#,##,##0').format(session.finalAmount)}',
          isGold: isGold,
          isLoading: controller.isProcessing.value,
          onTap: controller.isProcessing.value
              ? null
              : controller.executeTransaction,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: controller.isProcessing.value
                ? null
                : controller.cancelSession,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            size: 14,
            color: Color(0xFFC2410C),
          ),
          const SizedBox(width: 6),
          Text(
            'Valid for ',
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFFC2410C).withValues(alpha: 0.8),
            ),
          ),
          Obx(
            () => Text(
              controller.timerText,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC2410C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurePaymentInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Secure payment by Razorpay',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose UPI, card, net banking or wallet in the next step.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    MetalPurchaseSession session,
    bool isBuy,
    Color accentColor,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Text(
                'Order Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              _buildTimerHeader(isDark),
            ],
          ),
          const SizedBox(height: 24),
          _buildReviewRow(
            context,
            '${session.metalType.toUpperCase()} (${session.metalGrams.toStringAsFixed(3)}g)',
            '₹${NumberFormat('#,##,##0').format(session.totalAmount)}',
            isDark,
          ),
          const SizedBox(height: 12),
          if (isBuy)
            _buildReviewRow(
              context,
              'GST (${session.gstRate.toStringAsFixed(0)}%)',
              '₹${NumberFormat('#,##,##0').format(session.gst)}',
              isDark,
            )
          else
            _buildReviewRow(
              context,
              'GST',
              'Not applicable',
              isDark,
              valueColor: Colors.green,
            ),
          const SizedBox(height: 16),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '₹${NumberFormat('#,##,##0').format(session.finalAmount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIrreversibleWarning(
    BuildContext context,
    MetalPurchaseSession session,
    bool isGold,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action is irreversible',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.orange : Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.metalGrams.toStringAsFixed(3)}g of ${isGold ? 'gold' : 'silver'} will be permanently deducted from your vault. Amount credited within 2 working days.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? theme.textTheme.bodySmall?.color
                        : Colors.brown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    bool isGold,
    bool isBuy, {
    Key? key,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isGold
        ? (isDark ? theme.colorScheme.primary : const Color(0xFF8B6B00))
        : (isDark ? Colors.white : const Color(0xFF2D3748));

    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      key: key,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24, 
            vertical: screenHeight * 0.04, // Responsive vertical padding
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                '${isBuy ? 'Purchase' : 'Sale'} Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                    children: [
                      const TextSpan(text: 'You have successfully '),
                      TextSpan(
                        text: isBuy ? 'purchased ' : 'sold ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '${controller.metalGrams.value.toStringAsFixed(3)}g ',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                        ),
                      ),
                      TextSpan(
                        text: 'of ${isGold ? 'Gold' : 'Silver'}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surfaceContainer : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  children: [
                    Text(
                      isBuy ? 'TOTAL AMOUNT PAID' : 'SETTLEMENT AMOUNT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₹${NumberFormat('#,##,##0').format(isBuy ? controller.finalPayable : controller.totalAmount.value)}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isBuy) ...[
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Settlement in Progress',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Funds will be credited to your wallet within 2 working days. We\'ll notify you once processed.',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF2563EB).withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        MetalButton(
          text: 'View Portfolio',
          isGold: isGold,
          onTap: controller.viewPortfolio,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Get.offAllNamed(Routes.home),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Obx(() => Text(
              'Back to Home (${controller.redirectCountdown.value}s)',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: isDark ? Border.all(color: theme.dividerColor) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Leave transaction?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your active session will be cancelled if you leave. You\'ll need to start a new transaction with updated rates.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.showLeaveDialog.value = false,
                      child: Text(
                        'Stay',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.confirmLeave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Leave',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerWrapper extends StatefulWidget {
  final Widget child;
  final bool isGold;
  const _ShimmerWrapper({required this.child, required this.isGold});

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = widget.isGold
        ? const Color(0xFFEEC762)
        : const Color(0xFF9EA8B7);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value, -1.0),
              end: Alignment(_animation.value + 1.0, 1.0),
              colors: [
                baseColor.withValues(alpha: isDark ? 0.05 : 0.1),
                baseColor.withValues(alpha: isDark ? 0.3 : 0.5),
                baseColor.withValues(alpha: isDark ? 0.05 : 0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
