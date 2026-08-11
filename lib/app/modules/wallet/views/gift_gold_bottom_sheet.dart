import '../../../core/utils/string_utils.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gift_controller.dart';
import '../../../core/utils/snackbar_utils.dart';

class GiftGoldBottomSheet extends GetView<GiftController> {
  const GiftGoldBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(36),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildProgressIndicator(context),
                Expanded(
                  child: Obx(() {
                    switch (controller.step.value) {
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
                  }),
                ),
              ],
            ),
          ),

          // Payment Processing Overlay
          Obx(
            () => PaymentProcessingOverlay(
              isVisible: controller.isProcessing.value,
              statusText: controller.paymentStatus.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final isGold = controller.metalType.value == 'GOLD';
      final metalColor = isGold
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: metalColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gift ${isGold ? 'Gold' : 'Silver'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Send ${isGold ? 'Gold' : 'Silver'} to loved ones',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      );
    });
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
      final metalColor = isGold
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);

      return Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final isActive = currentIdx >= index;
                final isLast = index == 4;
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? metalColor
                              : Theme.of(context).colorScheme.surfaceContainer,
                          border: isActive
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: metalColor.withValues(alpha: 0.3),
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
                              color: isActive
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: currentIdx > index
                                ? metalColor
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              'Step ${currentIdx + 1}: ${StringUtils.capitalizeFirst(controller.step.value)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMetalStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Metal Type',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
              children: [
                _buildMetalOption(
                  context,
                  'GOLD',
                  Icons.workspace_premium,
                  'Gold',
                  '24K Pure Gold',
                  const Color(0xFFD4AF37),
                ),
                _buildMetalOption(
                  context,
                  'SILVER',
                  Icons.auto_awesome,
                  'Silver',
                  'Pure Silver',
                  const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
          _buildNextButton(
            'Next: Choose Form',
            () => controller.step.value = 'form',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildMetalOption(
    BuildContext context,
    String type,
    IconData icon,
    String label,
    String sub,
    Color color,
  ) {
    return Obx(() {
      final isSelected = controller.metalType.value == type;
      return GestureDetector(
        onTap: () => controller.metalType.value = type,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? color
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '₹${type == 'GOLD' ? controller.goldPrice.value.toStringAsFixed(2) : controller.silverPrice.value.toStringAsFixed(2)}/g',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFormStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Gift Type',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                _buildFormOption(
                  context,
                  'VIRTUAL',
                  Icons.account_balance_wallet,
                  'Virtual',
                  'Send by weight',
                ),
                _buildFormOption(
                  context,
                  'COIN',
                  Icons.circle,
                  'Coin',
                  'Physical coins',
                ),
              ],
            ),
          ),
          _buildStepActions(
            () => controller.step.value = 'metal',
            () => controller.step.value = 'amount',
            'Next: Amount',
            context,
          ),
        ],
      ),
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
      final color = controller.metalType.value == 'GOLD'
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);
      return GestureDetector(
        onTap: () => controller.giftType.value = type,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? color
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAmountStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceInfo(context),
            const SizedBox(height: 24),
            Text(
              'Select Occasion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildOccasionSelector(context),
            const SizedBox(height: 24),
            if (controller.giftType.value == 'VIRTUAL') ...[
              _buildWeightValueInput(context),
              const SizedBox(height: 20),
              _buildPresetSection(
                context,
                'Pick Weight',
                controller.presetGrams,
                true,
              ),
              const SizedBox(height: 18),
              _buildPresetSection(
                context,
                'Pick Amount',
                controller.presetAmounts,
                false,
              ),
            ] else ...[
              _buildCoinInventoryStep(context),
            ],
            const SizedBox(height: 40),
            _buildStepActions(
              () => controller.step.value = 'form',
              () => controller.step.value = 'recipient',
              'Next: Recipient',
              context,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
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
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets.map((p) {
              final isSelected = isWeight
                  ? (controller.gramsAmount.value == p &&
                        controller.inputMode.value == 'weight')
                  : (controller.valueController.text == p.toString() &&
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

  Widget _buildBalanceInfo(BuildContext context) {
    return Obx(() {
      final metal = controller.metalType.value;
      final balance = metal == 'GOLD'
          ? controller.walletBalance.value?.goldGrams ?? 0.0
          : controller.walletBalance.value?.silverGrams ?? 0.0;
      final color = metal == 'GOLD'
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${balance.toStringAsFixed(3)}g',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coins',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${controller.coinInventory.where((c) => c.metal == metal).fold(0, (sum, c) => sum + c.quantity)} coins',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWeightValueInput(BuildContext context) {
    return Obx(() {
      final metalColor = controller.metalType.value == 'GOLD'
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [metalColor, metalColor.withValues(alpha: 0.85)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: metalColor.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildInputBox(
              context,
              'Weight (g)',
              controller.weightController,
              controller.handleWeightChange,
              '0.5',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: controller.handleSwap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.white70,
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
      );
    });
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
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: textController,
              onChanged: onChanged,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
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

  Widget _buildPresetChip(
    BuildContext context,
    String label,
    VoidCallback onTap,
    bool isSelected,
  ) {
    final color = controller.metalType.value == 'GOLD'
        ? const Color(0xFFD4AF37)
        : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOccasionSelector(BuildContext context) {
    final occasions = [
      {'id': 'birthday', 'label': '🎂 Birthday'},
      {'id': 'wedding', 'label': '💍 Wedding'},
      {'id': 'anniversary', 'label': '❤️ Anniversary'},
      {'id': 'diwali', 'label': '🪔 Diwali'},
      {'id': 'general', 'label': '🎁 General'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: occasions.map((occ) {
          final isSelected = controller.occasion.value == occ['id'];
          final color = controller.metalType.value == 'GOLD'
              ? const Color(0xFFD4AF37)
              : const Color(0xFF94A3B8);
          return GestureDetector(
            onTap: () => controller.occasion.value = occ['id'] as String,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.08)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? color
                      : Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(
                occ['label'] as String,
                style: TextStyle(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoinInventoryStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
          children: [
            1,
            2,
            5,
            8,
            10,
          ].map((g) => _buildCoinOptionCard(context, g)).toList(),
        ),
        const SizedBox(height: 20),
        Obx(() {
          final balance = controller.getCoinBalance(
            controller.selectedCoin.value,
          );
          final metalColor = controller.metalType.value == 'GOLD'
              ? const Color(0xFFD4AF37)
              : const Color(0xFF94A3B8);
          if (balance > 0) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [metalColor, metalColor.withValues(alpha: 0.85)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Qty',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () {
                        if (controller.coinQuantity.value > 1) {
                          controller.coinQuantity.value--;
                        }
                      }),
                      const SizedBox(width: 14),
                      Text(
                        '${controller.coinQuantity.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 14),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'No ${controller.selectedCoin.value}g coins available',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(
                        controller.metalType.value == 'GOLD'
                            ? '/coins'
                            : '/silver-coins',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? color
                    : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${grams}g',
                  style: TextStyle(
                    color: isSelected
                        ? color
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipient Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (val) {
              if (val.length <= 10) controller.recipientPhone.value = val;
            },
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLookingUp.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = controller.lookupResult.value;
            if (user != null) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const Spacer(),
          _buildStepActions(
            () => controller.step.value = 'amount',
            () {
              if (controller.lookupResult.value == null) {
                SnackbarUtils.showError('Select a registered user');
                return;
              }
              controller.step.value = 'message';
            },
            'Next',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Message',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (val) => controller.personalMessage.value = val,
              decoration: InputDecoration(
                hintText: 'Write your wishes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            _buildGiftPreviewCard(context),
            const SizedBox(height: 32),
            _buildStepActions(
              () => controller.step.value = 'recipient',
              () => controller.step.value = 'confirm',
              'Review',
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftPreviewCard(BuildContext context) {
    return Obx(() {
      final metal = controller.metalType.value;
      final type = controller.giftType.value;
      final metalColor = metal == 'GOLD'
          ? const Color(0xFFD4AF37)
          : const Color(0xFF94A3B8);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: metal == 'GOLD'
                ? [const Color(0xFFD4AF37), const Color(0xFFB8960C)]
                : [const Color(0xFF94A3B8), const Color(0xFF64748B)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: metalColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
              ),
              child: const Icon(
                Icons.card_giftcard,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You\'ve received a ${metal.toLowerCase()} ${type == 'COIN' ? 'coin' : 'gift'}!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (controller.personalMessage.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '"${controller.personalMessage.value}"',
                style: const TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildConfirmStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildConfirmItem('Metal', controller.metalType.value, context),
          _buildConfirmItem(
            'Recipient',
            controller.recipientName.value,
            context,
          ),
          _buildConfirmItem('Gift Type', controller.giftType.value, context),
          _buildConfirmItem(
            'Total Amount',
            '₹${controller.valueController.text}',
            context,
          ),
          const Spacer(),
          _buildStepActions(
            () => controller.step.value = 'message',
            controller.sendGift,
            'Send Gift',
            context,
            isProcessing: controller.isProcessing.value,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmItem(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(
    String label,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStepActions(
    VoidCallback onBack,
    VoidCallback onNext,
    String nextLabel,
    BuildContext context, {
    bool isProcessing = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: isProcessing ? null : onBack,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: isProcessing ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: isProcessing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      nextLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
