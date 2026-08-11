import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../../data/models/profile_models.dart';
import '../../../data/models/notification_models.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/theme_service.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository;
  final PurchaseRepository _purchaseRepository;
  ProfileController(this._repository, this._purchaseRepository);

  final isLoading = false.obs;
  final isEditing = false.obs;

  ThemeMode get currentThemeMode => ThemeService.to.themeMode;
  bool get isDarkMode => ThemeService.to.isDarkMode;

  final bankAccounts = <BankAccount>[].obs;
  final addresses = <Address>[].obs;
  final sessions = <UserSession>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final securitySettings = Rxn<SecuritySettings>();
  final notificationSettings = Rxn<NotificationSettings>();

  final isAddingAddress = false.obs;
  final editingAddressId = RxnString();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;

  // New Address Form Controllers
  late TextEditingController addressLabelController;
  late TextEditingController addressNameController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController addressCityController;
  late TextEditingController addressStateController;
  late TextEditingController addressPincodeController;
  late TextEditingController addressPhoneController;
  final addressType = 'Home'.obs;

  @override
  void onInit() {
    super.onInit();
    final user = AuthService.to.user.value;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    dobController = TextEditingController(text: user?.dob ?? '');
    addressController = TextEditingController(text: user?.address ?? '');
    cityController = TextEditingController(text: user?.city ?? '');
    stateController = TextEditingController(text: user?.state ?? '');
    pincodeController = TextEditingController(text: user?.pincode ?? '');

    // Initialize address form controllers
    addressLabelController = TextEditingController();
    addressNameController = TextEditingController();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    addressCityController = TextEditingController();
    addressStateController = TextEditingController();
    addressPincodeController = TextEditingController();
    addressPhoneController = TextEditingController();

    fetchAllData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

    addressLabelController.dispose();
    addressNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    addressCityController.dispose();
    addressStateController.dispose();
    addressPincodeController.dispose();
    addressPhoneController.dispose();

    super.onClose();
  }

  void clearAddressForm() {
    addressLabelController.clear();
    addressNameController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    addressCityController.clear();
    addressStateController.clear();
    addressPincodeController.clear();
    addressPhoneController.clear();
    addressType.value = 'Home';
    isAddingAddress.value = false;
    editingAddressId.value = null;
  }

  void startAddingAddress() {
    clearAddressForm();
    isAddingAddress.value = true;
  }

  void startEditingAddress(Address address) {
    addressLabelController.text = address.label;
    addressNameController.text = address.fullName;
    addressLine1Controller.text = address.addressLine1;
    addressLine2Controller.text = address.addressLine2 ?? '';
    addressCityController.text = address.city;
    addressStateController.text = address.state;
    addressPincodeController.text = address.pincode;
    addressPhoneController.text = address.phone;
    addressType.value = address.type;
    editingAddressId.value = address.id;
    isAddingAddress.value = false;
  }

  Future<void> saveAddress() async {
    final label = addressLabelController.text.trim();
    final fullName = addressNameController.text.trim();
    final line1 = addressLine1Controller.text.trim();
    final line2 = addressLine2Controller.text.trim();
    final city = addressCityController.text.trim();
    final state = addressStateController.text.trim();
    final pincode = addressPincodeController.text.trim();
    final phone = addressPhoneController.text.trim();

    if (label.isEmpty ||
        fullName.isEmpty ||
        line1.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        pincode.isEmpty ||
        phone.isEmpty) {
      SnackbarUtils.showError('Please fill all required fields');
      return;
    }

    final address = Address(
      id: editingAddressId.value ?? '',
      label: label,
      fullName: fullName,
      addressLine1: line1,
      addressLine2: line2.isEmpty ? null : line2,
      city: city,
      state: state,
      pincode: pincode,
      phone: phone,
      type: addressType.value,
      isPrimary: false,
    );

    if (editingAddressId.value != null) {
      await updateAddress(editingAddressId.value!, address);
    } else {
      await addAddress(address);
    }
    clearAddressForm();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchBankAccounts(),
      fetchAddresses(),
      fetchSessions(),
      fetchSecuritySettings(),
      fetchPaymentMethods(),
      fetchNotificationSettings(),
    ]);
  }

  Future<void> fetchNotificationSettings() async {
    try {
      final response = await _repository.getNotificationSettings();
      if (response.success && response.data != null) {
        notificationSettings.value = response.data;
      } else {
        notificationSettings.value = NotificationSettings();
      }
    } catch (e) {
      notificationSettings.value = NotificationSettings();
    }
  }

  Future<void> updateNotificationSetting(NotificationSettings settings) async {
    // Optimistic Update: Update UI immediately
    notificationSettings.value = settings;

    try {
      final response = await _repository.updateNotificationSettings(settings);
      if (!response.success) {
        // If it failed even locally (unlikely), revert
        // notificationSettings.value = previousSettings;
        // SnackbarUtils.showError('Failed to save settings');
      }
    } catch (e) {
      debugPrint('Error updating notification setting: $e');
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final response = await _repository.getPaymentMethods();
      if (response.success) {
        paymentMethods.assignAll(response.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
    }
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    isLoading.value = true;
    try {
      final response = await _repository.addPaymentMethod(method);
      if (response.success) {
        await fetchPaymentMethods();
        Get.back();
        SnackbarUtils.showSuccess('Payment method added');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to add payment method');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    try {
      final response = await _repository.deletePaymentMethod(id);
      if (response.success) {
        paymentMethods.removeWhere((m) => m.id == id);
        SnackbarUtils.showSuccess('Payment method removed');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to remove payment method');
    }
  }

  Future<void> setPrimaryPaymentMethod(String id) async {
    try {
      final response = await _repository.setPrimaryPaymentMethod(id);
      if (response.success) {
        await fetchPaymentMethods();
        SnackbarUtils.showSuccess('Default payment method updated');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to update default');
    }
  }

  Future<void> fetchBankAccounts() async {
    try {
      final response = await _repository.getBankAccounts();
      if (response.success) {
        bankAccounts.assignAll(response.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching bank accounts: $e');
    }
  }

  Future<void> fetchAddresses() async {
    try {
      final response = await _repository.getAddresses();
      if (response.success) {
        addresses.assignAll(response.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
    }
  }

  Future<void> fetchSessions() async {
    try {
      final response = await _repository.getSessions();
      if (response.success) {
        sessions.assignAll(response.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching sessions: $e');
    }
  }

  Future<void> fetchSecuritySettings() async {
    try {
      final response = await _repository.getSecuritySettings();
      if (response.success && response.data != null) {
        securitySettings.value = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching security settings: $e');
    }
  }

  Future<void> updateSecuritySettings(SecuritySettings settings) async {
    try {
      final response = await _repository.updateSecuritySettings(settings);
      if (response.success) {
        securitySettings.value = settings;
        SnackbarUtils.showSuccess('Settings updated');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to update settings');
    }
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final dob = dobController.text.trim();
    final address = addressController.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final pincode = pincodeController.text.trim();

    if (name.isEmpty) {
      SnackbarUtils.showError('Full Name is required');
      return;
    }
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      SnackbarUtils.showError('Enter a valid email address');
      return;
    }
    if (phone.isNotEmpty && phone.length < 10) {
      SnackbarUtils.showError('Enter a valid 10-digit phone number');
      return;
    }
    if (pincode.isNotEmpty && pincode.length != 6) {
      SnackbarUtils.showError('Pincode must be 6 digits');
      return;
    }

    isLoading.value = true;
    try {
      final request = UpdateProfileRequest(
        name: name,
        email: email,
        phone: phone,
        dob: dob,
        address: address,
        city: city,
        state: state,
        pincode: pincode,
      );
      final response = await _repository.updateProfile(request);
      if (response.success) {
        await AuthService.to.validateSession();
        SnackbarUtils.showSuccess('Profile updated successfully');
        isEditing.value = false;
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  void startEditing() {
    final user = AuthService.to.user.value;
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    dobController.text = user?.dob ?? '';
    addressController.text = user?.address ?? '';
    cityController.text = user?.city ?? '';
    stateController.text = user?.state ?? '';
    pincodeController.text = user?.pincode ?? '';
    isEditing.value = true;
  }

  void cancelEditing() {
    final user = AuthService.to.user.value;
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    dobController.text = user?.dob ?? '';
    addressController.text = user?.address ?? '';
    cityController.text = user?.city ?? '';
    stateController.text = user?.state ?? '';
    pincodeController.text = user?.pincode ?? '';
    isEditing.value = false;
  }

  Future<void> uploadProfilePicture(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      isLoading.value = true;
      final response = await _repository.uploadProfilePicture(image.path);
      if (response.success) {
        await AuthService.to.validateSession();
        SnackbarUtils.showSuccess('Profile picture updated successfully');
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Failed to upload profile picture: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    isLoading.value = true;
    try {
      final request = PasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      final response = await _repository.updatePassword(request);
      if (response.success) {
        SnackbarUtils.showSuccess('Password changed successfully');
        Get.back();
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to change password');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> revokeSession(String id) async {
    try {
      final response = await _repository.revokeSession(id);
      if (response.success) {
        sessions.removeWhere((s) => s.id == id);
        SnackbarUtils.showSuccess('Session revoked');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to revoke session');
    }
  }

  Future<void> revokeAllSessions() async {
    try {
      final response = await _repository.revokeAllSessions();
      if (response.success) {
        sessions.removeWhere((s) => !s.isActive);
        SnackbarUtils.showSuccess('All other sessions revoked');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to revoke sessions');
    }
  }

  Future<void> addBankAccount(BankAccount account) async {
    isLoading.value = true;
    try {
      final response = await _repository.addBankAccount(account);
      if (response.success) {
        await fetchBankAccounts();
        Get.back();
        SnackbarUtils.showSuccess('Bank account added successfully');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to add bank account');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBankAccount(String id, BankAccount account) async {
    isLoading.value = true;
    try {
      final response = await _repository.updateBankAccount(id, account);
      if (response.success) {
        await fetchBankAccounts();
        Get.back();
        SnackbarUtils.showSuccess('Bank account updated successfully');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to update bank account');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBankAccount(String id) async {
    try {
      final response = await _repository.deleteBankAccount(id);
      if (response.success) {
        bankAccounts.removeWhere((a) => a.id == id);
        SnackbarUtils.showSuccess('Bank account deleted');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to delete bank account');
    }
  }

  Future<void> setPrimaryBankAccount(String id) async {
    try {
      final response = await _repository.setPrimaryBankAccount(id);
      if (response.success) {
        await fetchBankAccounts();
        SnackbarUtils.showSuccess('Primary account updated');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to set primary account');
    }
  }

  Future<void> addAddress(Address address) async {
    isLoading.value = true;
    try {
      final response = await _repository.addAddress(address);
      if (response.success) {
        await fetchAddresses();
        Get.back();
        SnackbarUtils.showSuccess('Address added successfully');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to add address');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(String id, Address address) async {
    isLoading.value = true;
    try {
      final response = await _repository.updateAddress(id, address);
      if (response.success) {
        await fetchAddresses();
        Get.back();
        SnackbarUtils.showSuccess('Address updated successfully');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to update address');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      final response = await _repository.deleteAddress(id);
      if (response.success) {
        addresses.removeWhere((a) => a.id == id);
        SnackbarUtils.showSuccess('Address deleted');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to delete address');
    }
  }

  Future<void> setPrimaryAddress(String id) async {
    try {
      final response = await _repository.setPrimaryAddress(id);
      if (response.success) {
        await fetchAddresses();
        SnackbarUtils.showSuccess('Primary address updated');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to set primary address');
    }
  }

  void setThemeMode(ThemeMode mode) {
    ThemeService.to.setThemeMode(mode);
    update();
  }

  Future<void> openChatSupport() async {
    final whatsappUrl = Uri.parse(
      "https://wa.me/+911234567890?text=Hello,%20I%20need%20support",
    );
    if (await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
    } else {
      SnackbarUtils.showError('Could not launch WhatsApp');
    }
  }

  Future<void> openCallSupport() async {
    final telUrl = Uri.parse("tel:+911234567890");
    if (await launchUrl(telUrl)) {
    } else {
      SnackbarUtils.showError('Could not launch dialer');
    }
  }

  Future<void> logout() async {
    try {
      final activeResponse = await _purchaseRepository.getActiveSession();
      if (activeResponse.success && activeResponse.data != null) {
        await _purchaseRepository.cancelSession(activeResponse.data!.id);
      }
    } catch (_) {}
    try {
      await AuthService.to.logout();
    } catch (_) {}
  }
}
