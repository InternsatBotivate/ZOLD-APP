import 'package:get/get.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/delivery_repository.dart';
import '../../../data/models/wallet_models.dart';
import '../../../data/models/coin_models.dart';
import '../../../data/models/delivery_models.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/network/error_handler.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository;
  final CoinRepository _coinRepository;
  final DeliveryRepository _deliveryRepository;

  WalletController({
    required WalletRepository walletRepository,
    required CoinRepository coinRepository,
    required DeliveryRepository deliveryRepository,
  }) : _walletRepository = walletRepository,
       _coinRepository = coinRepository,
       _deliveryRepository = deliveryRepository;

  final isLoading = true.obs;
  final walletBalance = Rxn<WalletBalance>();
  final walletStats = Rxn<WalletStats>();
  final coinInventory = <CoinInventory>[].obs;
  final coinTransactions = <CoinTransaction>[].obs;
  final activeDeliveries = <DeliveryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _walletRepository.getBalance(),
        _walletRepository.getStats(),
        _coinRepository.getUserInventory(),
        _coinRepository.getTransactionHistory(limit: 5),
        _deliveryRepository.getDeliveries(),
      ]).timeout(const Duration(seconds: 20));

      final balanceResponse = results[0] as dynamic;
      if (balanceResponse.success && balanceResponse.data != null) {
        walletBalance.value = balanceResponse.data;
      }

      final statsResponse = results[1] as dynamic;
      if (statsResponse.success && statsResponse.data != null) {
        walletStats.value = statsResponse.data;
      }

      final inventoryResponse = results[2] as dynamic;
      if (inventoryResponse.success && inventoryResponse.data != null) {
        coinInventory.value = List<CoinInventory>.from(inventoryResponse.data);
      } else {
        coinInventory.clear();
      }

      final transactionResponse = results[3] as dynamic;
      if (transactionResponse.success && transactionResponse.data != null) {
        coinTransactions.value = List<CoinTransaction>.from(
          transactionResponse.data,
        );
      } else {
        coinTransactions.clear();
      }

      final deliveryResponse = results[4] as dynamic;
      if (deliveryResponse.success && deliveryResponse.data != null) {
        activeDeliveries.value = (deliveryResponse.data as List<DeliveryModel>)
            .where((d) => d.status != 'DELIVERED' && d.status != 'CANCELLED')
            .toList();
      } else {
        activeDeliveries.clear();
      }
    } catch (e) {
      AppLogger.e('WalletController.fetchData error', e);
      final error = ErrorHandler.handleGeneralError(e);
      SnackbarUtils.showError(error.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  double get totalValuation => walletBalance.value?.totalValuation ?? 0;
  double get goldValuation => walletBalance.value?.goldValuation ?? 0;
  double get silverValuation => walletBalance.value?.silverValuation ?? 0;
  double get totalGold => walletBalance.value?.goldGrams ?? 0;
  double get totalSilver => walletBalance.value?.silverGrams ?? 0;

  double get goldPercentage {
    final total = goldValuation + silverValuation;
    if (total == 0) return 0.5; // Default split if zero
    return goldValuation / total;
  }

  double get silverPercentage {
    final total = goldValuation + silverValuation;
    if (total == 0) return 0.5;
    return silverValuation / total;
  }

  // Derived per-metal P/L calculations as in Next.js
  double get goldProfitLoss {
    final avgBuy = walletStats.value?.avgBuyPrice ?? 0;
    final goldCost = avgBuy * totalGold;
    return goldValuation - goldCost;
  }

  double get silverProfitLoss {
    final avgBuy = walletStats.value?.avgBuyPrice ?? 0;
    final silverCost = avgBuy * totalSilver;
    return silverValuation - silverCost;
  }

  double get goldProfitLossPercentage {
    final avgBuy = walletStats.value?.avgBuyPrice ?? 0;
    final goldCost = avgBuy * totalGold;
    if (goldCost == 0) return 0;
    return (goldProfitLoss / goldCost) * 100;
  }

  double get silverProfitLossPercentage {
    final avgBuy = walletStats.value?.avgBuyPrice ?? 0;
    final silverCost = avgBuy * totalSilver;
    if (silverCost == 0) return 0;
    return (silverProfitLoss / silverCost) * 100;
  }
}
