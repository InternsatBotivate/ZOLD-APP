import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'wallet_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../data/repositories/gift_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/models/gift_models.dart';
import '../../../data/models/coin_models.dart';
import '../../../data/models/wallet_models.dart';
import '../../../data/models/auth_models.dart';

class GiftController extends GetxController {
  final GiftRepository _giftRepository;
  final WalletRepository _walletRepository;
  final CoinRepository _coinRepository;
  final RateRepository _rateRepository;

  GiftController({
    required GiftRepository giftRepository,
    required WalletRepository walletRepository,
    required CoinRepository coinRepository,
    required RateRepository rateRepository,
  }) : _giftRepository = giftRepository,
       _walletRepository = walletRepository,
       _coinRepository = coinRepository,
       _rateRepository = rateRepository;

  final isLoading = false.obs;
  final isInventoryLoading = false.obs;

  // Payment Processing State
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;

  final goldPrice = 0.0.obs;
  final silverPrice = 0.0.obs;
  final walletBalance = Rxn<WalletBalance>();
  final coinInventory = <CoinInventory>[].obs;

  final step = 'metal'.obs; // metal, form, amount, recipient, message, confirm
  final metalType = 'GOLD'.obs;
  final giftType = 'VIRTUAL'.obs;

  final weightController = TextEditingController();
  final valueController = TextEditingController();
  final gramsAmount = 0.0.obs;
  final inputMode = 'weight'.obs; // weight, amount

  final selectedCoin = 1.obs;
  final coinQuantity = 1.obs;

  final recipientPhone = ''.obs;
  final recipientName = ''.obs;
  final personalMessage = ''.obs;
  final occasion = 'birthday'.obs;

  final selectedAmount = Rxn<int>();
  final errorText = ''.obs;
  static const double maxGiftValue = 200000.0;

  final lookupResult = Rxn<User>();
  final isLookingUp = false.obs;

  final presetGrams = [0.1, 0.25, 0.5, 1.0, 2.0].obs;
  final presetAmounts = [500, 1000, 2000, 5000, 10000].obs;

  final occasions = [
    {'id': 'birthday', 'label': '🎂 Birthday'},
    {'id': 'wedding', 'label': '💍 Wedding'},
    {'id': 'anniversary', 'label': '❤️ Anniversary'},
    {'id': 'diwali', 'label': '🪔 Diwali'},
    {'id': 'general', 'label': '🎁 General'},
  ].obs;

  late Worker _recipientWorker;

  @override
  void onInit() {
    super.onInit();

    // Handle arguments for pre-selected coin gift
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['initialGiftType'] == 'coins') {
        giftType.value = 'COIN';
        metalType.value = args['metalType'] ?? 'GOLD';
        selectedCoin.value = args['initialCoinGrams'] ?? 1;
        coinQuantity.value = args['initialCoinQuantity'] ?? 1;
        step.value = 'amount';
      }
    }

    fetchInitialData();

    _recipientWorker = debounce(recipientPhone, (val) {
      if (val.length == 10) {
        lookupUser(val);
      } else {
        lookupResult.value = null;
        recipientName.value = '';
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    _recipientWorker.dispose();
    weightController.dispose();
    valueController.dispose();
    super.onClose();
  }

  Future<void> fetchInitialData() async {
    isInventoryLoading.value = true;
    isLoading.value = true; // Use existing isLoading for rates
    try {
      final walletController = Get.find<WalletController>();

      // Reuse data from WalletController
      if (walletController.coinInventory.isNotEmpty) {
        coinInventory.value = walletController.coinInventory;
      }
      if (walletController.walletBalance.value != null) {
        walletBalance.value = walletController.walletBalance.value;
      }

      // Fetch rates (Most critical for UI)
      try {
        final ratesResponse = await _rateRepository.getCurrentRates();
        if (ratesResponse.success && ratesResponse.data != null) {
          goldPrice.value = parseDouble(ratesResponse.data!.gold.buyRate);
          silverPrice.value = parseDouble(ratesResponse.data!.silver.buyRate);
          Get.log(
            'Rates updated: Gold=${goldPrice.value}, Silver=${silverPrice.value}',
          );
        }
      } catch (e) {
        Get.log('Error fetching rates: $e');
      } finally {
        isLoading.value = false;
      }

      // Fetch inventory and balance in background
      await Future.wait([
        _coinRepository
            .getUserInventory()
            .then((res) {
              if (res.success) coinInventory.value = res.data ?? [];
              return null;
            })
            .catchError((e) {
              Get.log('Error fetching inventory: $e');
              return null;
            }),

        _walletRepository
            .getBalance()
            .then((res) {
              if (res.success) walletBalance.value = res.data;
              return null;
            })
            .catchError((e) {
              Get.log('Error fetching balance: $e');
              return null;
            }),
      ]);

      updateValueFromWeight();
    } catch (e) {
      Get.log('Error loading initial gift data: $e');
    } finally {
      isInventoryLoading.value = false;
    }
  }

  void updateValueFromWeight() {
    final price = metalType.value == 'GOLD' ? goldPrice.value : silverPrice.value;
    if (price > 0) {
      final value = gramsAmount.value * price;
      if (value > maxGiftValue) {
        errorText.value = 'Value cannot exceed ₹2,00,000';
      } else {
        errorText.value = '';
      }
      final textValue = value == 0 ? "" : value.toStringAsFixed(2);
      if (valueController.text != textValue) {
        valueController.text = textValue;
      }
    }
  }

  void updateWeightFromValue() {
    final price = metalType.value == 'GOLD' ? goldPrice.value : silverPrice.value;
    if (price > 0) {
      final value = double.tryParse(valueController.text) ?? 0.0;
      if (value > maxGiftValue) {
        errorText.value = 'Value cannot exceed ₹2,00,000';
      } else {
        errorText.value = '';
      }
      final weight = value / price;
      gramsAmount.value = weight;
      final textWeight = weight == 0 ? "" : weight.toStringAsFixed(3);
      if (weightController.text != textWeight) {
        weightController.text = textWeight;
      }
    }
  }

  void handleWeightChange(String val) {
    inputMode.value = 'weight';
    final parsed = double.tryParse(val) ?? 0.0;
    gramsAmount.value = parsed;
    selectedAmount.value = null;
    updateValueFromWeight();
  }

  void handleValueChange(String val) {
    inputMode.value = 'amount';
    final cleanVal = val.replaceAll(',', '');
    final parsed = double.tryParse(cleanVal) ?? 0.0;
    
    if (parsed > maxGiftValue) {
      errorText.value = 'Value cannot exceed ₹2,00,000';
    } else {
      errorText.value = '';
    }

    if (presetAmounts.contains(parsed.toInt())) {
      selectedAmount.value = parsed.toInt();
    } else {
      selectedAmount.value = null;
    }
    updateWeightFromValue();
  }

  void handleSwap() {
    if (inputMode.value == 'weight') {
      inputMode.value = 'amount';
    } else {
      inputMode.value = 'weight';
    }
  }

  void setFromWeight(double grams) {
    inputMode.value = 'weight';
    selectedAmount.value = null;
    gramsAmount.value = grams;
    weightController.text = grams.toString();
    updateValueFromWeight();
  }

  void setFromAmount(int amount) {
    inputMode.value = 'amount';
    selectedAmount.value = amount;
    valueController.text = amount.toString();
    updateWeightFromValue();
  }

  Future<void> lookupUser(String phone) async {
    try {
      isLookingUp.value = true;
      final response = await _giftRepository.lookupUser(phone);
      lookupResult.value = response.data;
      if (response.data != null) {
        recipientName.value = response.data!.name;
      }
    } catch (e) {
      lookupResult.value = null;
    } finally {
      isLookingUp.value = false;
    }
  }

  Future<void> sendGift() async {
    if (isProcessing.value) return;

    final price = metalType.value == 'GOLD' ? goldPrice.value : silverPrice.value;
    final value = giftType.value == 'VIRTUAL' 
        ? (gramsAmount.value * price)
        : (selectedCoin.value * coinQuantity.value * price);

    if (value > maxGiftValue) {
      SnackbarUtils.showError('Gift value cannot exceed ₹2,00,000');
      return;
    }

    final user = lookupResult.value;
    if (user == null) {
      SnackbarUtils.showError('Recipient not found');
      return;
    }

    try {
      isProcessing.value = true;
      paymentStatus.value = 'Verifying Details...';
      await _giftRepository.sendGift(
        GiftSendRequest(
          recipientId: user.id,
          metalType: metalType.value,
          giftType: giftType.value,
          metalGrams: giftType.value == 'VIRTUAL' ? gramsAmount.value : null,
          coinGrams: giftType.value == 'COIN' ? selectedCoin.value : null,
          coinQuantity: giftType.value == 'COIN' ? coinQuantity.value : null,
          message: personalMessage.value,
          occasion: occasion.value,
        ),
      );
      paymentStatus.value = 'Finalizing Transaction...';
      Get.back();
      SnackbarUtils.showSuccess('Gift sent successfully');

      // Refresh required data
      try {
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshData();
        }
        if (Get.isRegistered<NotificationsController>()) {
          Get.find<NotificationsController>().fetchNotifications();
        }
      } catch (e) {
        debugPrint('Gift refresh error: $e');
      }
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isProcessing.value = false;
      paymentStatus.value = '';
    }
  }

  int getCoinBalance(int grams) {
    final inv = coinInventory.firstWhereOrNull(
      (c) => c.coinGrams == grams && c.metal == metalType.value,
    );
    return inv?.quantity ?? 0;
  }
}
