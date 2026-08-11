import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../data/repositories/rate_repository.dart';
import '../../../../data/models/rate_models.dart';

class MetalPriceController extends GetxController {
  final AdminRepository _adminRepository;
  final RateRepository _rateRepository;

  MetalPriceController({
    required AdminRepository adminRepository,
    required RateRepository rateRepository,
  }) : _adminRepository = adminRepository,
       _rateRepository = rateRepository;

  // Loading states
  final fetching = true.obs;
  final loading = false.obs;
  final liveLoading = false.obs;
  final editing = false.obs;

  // Current Platform Rates
  final goldBuyController = TextEditingController();
  final goldSellController = TextEditingController();
  final silverBuyController = TextEditingController();
  final silverSellController = TextEditingController();

  final currentGold = Rxn<Rate>();
  final currentSilver = Rxn<Rate>();

  // Live Market Rates
  final liveGold = Rxn<LiveRate>();
  final liveSilver = Rxn<LiveRate>();

  // History
  final goldHistory = <RateHistory>[].obs;
  final silverHistory = <RateHistory>[].obs;

  // Errors/Success
  final error = ''.obs;
  final success = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  @override
  void onClose() {
    goldBuyController.dispose();
    goldSellController.dispose();
    silverBuyController.dispose();
    silverSellController.dispose();
    super.onClose();
  }

  Future<void> fetchAllData() async {
    fetching.value = true;
    error.value = '';
    try {
      await Future.wait([
        fetchCurrentRates(),
        fetchLiveMarketRates(),
        fetchRateHistory(),
      ]);
    } catch (e) {
      error.value = 'Failed to fetch some data';
    } finally {
      fetching.value = false;
    }
  }

  Future<void> fetchCurrentRates() async {
    try {
      final response = await _rateRepository.getCurrentRates();
      if (response.success && response.data != null) {
        currentGold.value = response.data!.gold;
        currentSilver.value = response.data!.silver;

        if (!editing.value) {
          _updateControllers(response.data!);
        }
      }
    } catch (e) {
      debugPrint('Error fetching current rates: $e');
    }
  }

  void _updateControllers(RateResponse data) {
    goldBuyController.text = data.gold.buyRate.toString();
    goldSellController.text = data.gold.sellRate.toString();
    silverBuyController.text = data.silver.buyRate.toString();
    silverSellController.text = data.silver.sellRate.toString();
  }

  Future<void> fetchLiveMarketRates() async {
    liveLoading.value = true;
    try {
      final response = await _rateRepository.getLiveMarketRates();
      if (response.success && response.data != null) {
        liveGold.value = response.data!.gold;
        liveSilver.value = response.data!.silver;
      }
    } catch (e) {
      debugPrint('Error fetching live rates: $e');
    } finally {
      liveLoading.value = false;
    }
  }

  Future<void> fetchRateHistory() async {
    try {
      final goldResp = await _rateRepository.getRateHistory('GOLD', limit: 5);
      final silverResp = await _rateRepository.getRateHistory(
        'SILVER',
        limit: 5,
      );

      if (goldResp.success && goldResp.data != null) {
        goldHistory.assignAll(goldResp.data!);
      }
      if (silverResp.success && silverResp.data != null) {
        silverHistory.assignAll(silverResp.data!);
      }
    } catch (e) {
      debugPrint('Error fetching rate history: $e');
    }
  }

  void startEditing() {
    editing.value = true;
    error.value = '';
    success.value = '';
  }

  void cancelEditing() {
    editing.value = false;
    error.value = '';
    if (currentGold.value != null && currentSilver.value != null) {
      _updateControllers(
        RateResponse(gold: currentGold.value!, silver: currentSilver.value!),
      );
    }
  }

  Future<void> handleSave() async {
    error.value = '';
    success.value = '';

    final goldBuy = double.tryParse(goldBuyController.text) ?? 0.0;
    final goldSell = double.tryParse(goldSellController.text) ?? 0.0;
    final silverBuy = double.tryParse(silverBuyController.text) ?? 0.0;
    final silverSell = double.tryParse(silverSellController.text) ?? 0.0;

    if (goldBuy <= 0 || goldSell <= 0 || silverBuy <= 0 || silverSell <= 0) {
      error.value = 'All rates must be valid positive numbers.';
      return;
    }

    if (goldSell >= goldBuy) {
      error.value = 'Gold sell rate must be lower than buy rate.';
      return;
    }

    if (silverSell >= silverBuy) {
      error.value = 'Silver sell rate must be lower than buy rate.';
      return;
    }

    // Live price floor validation
    if (liveGold.value != null && liveGold.value!.buyRate > 0) {
      if (goldBuy < liveGold.value!.buyRate) {
        error.value = 'Gold buy rate cannot be lower than live market price.';
        return;
      }
      if (goldSell < liveGold.value!.sellRate) {
        error.value = 'Gold sell rate cannot be lower than live market price.';
        return;
      }
    }

    if (liveSilver.value != null && liveSilver.value!.buyRate > 0) {
      if (silverBuy < liveSilver.value!.buyRate) {
        error.value = 'Silver buy rate cannot be lower than live market price.';
        return;
      }
      if (silverSell < liveSilver.value!.sellRate) {
        error.value =
            'Silver sell rate cannot be lower than live market price.';
        return;
      }
    }

    loading.value = true;
    try {
      final payload = {
        'gold': {'buyRate': goldBuy, 'sellRate': goldSell},
        'silver': {'buyRate': silverBuy, 'sellRate': silverSell},
      };

      final response = await _adminRepository.updateMetalPrices(payload);
      if (response.success) {
        success.value = 'Metal prices updated successfully.';
        editing.value = false;
        await fetchCurrentRates();
        await fetchRateHistory();
      } else {
        error.value = response.message ?? 'Update failed.';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}
