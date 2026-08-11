import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/models/profile_models.dart';
import '../../../core/theme/app_colors.dart';

class PaymentMethodsView extends GetView<ProfileController> {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Payment Methods',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddPaymentMethodSheet(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.paymentMethods.isEmpty) {
          return _buildEmptyState(context);
        }
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.paymentMethods.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              _buildPaymentCard(context, controller.paymentMethods[index]),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No payment methods saved',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddPaymentMethodSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D3066),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Payment Method',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, PaymentMethod method) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: method.isPrimary ? const Color(0xFF3D3066) : Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getThemeColor(method.type).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(method.type),
              color: _getThemeColor(method.type),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.provider ?? method.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (method.cardLast4 != null)
                  Text(
                    '**** **** **** ${method.cardLast4}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                if (method.isPrimary)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3066),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'delete', child: Text('Remove')),
              if (!method.isPrimary)
                const PopupMenuItem(
                  value: 'primary',
                  child: Text('Set as Default'),
                ),
            ],
            onSelected: (val) {
              if (val == 'delete') {
                controller.deletePaymentMethod(method.id);
              } else if (val == 'primary') {
                controller.setPrimaryPaymentMethod(method.id);
              }
            },
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type.toUpperCase()) {
      case 'CARD':
        return Icons.credit_card;
      case 'WALLET':
        return Icons.account_balance_wallet;
      case 'NETBANKING':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  Color _getThemeColor(String type) {
    switch (type.toUpperCase()) {
      case 'CARD':
        return Colors.blue;
      case 'WALLET':
        return Colors.orange;
      case 'NETBANKING':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showAddPaymentMethodSheet(BuildContext context) {
    final type = 'CARD'.obs;
    final providerController = TextEditingController();
    final numberController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Obx(
              () => SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'CARD', label: Text('Card')),
                  ButtonSegment(value: 'WALLET', label: Text('Wallet')),
                  ButtonSegment(
                    value: 'NETBANKING',
                    label: Text('Net Banking'),
                  ),
                ],
                selected: {type.value},
                onSelectionChanged: (val) => type.value = val.first,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              'Provider (e.g. HDFC, Paytm, Visa)',
              providerController,
            ),
            const SizedBox(height: 16),
            Obx(
              () => type.value == 'CARD'
                  ? _buildTextField(
                      'Card Number (Last 4 digits)',
                      numberController,
                      keyboardType: TextInputType.number,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final method = PaymentMethod(
                    id: '',
                    type: type.value,
                    provider: providerController.text,
                    cardLast4: type.value == 'CARD'
                        ? numberController.text
                        : null,
                    isPrimary: false,
                  );
                  controller.addPaymentMethod(method);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D3066),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Method'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
