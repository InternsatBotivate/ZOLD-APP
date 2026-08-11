import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../data/models/admin_models.dart';
import '../../../../data/models/base_response.dart';

class GstManagementController extends GetxController {
  final AdminRepository _adminRepository;
  GstManagementController({required AdminRepository adminRepository})
    : _adminRepository = adminRepository;

  final isLoading = true.obs;
  final isSaving = false.obs;
  final isEditing = false.obs;

  final gstHistory = <GstConfig>[].obs;
  final currentGstRate = 0.0.obs;

  final gstController = TextEditingController();
  final error = ''.obs;
  final success = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("DEBUG: GST Controller - onInit() called");
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      debugPrint("DEBUG: GST Controller - fetchData() started");
      isLoading.value = true;
      error.value = '';
      success.value = ''; // Clear previous messages

      // Fetch both in parallel like Next.js GoldRatesTab.tsx
      final results = await Future.wait([
        _adminRepository.getCurrentGst(),
        _adminRepository.getGstHistory(),
      ]);

      final rateRes = results[0] as BaseResponse<double>;
      final historyRes = results[1] as BaseResponse<List<GstConfig>>;

      debugPrint(
        "DEBUG: GST Controller - getCurrentGst() success: ${rateRes.success}",
      );
      if (rateRes.success) {
        currentGstRate.value = rateRes.data ?? 0.0;
        if (!isEditing.value) {
          gstController.text = currentGstRate.value.toString();
        }
      } else {
        error.value = rateRes.message ?? 'Failed to load current GST';
      }

      debugPrint(
        "DEBUG: GST Controller - getGstHistory() success: ${historyRes.success}",
      );
      if (historyRes.success) {
        gstHistory.assignAll(historyRes.data ?? []);
      } else {
        if (error.isEmpty) {
          error.value = historyRes.message ?? 'Failed to load history';
        }
      }
    } catch (e, st) {
      debugPrint("CRITICAL: GST Controller Fetch Error: $e");
      debugPrint("STACK TRACE:\n$st");
      error.value = "System Error: ${e.toString()}";
    } finally {
      isLoading.value = false;
      debugPrint(
        "DEBUG: GST Controller - fetchData() finished, isLoading = ${isLoading.value}",
      );
    }
  }

  Future<void> refreshData() => fetchData();

  Future<void> updateGST() async {
    final rateText = gstController.text.trim();
    if (rateText.isEmpty) {
      error.value = 'GST rate is required';
      return;
    }

    final rate = double.tryParse(rateText);
    if (rate == null || rate < 0 || rate > 100) {
      error.value = 'GST rate must be a number between 0 and 100';
      return;
    }

    isSaving.value = true;
    error.value = '';
    success.value = '';

    try {
      debugPrint("DEBUG: GST Controller - Calling updateGstRate($rate)...");
      final res = await _adminRepository.updateGstRate(rate);
      debugPrint(
        "DEBUG: GST Controller - updateGstRate() success: ${res.success}",
      );

      if (res.success) {
        success.value = 'GST rate updated successfully';
        isEditing.value = false;

        Future.delayed(const Duration(seconds: 4), () {
          if (success.value == 'GST rate updated successfully') {
            success.value = '';
          }
        });

        await fetchData();
      } else {
        error.value = res.message ?? 'Update failed';
        debugPrint(
          "DEBUG: GST Controller - updateGstRate() error message: ${error.value}",
        );
      }
    } catch (e, st) {
      debugPrint("CRITICAL: GST Controller Update Error: $e");
      debugPrint("STACK TRACE:\n$st");
      error.value = e.toString();
    } finally {
      isSaving.value = false;
    }
  }

  void startEditing() {
    debugPrint("DEBUG: GST Controller - startEditing()");
    isEditing.value = true;
    gstController.text = currentGstRate.value.toString();
    error.value = '';
    success.value = '';
  }

  void cancelEditing() {
    debugPrint("DEBUG: GST Controller - cancelEditing()");
    isEditing.value = false;
    gstController.text = currentGstRate.value.toString();
    error.value = '';
  }

  @override
  void onClose() {
    debugPrint("DEBUG: GST Controller - onClose()");
    gstController.dispose();
    super.onClose();
  }
}
