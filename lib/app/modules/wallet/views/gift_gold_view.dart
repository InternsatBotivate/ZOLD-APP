import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/shimmer_wrapper.dart';
import '../controllers/gift_controller.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/utils/snackbar_utils.dart';

class GiftGoldView extends GetView<GiftController> {
  const GiftGoldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isGold = controller.metalType.value == 'GOLD';
      final metalColors = _getMetalColors(context, isGold);

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 12,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [metalColors.primary, metalColors.primaryDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gift ${isGold ? 'Gold' : 'Silver'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Send ${isGold ? 'Gold' : 'Silver'} to loved ones',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProgressIndicator(context),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.05, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                          child: _buildCurrentStep(
                            context,
                            controller.step.value,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _MetalColors _getMetalColors(BuildContext context, bool isGold) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isGold) {
      return _MetalColors(
        primary: const Color(0xFFB8960C),
        primaryDark: const Color(0xFFD4AF37),
        primaryLight: const Color(0xFFF5E6A3),
        text: const Color(0xFFB8960C),
        bg: isDark
            ? theme.colorScheme.surfaceContainer
            : const Color(0xFFFFF9E8),
      );
    } else {
      return _MetalColors(
        primary: const Color(0xFF94A3B8),
        primaryDark: const Color(0xFF64748B),
        primaryLight: const Color(0xFFCBD5E1),
        text: isDark ? theme.colorScheme.onSurface : const Color(0xFF475569),
        bg: isDark
            ? theme.colorScheme.surfaceContainer
            : const Color(0xFFF8FAFC),
      );
    }
  }

  Widget _buildCurrentStep(BuildContext context, String step) {
    switch (step) {
      case 'metal':
        return _buildMetalStep(context);
      case 'form':
        return _buildFormStep(context);
      case 'amount':
        return _buildAmountStep(context);
      case 'recipient':
        return _buildRecipientStep(context);
      case 'message':
        return _buildMessageStep(context);
      case 'confirm':
        return _buildConfirmStep(context);
      default:
        return _buildMetalStep(context);
    }
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Obx(() {
      final steps = [
        'metal',
        'form',
        'amount',
        'recipient',
        'message',
        'confirm',
      ];
      final currentIdx = steps.indexOf(controller.step.value);
      final isGold = controller.metalType.value == 'GOLD';
      final metalColors = _getMetalColors(context, isGold);

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final stepNames = [
              'Metal',
              'Form',
              'Amount',
              'Recipient',
              'Message',
            ];
            final isActive =
                currentIdx == index || (index == 4 && currentIdx == 5);
            final isCompleted =
                currentIdx > index && !(index == 4 && currentIdx == 5);

            return Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isActive || isCompleted
                              ? LinearGradient(
                                  colors: [
                                    metalColors.primary,
                                    metalColors.primaryDark,
                                  ],
                                )
                              : null,
                          color: isActive || isCompleted
                              ? null
                              : Theme.of(context).colorScheme.surfaceContainer,
                          border: isActive
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: metalColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive || isCompleted
                                  ? Colors.white
                                  : Colors.grey[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stepNames[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (index < 4)
                    Expanded(
                      child: Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          bottom: 14,
                          left: 4,
                          right: 4,
                        ),
                        color: isCompleted
                            ? metalColors.primary
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildMetalStep(BuildContext context) {
    final isGold = controller.metalType.value == 'GOLD';
    final metalColors = _getMetalColors(context, isGold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Metal Type',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetalOption(
                context,
                'GOLD',
                Icons.diamond,
                'Gold',
                '24K Pure Gold',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetalOption(
                context,
                'SILVER',
                Icons.auto_awesome,
                'Silver',
                'Pure Silver',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Obx(() {
          final isRatesLoading = controller.isLoading.value;
          final goldPrice = controller.goldPrice.value;
          final silverPrice = controller.silverPrice.value;
          final isPriceLoaded = goldPrice > 0 && silverPrice > 0;
          final isButtonEnabled = !isRatesLoading && isPriceLoaded;

          return _buildGradientButton(
            context,
            'Next: Choose Form',
            isButtonEnabled ? () => controller.step.value = 'form' : () {},
            metalColors,
            icon: Icons.arrow_forward,
            opacity: isButtonEnabled ? 1.0 : 0.5,
          );
        }),
      ],
    );
  }

  Widget _buildMetalOption(
    BuildContext context,
    String type,
    IconData icon,
    String label,
    String sub,
  ) {
    return Obx(() {
      final isSelected = controller.metalType.value == type;
      final colors = _getMetalColors(context, type == 'GOLD');
      final price = type == 'GOLD'
          ? controller.goldPrice.value
          : controller.silverPrice.value;

      return GestureDetector(
        onTap: () => controller.metalType.value = type,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.bg
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [colors.primary, colors.primaryDark]
                            : [
                                Theme.of(context).colorScheme.surfaceContainer,
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isLoading.value && price == 0) {
                      return ShimmerWrapper(
                        child: Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }
                    return Text(
                      '₹${price.toStringAsFixed(2)}/g',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }),
                ],
              ),
              if (isSelected)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle,
                    color: Color(0xFFB8960C),
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFormStep(BuildContext context) {
    final isGold = controller.metalType.value == 'GOLD';
    final metalColors = _getMetalColors(context, isGold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Gift Type',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFormOption(
                context,
                'VIRTUAL',
                Icons.balance,
                'Virtual',
                'By weight • Any amount',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormOption(
                context,
                'COIN',
                Icons.circle_outlined,
                'Coin',
                'Physical coins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: metalColors.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: metalColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            controller.giftType.value == 'VIRTUAL'
                ? 'Gift any amount of ${controller.metalType.value.toLowerCase()} by weight directly to their wallet.'
                : 'Gift physical ${controller.metalType.value.toLowerCase()} coins in standard denominations.',
            style: TextStyle(color: metalColors.text, fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Back',
                () => controller.step.value = 'metal',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(
                context,
                'Next: Amount',
                () => controller.step.value = 'amount',
                metalColors,
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormOption(
    BuildContext context,
    String type,
    IconData icon,
    String label,
    String sub,
  ) {
    return Obx(() {
      final isSelected = controller.giftType.value == type;
      final isGold = controller.metalType.value == 'GOLD';
      final colors = _getMetalColors(context, isGold);

      return GestureDetector(
        onTap: () => controller.giftType.value = type,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.bg
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [colors.primary, colors.primaryDark]
                            : [
                                Theme.of(context).colorScheme.surfaceContainer,
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle,
                    color: colors.primary,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAmountStep(BuildContext context) {
    final isGold = controller.metalType.value == 'GOLD';
    final metalColors = _getMetalColors(context, isGold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Info
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: metalColors.bg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: metalColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Selected: ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${controller.metalType.value} • ${controller.giftType.value}',
                    style: TextStyle(
                      color: metalColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => controller.step.value = 'form',
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: metalColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Balance Info
        _buildBalanceInfo(context),

        const SizedBox(height: 12),
        Text(
          'Select Occasion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _buildOccasionSelector(context),

        const SizedBox(height: 16),
        if (controller.giftType.value == 'VIRTUAL') ...[
          _buildWeightValueInput(context),
          const SizedBox(height: 24),
          _buildPresetSection(
            context,
            'Pick Weight',
            controller.presetGrams,
            true,
          ),
          const SizedBox(height: 16),
          _buildPresetSection(
            context,
            'Pick Amount',
            controller.presetAmounts,
            false,
          ),
        ] else ...[
          _buildCoinInventoryStep(context),
        ],

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Back',
                () => controller.step.value = 'form',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                final hasError = controller.errorText.value.isNotEmpty;
                final amount = controller.gramsAmount.value;
                final isInvalid = controller.giftType.value == 'VIRTUAL'
                    ? (amount <= 0 || hasError)
                    : (controller.getCoinBalance(
                            controller.selectedCoin.value,
                          ) ==
                          0);

                return _buildGradientButton(
                  context,
                  'Next: Recipient',
                  () {
                    if (hasError) {
                      SnackbarUtils.showError(controller.errorText.value);
                      return;
                    }
                    if (controller.giftType.value == 'VIRTUAL') {
                      if (controller.gramsAmount.value <= 0) {
                        SnackbarUtils.showError('Please enter a valid amount');
                        return;
                      }
                    } else {
                      if (controller.getCoinBalance(
                            controller.selectedCoin.value,
                          ) ==
                          0) {
                        SnackbarUtils.showError(
                          'Please select an available coin',
                        );
                        return;
                      }
                    }
                    controller.step.value = 'recipient';
                  },
                  metalColors,
                  icon: Icons.arrow_forward,
                  opacity: isInvalid ? 0.5 : 1.0,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceInfo(BuildContext context) {
    final isGold = controller.metalType.value == 'GOLD';
    final colors = _getMetalColors(context, isGold);
    final balance = isGold
        ? controller.walletBalance.value?.goldGrams ?? 0.0
        : controller.walletBalance.value?.silverGrams ?? 0.0;
    final totalCoins = controller.coinInventory
        .where((c) => c.metal == controller.metalType.value)
        .fold(0, (sum, c) => sum + c.quantity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR BALANCE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.metalType.value} in Wallet',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${balance.toStringAsFixed(3)}g',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.text,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.metalType.value} Coins',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalCoins coins',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (totalCoins > 0) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [1, 2, 5, 8, 10].map((d) {
                final bal = controller.getCoinBalance(d);
                if (bal == 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    '${d}g × $bal',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeightValueInput(BuildContext context) {
    final colors = _getMetalColors(
      context,
      controller.metalType.value == 'GOLD',
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildInputBox(
                context,
                'Weight (grams)',
                controller.weightController,
                controller.handleWeightChange,
                '0.5',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: controller.handleSwap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              _buildInputBox(
                context,
                'Value (₹)',
                controller.valueController,
                controller.handleValueChange,
                '0.00',
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.errorText.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    controller.errorText.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildInputBox(
    BuildContext context,
    String label,
    TextEditingController textController,
    Function(String) onChanged,
    String hint,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: TextField(
              controller: textController,
              onChanged: onChanged,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                isDense: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionSelector(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      final isGold = controller.metalType.value == 'GOLD';
      final colors = _getMetalColors(context, isGold);
      final selectedOccasion = controller.occasion.value;

      if (controller.occasions.isEmpty) {
        return const SizedBox.shrink();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          // Responsive column count
          final int crossAxisCount = constraints.maxWidth >= 700 ? 4 : 3;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: controller.occasions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,

              // Better than fixed childAspectRatio.
              // Keeps every option readable and consistent.
              mainAxisExtent: 40,
            ),
            itemBuilder: (context, index) {
              final occasion = controller.occasions[index];

              final String id = occasion['id']?.toString() ?? '';
              final String label = occasion['label']?.toString() ?? '';

              final bool isSelected = selectedOccasion == id;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: id.isEmpty
                      ? null
                      : () {
                          controller.occasion.value = id;
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.bg
                          : colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: isSelected
                            ? colors.text
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Text(label),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget _buildPresetSection(
    BuildContext context,
    String title,
    List<dynamic> presets,
    bool isWeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets.map((p) {
              final isSelected = isWeight
                  ? (controller.gramsAmount.value == p &&
                        controller.inputMode.value == 'weight')
                  : (controller.selectedAmount.value == p &&
                        controller.inputMode.value == 'amount');
              final label = isWeight
                  ? '${p}g'
                  : '₹${p >= 1000 ? '${(p / 1000).toStringAsFixed(0)}k' : p}';
              return _buildPresetChip(
                context,
                label,
                () => isWeight
                    ? controller.setFromWeight(p)
                    : controller.setFromAmount(p),
                isSelected,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(
    BuildContext context,
    String label,
    VoidCallback onTap,
    bool isSelected,
  ) {
    final colors = _getMetalColors(
      context,
      controller.metalType.value == 'GOLD',
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.bg
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colors.text
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCoinInventoryStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Coin from Inventory',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            1,
            2,
            5,
            8,
            10,
          ].map((g) => _buildCoinOptionCard(context, g)).toList(),
        ),
        const SizedBox(height: 24),
        Obx(() {
          final balance = controller.getCoinBalance(
            controller.selectedCoin.value,
          );
          final metalColor = controller.metalType.value == 'GOLD'
              ? const Color(0xFFD4AF37)
              : const Color(0xFF94A3B8);

          if (balance > 0) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [metalColor, metalColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: metalColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () {
                        if (controller.coinQuantity.value > 1) {
                          controller.coinQuantity.value--;
                        }
                      }),
                      const SizedBox(width: 16),
                      Text(
                        '${controller.coinQuantity.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildQtyBtn(Icons.add, () {
                        if (controller.coinQuantity.value < balance) {
                          controller.coinQuantity.value++;
                        }
                      }),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: Colors.red, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    'No ${controller.selectedCoin.value}g ${controller.metalType.value} Coins',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You don\'t have any ${controller.selectedCoin.value}g coins in your inventory.',
                    style: TextStyle(
                      color: Colors.red.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                        controller.metalType.value == 'GOLD'
                            ? '/coins'
                            : '/silver-coins',
                      ),
                      icon: const Icon(Icons.shopping_cart, size: 18),
                      label: Text('Buy ${controller.metalType.value} Coins'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCoinOptionCard(BuildContext context, int grams) {
    return Obx(() {
      final isSelected = controller.selectedCoin.value == grams;
      final balance = controller.getCoinBalance(grams);
      final color = controller.metalType.value == 'GOLD'
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);

      return GestureDetector(
        onTap: () {
          controller.selectedCoin.value = grams;
          controller.coinQuantity.value = balance > 0 ? 1 : 0;
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: balance == 0 ? 0.4 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? color : Theme.of(context).dividerColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? color
                        : Theme.of(context).colorScheme.surfaceContainer,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${grams}g',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${grams}g ${controller.metalType.value} Coin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$balance Available',
                  style: TextStyle(
                    color: balance > 0 ? Colors.green : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildRecipientStep(BuildContext context) {
    final colors = _getMetalColors(
      context,
      controller.metalType.value == 'GOLD',
    );
    final price = controller.metalType.value == 'GOLD'
        ? controller.goldPrice.value
        : controller.silverPrice.value;
    final totalValue = controller.giftType.value == 'COIN'
        ? (controller.selectedCoin.value *
              controller.coinQuantity.value *
              price)
        : (controller.gramsAmount.value * price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.bg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Gift: ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${controller.metalType.value} • ${controller.giftType.value} • ₹${totalValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => controller.step.value = 'amount',
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: colors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),

        Text(
          'Recipient Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Mobile Number *',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (val) {
            if (val.length <= 10) controller.recipientPhone.value = val;
          },
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: '9876543210',
            hintStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              Icons.phone_iphone,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          keyboardType: TextInputType.phone,
          maxLength: 10,
        ),

        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLookingUp.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final user = controller.lookupResult.value;
          if (user != null) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    backgroundImage: user.profilePictureUrl != null
                        ? NetworkImage(user.profilePictureUrl!)
                        : null,
                    child: user.profilePictureUrl == null
                        ? Icon(
                            Icons.person,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
            );
          } else if (controller.recipientPhone.value.length == 10) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: const Text(
                'This number is not registered on ZOLD yet.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Back',
                () => controller.step.value = 'amount',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(context, 'Next', () {
                if (controller.lookupResult.value == null) {
                  SnackbarUtils.showError(
                    'Please select a registered ZOLD user',
                  );
                  return;
                }
                controller.step.value = 'message';
              }, colors),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageStep(BuildContext context) {
    final colors = _getMetalColors(
      context,
      controller.metalType.value == 'GOLD',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Message',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (val) => controller.personalMessage.value = val,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Write your wishes... (optional)',
            hintStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          maxLines: 4,
          maxLength: 200,
        ),
        const SizedBox(height: 24),
        Text(
          'Preview Card',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        _buildGiftPreviewCard(context),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Back',
                () => controller.step.value = 'recipient',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(
                context,
                'Review',
                () => controller.step.value = 'confirm',
                colors,
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGiftPreviewCard(BuildContext context) {
    return Obx(() {
      final metal = controller.metalType.value;
      final type = controller.giftType.value;
      final occasion = controller.occasion.value;

      List<Color> gradientColors;
      if (metal == 'GOLD') {
        switch (occasion) {
          case 'birthday':
            gradientColors = [const Color(0xFFB8960C), const Color(0xFFD4AF37)];
            break;
          case 'wedding':
            gradientColors = [const Color(0xFFA6850A), const Color(0xFFB8960C)];
            break;
          case 'anniversary':
            gradientColors = [const Color(0xFFB8960C), const Color(0xFFD4AF37)];
            break;
          case 'diwali':
            gradientColors = [const Color(0xFFD4AF37), const Color(0xFFB8960C)];
            break;
          default:
            gradientColors = [const Color(0xFFD4AF37), const Color(0xFFF5E6A3)];
        }
      } else {
        switch (occasion) {
          case 'birthday':
            gradientColors = [const Color(0xFF94A3B8), const Color(0xFF64748B)];
            break;
          case 'wedding':
            gradientColors = [const Color(0xFF64748B), const Color(0xFF475569)];
            break;
          case 'anniversary':
            gradientColors = [const Color(0xFF94A3B8), const Color(0xFF64748B)];
            break;
          case 'diwali':
            gradientColors = [const Color(0xFF64748B), const Color(0xFF475569)];
            break;
          default:
            gradientColors = [const Color(0xFF94A3B8), const Color(0xFFCBD5E1)];
        }
      }

      final price = controller.metalType.value == 'GOLD'
          ? controller.goldPrice.value
          : controller.silverPrice.value;
      final value = controller.giftType.value == 'COIN'
          ? (controller.selectedCoin.value *
                controller.coinQuantity.value *
                price)
          : (controller.gramsAmount.value * price);

      final valStr = controller.giftType.value == 'COIN'
          ? '${controller.coinQuantity.value}x ${controller.selectedCoin.value}g'
          : '${controller.gramsAmount.value.toStringAsFixed(3)}g';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Icon(
                type == 'COIN' ? Icons.circle : Icons.card_giftcard,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You\'ve received a ${metal.toLowerCase()} ${type == 'COIN' ? 'coin' : 'gift'}!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Someone gifted you $valStr of pure ${metal.toLowerCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Text(
                'Value: ₹${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (controller.personalMessage.value.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  '"${controller.personalMessage.value}"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildConfirmStep(BuildContext context) {
    final colors = _getMetalColors(
      context,
      controller.metalType.value == 'GOLD',
    );
    final price = controller.metalType.value == 'GOLD'
        ? controller.goldPrice.value
        : controller.silverPrice.value;
    final totalValue = controller.giftType.value == 'COIN'
        ? (controller.selectedCoin.value *
              controller.coinQuantity.value *
              price)
        : (controller.gramsAmount.value * price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Gift Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        _buildConfirmCard(
          context,
          'Gift Type',
          '${controller.metalType.value} • ${controller.giftType.value} • ${controller.giftType.value == 'COIN' ? '${controller.coinQuantity.value}x ${controller.selectedCoin.value}g' : '${controller.gramsAmount.value.toStringAsFixed(3)}g'}',
        ),
        const SizedBox(height: 12),
        _buildConfirmCard(
          context,
          'Occasion',
          StringUtils.capitalizeFirst(controller.occasion.value),
        ),
        const SizedBox(height: 12),
        _buildConfirmCard(
          context,
          'Recipient',
          '${controller.recipientName.value} (${controller.recipientPhone.value})',
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL VALUE',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${totalValue.toStringAsFixed(2)}',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '(${controller.giftType.value == 'COIN' ? (controller.selectedCoin.value * controller.coinQuantity.value).toStringAsFixed(3) : controller.gramsAmount.value.toStringAsFixed(3)}g ${controller.metalType.value})',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.bg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            controller.giftType.value == 'COIN'
                ? 'The ${controller.metalType.value.toLowerCase()} coins will be debited from your inventory.'
                : 'The ${controller.metalType.value.toLowerCase()} will be debited from your wallet balance.',
            style: TextStyle(color: colors.text, fontSize: 12, height: 1.4),
          ),
        ),

        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Back',
                () => controller.step.value = 'message',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGradientButton(
                context,
                'Send Gift',
                controller.sendGift,
                colors,
                icon: Icons.send,
                isLoading: controller.isProcessing.value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmCard(BuildContext context, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(
    BuildContext context,
    String label,
    VoidCallback? onTap,
    _MetalColors colors, {
    IconData? icon,
    bool isLoading = false,
    double opacity = 1.0,
  }) {
    return GestureDetector(
      onTap: (isLoading || onTap == null) ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: opacity,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (opacity == 1.0 && !isLoading)
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(icon, color: Colors.white, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    bool isPrimary = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: isPrimary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetalColors {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color text;
  final Color bg;

  _MetalColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.text,
    required this.bg,
  });
}
