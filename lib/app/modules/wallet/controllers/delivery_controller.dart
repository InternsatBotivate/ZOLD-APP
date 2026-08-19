import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/base_response.dart';
import '../../../data/repositories/delivery_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/models/delivery_models.dart';
import '../../../data/models/partner_models.dart';
import '../../../data/models/coin_models.dart';
import 'wallet_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../core/services/auth_service.dart';

class DeliveryController extends GetxController {
  final DeliveryRepository _deliveryRepository;
  final PartnerRepository _partnerRepository;
  final CoinRepository _coinRepository;

  DeliveryController({
    required DeliveryRepository deliveryRepository,
    required RateRepository rateRepository,
    required PartnerRepository partnerRepository,
    required CoinRepository coinRepository,
  }) : _deliveryRepository = deliveryRepository,
       _partnerRepository = partnerRepository,
       _coinRepository = coinRepository;

  final isLoading = false.obs;

  // Payment Processing State
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;

  final inventory = <CoinInventory>[].obs;
  final deliveries = <DeliveryModel>[].obs;
  final partners = <Partner>[].obs;

  // For Partners
  final assignedDeliveries = <DeliveryModel>[].obs;

  final selectedPartner = Rxn<Partner>();
  final searchQuery = ''.obs;
  final deliveryTab = 'active'.obs; // active, completed, cancelled

  // UI state for initiation flow
  final step = 'details'.obs; // details, partner, confirm
  final quantityController = TextEditingController();
  final quantityValue = Rxn<int>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final currentCoinId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    resetFields();
    fetchAll();
  }

  void prepareForCoin(dynamic coin) {
    final coinId = '${coin.metal}_${coin.coinGrams}';
    if (currentCoinId.value != coinId) {
      resetFields();
      currentCoinId.value = coinId;
    }
  }

  void resetFields() {
    step.value = 'details';
    quantityController.clear();
    quantityValue.value = null;
    selectedPartner.value = null;
    searchQuery.value = '';
    currentCoinId.value = '';

    final user = AuthService.to.user.value;
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone ?? '';
    }
  }

  @override
  void onClose() {
    quantityController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  List<Partner> get filteredPartners {
    if (searchQuery.isEmpty) return partners;
    return partners.where((p) {
      final name = p.businessName.toLowerCase();
      final city = p.city.toLowerCase();
      final area = p.area.toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) ||
          city.contains(query) ||
          area.contains(query);
    }).toList();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      final role = AuthService.to.user.value?.role;

      if (role == 'PARTNER') {
        final response = await _deliveryRepository.getAssignedDeliveries();
        assignedDeliveries.value = response.data ?? [];
      } else {
        final results = await Future.wait([
          _coinRepository.getUserInventory(),
          _deliveryRepository.getDeliveries(),
          _partnerRepository.getPartners(),
        ]);

        final invRes = results[0] as BaseResponse<List<CoinInventory>>;
        if (invRes.data != null) {
          inventory.value = invRes.data!.where((c) => c.quantity > 0).toList();
        }

        final delRes = results[1] as BaseResponse<List<DeliveryModel>>;
        if (delRes.data != null) {
          deliveries.value = delRes.data!;
        }

        final parRes = results[2] as BaseResponse<List<Partner>>;
        if (parRes.data != null) {
          partners.value = parRes.data!;
        }
      }
    } catch (e) {
      Get.log('Error loading delivery data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<DeliveryModel> get tabDeliveries {
    final activeStatuses = ['PENDING', 'PROCESSING', 'SHIPPED'];
    return deliveries.where((d) {
      if (deliveryTab.value == 'active') {
        return activeStatuses.contains(d.status);
      }
      if (deliveryTab.value == 'completed') return d.status == 'DELIVERED';
      return d.status == 'CANCELLED';
    }).toList();
  }

  List<DeliveryModel> get tabAssignedDeliveries {
    final activeStatuses = ['PENDING', 'PROCESSING', 'SHIPPED'];
    return assignedDeliveries.where((d) {
      if (deliveryTab.value == 'active') {
        return activeStatuses.contains(d.status);
      }
      if (deliveryTab.value == 'completed') return d.status == 'DELIVERED';
      return d.status == 'CANCELLED';
    }).toList();
  }

  Future<void> submitDelivery(String metal, int grams) async {
    final partner = selectedPartner.value;
    final quantity = quantityValue.value;

    if (quantity == null || quantity <= 0) {
      SnackbarUtils.showError('Please enter a valid quantity');
      return;
    }

    if (partner == null) {
      SnackbarUtils.showError('Please select a partner');
      return;
    }

    try {
      isProcessing.value = true;
      paymentStatus.value = 'Verifying Request...';
      final address = '${partner.area}, ${partner.city}';
      await _deliveryRepository.initiateDelivery(
        InitiateDeliveryRequest(
          metal: metal,
          coinGrams: grams,
          quantity: quantity,
          partnerId: partner.id,
          address: address,
        ),
      );

      paymentStatus.value = 'Finalizing Transaction...';
      step.value = 'confirm';
      SnackbarUtils.showSuccess('Delivery request submitted');
      fetchAll();

      // Refresh wallet
      try {
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshData();
        }
        if (Get.isRegistered<NotificationsController>()) {
          Get.find<NotificationsController>().fetchNotifications();
        }
      } catch (e) {
        debugPrint('Delivery refresh error: $e');
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to submit delivery request.');
    } finally {
      isProcessing.value = false;
      paymentStatus.value = '';
    }
  }

  Future<void> cancelDelivery(String deliveryId) async {
    try {
      isLoading.value = true;
      await _deliveryRepository.cancelDelivery(deliveryId);
      SnackbarUtils.showSuccess('Delivery cancelled');
      fetchAll();
    } catch (e) {
      SnackbarUtils.showError('Failed to cancel delivery.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTentativeDate(String deliveryId, DateTime date) async {
    try {
      isLoading.value = true;
      final dateStr = date.toIso8601String();
      await _deliveryRepository.updateDeliveryStatus(deliveryId, dateStr);
      SnackbarUtils.showSuccess('Tentative date updated');
      fetchAll();
      Get.back();
    } catch (e) {
      SnackbarUtils.showError('Failed to update date.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp(String deliveryId) async {
    try {
      isLoading.value = true;
      await _deliveryRepository.completeDelivery(deliveryId);
      SnackbarUtils.showSuccess('OTP sent to customer');
    } catch (e) {
      SnackbarUtils.showError('Failed to send OTP.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String deliveryId, int otp) async {
    try {
      isLoading.value = true;
      await _deliveryRepository.verifyDelivery(deliveryId, otp);
      SnackbarUtils.showSuccess('Delivery completed!');
      fetchAll();
      Get.back();
    } catch (e) {
      SnackbarUtils.showError('Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }
}
