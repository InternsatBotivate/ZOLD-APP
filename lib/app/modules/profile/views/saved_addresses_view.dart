import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/models/profile_models.dart';
import '../../../core/theme/app_colors.dart';

class SavedAddressesView extends GetView<ProfileController> {
  const SavedAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1A1C1E),
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Addresses',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF1A1C1E),
              ),
            ),
            Text(
              'Manage your delivery and pickup locations',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            if (controller.isAddingAddress.value ||
                controller.editingAddressId.value != null) {
              return Row(
                children: [
                  IconButton(
                    onPressed: controller.clearAddressForm,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.bgDark : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveAddress,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: controller.isLoading.value
                            ? Colors.grey
                            : const Color(0xFF00A341),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: controller.startAddingAddress,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3066),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Add\nNew',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.isAddingAddress.value ||
                  controller.editingAddressId.value != null) {
                return _buildAddressForm(context);
              }
              return _buildInfoBanner(context);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(
                () => Text(
                  'All Addresses (${controller.addresses.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF1A1C1E),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value && controller.addresses.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.addresses.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.addresses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    _buildAddressCard(context, controller.addresses[index]),
              );
            }),
            _buildQuickTips(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = controller.editingAddressId.value != null;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Edit Address' : 'Add New Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildFormTextField(
            context,
            'Address Name *',
            'e.g., Home, Office, Partner Name',
            controller.addressLabelController,
          ),
          const SizedBox(height: 16),
          Text(
            'Address Type',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDark : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade300,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.addressType.value,
                  isExpanded: true,
                  dropdownColor: isDark
                      ? AppColors.bgDarkSecondary
                      : Colors.white,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : Colors.black,
                  ),
                  items: ['Home', 'Work', 'Other'].map((t) {
                    return DropdownMenuItem(value: t, child: Text(t));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.addressType.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFormTextField(
            context,
            'Complete Address *',
            'House no., Building, Street, Area',
            controller.addressLine1Controller,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormTextField(
                  context,
                  'City *',
                  'City',
                  controller.addressCityController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormTextField(
                  context,
                  'State *',
                  'State',
                  controller.addressStateController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormTextField(
                  context,
                  'Pincode *',
                  'Pincode',
                  controller.addressPincodeController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFormTextField(
                  context,
                  'Phone *',
                  'Phone number',
                  controller.addressPhoneController,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormTextField(
            context,
            'Landmark (Optional)',
            'Nearby landmark',
            controller.addressLine2Controller,
          ),
        ],
      ),
    );
  }

  Widget _buildFormTextField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController textController, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.textSecondaryDark
                : const Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark ? AppColors.bgDark : const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3D3066)),
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

  Widget _buildInfoBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E3A8A).withValues(alpha: 0.2)
            : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Your saved addresses include both personal locations and partner jeweller locations for easy pickup/delivery.',
        style: TextStyle(
          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
          fontSize: 13,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: isDark ? AppColors.textMutedDark : Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses saved yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add an address to get started with delivery or pickup',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isJeweller =
        address.label.toLowerCase().contains('jeweller') ||
        address.type.toLowerCase() == 'other';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isPrimary
              ? const Color(0xFF3D3066)
              : (isDark ? AppColors.borderDark : Colors.grey.shade200),
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3F51B5).withValues(alpha: 0.1)
                      : const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(address.type),
                  color: const Color(0xFF3F51B5),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF1A1C1E),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3F51B5).withValues(alpha: 0.1)
                                : const Color(0xFFE8EAF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            address.type,
                            style: const TextStyle(
                              color: Color(0xFF3F51B5),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (address.isPrimary) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D3066),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send_outlined,
                      size: 20,
                      color: isDark ? AppColors.textMutedDark : Colors.grey,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => controller.startEditingAddress(address),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: isDark ? AppColors.textMutedDark : Colors.grey,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _confirmDelete(context, address),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.location_on_outlined,
            address.addressLine1,
          ),
          _buildDetailRow(
            context,
            null,
            '${address.city}, ${address.state} - ${address.pincode}',
          ),
          if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
            _buildDetailRow(
              context,
              null,
              'Landmark: ${address.addressLine2}',
              isMuted: true,
            ),
          const SizedBox(height: 8),
          _buildDetailRow(context, Icons.phone_outlined, address.phone),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isJeweller)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFB8860B).withValues(alpha: 0.1)
                        : const Color(0xFFFFF9E8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.sell_outlined,
                        color: Color(0xFFB8860B),
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Partner Jeweller Location',
                        style: TextStyle(
                          color: Color(0xFFB8860B),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              if (!address.isPrimary)
                OutlinedButton(
                  onPressed: () => controller.setPrimaryAddress(address.id),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.primaryGold
                          : const Color(0xFF3D3066),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Set as Default',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryGold
                          : const Color(0xFF3D3066),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData? icon,
    String text, {
    bool isMuted = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 24),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isMuted
                    ? (isDark ? AppColors.textMutedDark : Colors.grey.shade500)
                    : (isDark
                          ? AppColors.textSecondaryDark
                          : const Color(0xFF4A4A4A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_outline,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF1A1C1E),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem(context, 'Set a default address for faster checkout'),
          _buildTipItem(
            context,
            'Partner jeweller locations are marked with a yellow tag',
          ),
          _buildTipItem(
            context,
            'Use "Get Directions" for navigation to any address',
          ),
          _buildTipItem(
            context,
            'Add multiple addresses for different pickup/delivery needs',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : Colors.grey.shade600,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.business_center_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _confirmDelete(BuildContext context, Address address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Address',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${address.label}"?',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAddress(address.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
