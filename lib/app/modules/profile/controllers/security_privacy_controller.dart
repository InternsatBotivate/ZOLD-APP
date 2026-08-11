import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/base_response.dart';
import '../../../data/models/profile_models.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../core/utils/snackbar_utils.dart';

class SecurityPrivacyController extends GetxController {
  final ProfileRepository _repository;
  SecurityPrivacyController(this._repository);

  final isLoading = false.obs;
  final isEditMode = false.obs;

  // Form Fields
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final showCurrentPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Settings
  final twoFactorEnabled = false.obs;
  final readReceipts = true.obs;
  final dataSharing = false.obs;
  final profileVisibility = 'contacts'.obs;

  final sessions = <UserSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSecurityData();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> fetchSecurityData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.getSecuritySettings(),
        _repository.getSessions(),
      ]);

      final settingsRes = results[0] as BaseResponse<SecuritySettings>;
      final sessionsRes = results[1] as BaseResponse<List<UserSession>>;

      if (settingsRes.success && settingsRes.data != null) {
        final data = settingsRes.data!;
        twoFactorEnabled.value = data.twoFactorEnabled;
        readReceipts.value = data.readReceipts;
        dataSharing.value = data.dataSharing;
        profileVisibility.value = data.profileVisibility;
      }

      if (sessionsRes.success) {
        sessions.assignAll(sessionsRes.data ?? []);
      }
    } catch (e) {
      debugPrint('Error fetching security data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    if (isEditMode.value) {
      // Cancel logic: reset fields
      resetForm();
    }
    isEditMode.value = !isEditMode.value;
  }

  void resetForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    // We might want to re-fetch settings to ensure local state matches server if cancelled
    fetchSecurityData();
  }

  Future<void> saveSettings() async {
    isLoading.value = true;
    try {
      // 1. Handle Password Change if fields are filled
      if (newPasswordController.text.isNotEmpty) {
        if (newPasswordController.text != confirmPasswordController.text) {
          SnackbarUtils.showError('Passwords do not match');
          isLoading.value = false;
          return;
        }
        if (currentPasswordController.text.isEmpty) {
          SnackbarUtils.showError('Current password is required');
          isLoading.value = false;
          return;
        }

        final passReq = PasswordRequest(
          oldPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        );
        final passRes = await _repository.updatePassword(passReq);
        if (!passRes.success) {
          SnackbarUtils.showError(
            passRes.message ?? 'Failed to update password',
          );
          isLoading.value = false;
          return;
        }
      }

      // 2. Update Security/Privacy Settings
      final settings = SecuritySettings(
        twoFactorEnabled: twoFactorEnabled.value,
        dataSharing: dataSharing.value,
        profileVisibility: profileVisibility.value,
        readReceipts: readReceipts.value,
      );

      final res = await _repository.updateSecuritySettings(settings);
      if (res.success) {
        SnackbarUtils.showSuccess('Settings updated successfully');
        isEditMode.value = false;
        resetForm();
      } else {
        SnackbarUtils.showError(res.message ?? 'Failed to update settings');
      }
    } catch (e) {
      SnackbarUtils.showError('An error occurred while saving settings');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> revokeSession(String id) async {
    try {
      final res = await _repository.revokeSession(id);
      if (res.success) {
        sessions.removeWhere((s) => s.id == id);
        SnackbarUtils.showSuccess('Session revoked');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to revoke session');
    }
  }

  Future<void> revokeAllSessions() async {
    try {
      final res = await _repository.revokeAllSessions();
      if (res.success) {
        sessions.removeWhere((s) => !s.isActive);
        SnackbarUtils.showSuccess('All other sessions revoked');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to revoke sessions');
    }
  }
}
