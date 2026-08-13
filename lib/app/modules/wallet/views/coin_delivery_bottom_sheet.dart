import 'package:flutter/material.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';
import '../../../core/utils/snackbar_utils.dart';

class CoinDeliveryBottomSheet extends GetView<DeliveryController> {
  final dynamic coin;
  const CoinDeliveryBottomSheet({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    controller.prepareForCoin(coin);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: Obx(() {
                  switch (controller.step.value) {
                    case 'details':
                      return _buildDetailsStep(context);
                    case 'partner':
                      return _buildPartnerStep(context);
                    case 'confirm':
                      return _buildConfirmStep(context);
                    default:
                      return _buildDetailsStep(context);
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: colorScheme.surface),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Delivery',
                    style: TextStyle(
                      color: colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Partner pickup at nearest store',
                    style: TextStyle(
                      color: colorScheme.surface.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: colorScheme.surface),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    _getCoinImage(coin.coinGrams, coin.metal),
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${coin.coinGrams}g ${StringUtils.capitalizeFirst(coin.metal.toLowerCase())} Coin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Pure 24K ${StringUtils.capitalizeFirst(coin.metal.toLowerCase())} Coin',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'RECEIVER DETAILS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.nameController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.phoneController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Phone Number',
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Text(
              'QUANTITY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.quantityController,
              onChanged: (val) {
                if (val.isEmpty) {
                  controller.quantityValue.value = null;
                  return;
                }
                final q = int.tryParse(val);
                if (q != null) {
                  if (q > coin.quantity) {
                    controller.quantityController.text = coin.quantity
                        .toString();
                    controller.quantityController.selection =
                        TextSelection.fromPosition(
                          TextPosition(
                            offset: controller.quantityController.text.length,
                          ),
                        );
                    controller.quantityValue.value = coin.quantity;
                  } else {
                    controller.quantityValue.value = q;
                  }
                }
              },
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Enter quantity',
                prefixIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                helperText: 'Max available: ${coin.quantity}',
                helperStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final q = controller.quantityValue.value;
                  if (q == null || q <= 0 || q > coin.quantity) {
                    SnackbarUtils.showError('Invalid quantity');
                    return;
                  }
                  if (controller.nameController.text.isEmpty ||
                      controller.phoneController.text.isEmpty) {
                    SnackbarUtils.showError('Please fill receiver details');
                    return;
                  }
                  controller.step.value = 'partner';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSurface,
                  foregroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Store',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerStep(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Pickup Partner',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => controller.step.value = 'details',
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (val) => controller.searchQuery.value = val,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Search store or city...',
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: colorScheme.onSurface),
                      const SizedBox(height: 16),
                      Text(
                        'Finding partners...',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredPartners.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 48,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No partners found in this area',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.fetchAll(),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: controller.filteredPartners.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = controller.filteredPartners[index];
                  final isSelected =
                      controller.selectedPartner.value?.id == p.id;
                  return GestureDetector(
                    onTap: () => controller.selectedPartner.value = p,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.1),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.businessName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${p.area}, ${p.city}',
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    p.servicesOffers,
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.selectedPartner.value == null
                  ? null
                  : () => controller.submitDelivery(coin.metal, coin.coinGrams),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: colorScheme.outline.withValues(
                  alpha: 0.3,
                ),
              ),
              child: Obx(
                () => controller.isProcessing.value
                    ? CircularProgressIndicator(color: colorScheme.surface)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm Pickup Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your delivery request has been sent. You can visit ${controller.selectedPartner.value?.businessName} to collect your coin within 3-5 business days.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  _buildConfirmRow(
                    context,
                    'Receiver',
                    controller.nameController.text,
                  ),
                  Divider(
                    height: 24,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  _buildConfirmRow(
                    context,
                    'Phone',
                    controller.phoneController.text,
                  ),
                  Divider(
                    height: 24,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  _buildConfirmRow(
                    context,
                    'Pickup Store',
                    controller.selectedPartner.value?.businessName ?? '',
                  ),
                  Divider(
                    height: 24,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  _buildConfirmRow(
                    context,
                    'Status',
                    'Ready in 3-5 Days',
                    isStatus: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSurface,
                  foregroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmRow(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 12, color: AppColors.warning),
                const SizedBox(width: 4),
                const Text(
                  'Ready in 3-5 Days',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: colorScheme.onSurface,
            ),
          ),
      ],
    );
  }

  String _getCoinImage(int grams, String metal) {
    if (metal == 'SILVER') return 'assets/images/silver-Zold-Bar.png';
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
        return 'assets/images/1gmZold.webp';
    }
  }
}
