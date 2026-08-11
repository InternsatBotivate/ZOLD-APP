import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/models/profile_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';

class BankAccountsView extends GetView<ProfileController> {
  const BankAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Accounts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Manage your linked bank accounts',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showAccountForm(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add New'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3D3066),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: Obx(() {
              if (controller.bankAccounts.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.bankAccounts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildAccountCard(context, controller.bankAccounts[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Color(0xFF1D4ED8), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your bank accounts are securely encrypted. Primary account is used for all transactions by default.',
              style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No bank accounts added yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAccountForm(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D3066),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add Your First Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, BankAccount account) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: account.isPrimary
              ? const Color(0xFF3D3066)
              : Colors.grey[200]!,
          width: account.isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.bankName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        if (account.isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D3066),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PRIMARY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (account.isPrimary) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: account.isVerified
                                ? const Color(0xFFD1FAE5)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            account.isVerified ? 'VERIFIED' : 'PENDING',
                            style: TextStyle(
                              color: account.isVerified
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF92400E),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  if (!account.isPrimary)
                    const PopupMenuItem(
                      value: 'primary',
                      child: Text('Set as Primary'),
                    ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showAccountForm(context, account: account);
                  } else if (value == 'delete') {
                    _confirmDelete(context, account);
                  } else if (value == 'primary') {
                    controller.setPrimaryBankAccount(account.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            'Account Number',
            account.accountNumber,
            isMono: true,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Account Holder', account.accountHolderName),
          const SizedBox(height: 12),
          _buildDetailRow('IFSC Code', account.ifscCode, isMono: true),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Account Type',
            StringUtils.capitalizeFirst(account.accountType),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: isMono ? 'monospace' : null,
              ),
            ),
            if (isMono) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  SnackbarUtils.showSuccess('$label copied to clipboard');
                },
                child: const Icon(Icons.copy, size: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showAccountForm(BuildContext context, {BankAccount? account}) {
    final isEditing = account != null;
    final bankController = TextEditingController(text: account?.bankName ?? '');
    final holderController = TextEditingController(
      text: account?.accountHolderName ?? '',
    );
    final numberController = TextEditingController(
      text: account?.accountNumber ?? '',
    );
    final ifscController = TextEditingController(text: account?.ifscCode ?? '');
    final type = (account?.accountType ?? 'SAVINGS').obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Bank Account' : 'Add Bank Account',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Bank Name', bankController),
              const SizedBox(height: 16),
              _buildTextField('Account Holder Name', holderController),
              const SizedBox(height: 16),
              _buildTextField(
                'Account Number',
                numberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField('IFSC Code', ifscController),
              const SizedBox(height: 16),
              const Text(
                'Account Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'SAVINGS', label: Text('Savings')),
                    ButtonSegment(value: 'CURRENT', label: Text('Current')),
                  ],
                  selected: {type.value},
                  onSelectionChanged: (val) => type.value = val.first,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            final newAccount = BankAccount(
                              id: account?.id ?? '',
                              bankName: bankController.text,
                              accountHolderName: holderController.text,
                              accountNumber: numberController.text,
                              ifscCode: ifscController.text,
                              accountType: type.value,
                              isPrimary: account?.isPrimary ?? false,
                              isVerified: account?.isVerified ?? false,
                            );
                            if (isEditing) {
                              controller.updateBankAccount(
                                account.id,
                                newAccount,
                              );
                            } else {
                              controller.addBankAccount(newAccount);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D3066),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(isEditing ? 'Save Changes' : 'Add Account'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDelete(BuildContext context, BankAccount account) {
    if (account.isPrimary) {
      SnackbarUtils.showError('Please set another account as primary first.');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Bank Account?'),
        content: Text(
          'Are you sure you want to delete ${account.bankName} account ending in ${account.accountNumber.substring(account.accountNumber.length - 4)}?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteBankAccount(account.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController textController, {
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
        TextFormField(
          controller: textController,
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
