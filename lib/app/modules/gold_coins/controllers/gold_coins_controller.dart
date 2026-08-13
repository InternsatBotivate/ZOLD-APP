import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/coin_models.dart';
import '../../../data/models/wallet_models.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../cart/controllers/cart_controller.dart';

class GoldCoinsController extends GetxController {
  final CoinRepository _coinRepository;
  final WalletRepository _walletRepository;

  GoldCoinsController(this._coinRepository, this._walletRepository);

  final isLoading = true.obs;
  final error = ''.obs;

  final selectedMetal = 'GOLD'.obs; // 'GOLD' or 'SILVER'
  final wishlist =
      <double>[].obs; // Stores weights for now, ideally weight+metal

  final walletBalance = Rxn<WalletBalance>();

  CartController get cartController => Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _walletRepository.getBalance();
      if (response.data != null) {
        walletBalance.value = response.data;
      }
      // Rates are handled by CartController
      await cartController.refreshCart();
    } catch (e) {
      error.value = 'Failed to load data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void switchMetal(String metal) {
    selectedMetal.value = metal;
  }

  void toggleWishlist(double weight) {
    if (wishlist.contains(weight)) {
      wishlist.remove(weight);
    } else {
      wishlist.add(weight);
    }
  }

  List<CoinType> get coins {
    final metal = selectedMetal.value;
    final isGold = metal == 'GOLD';
    final currentPrice = isGold
        ? cartController.goldRate.value
        : cartController.silverRate.value;
    final purity = isGold ? '24K' : '999';
    final metalName = isGold ? 'Gold' : 'Silver';

    final List<double> weights = [1, 2, 5, 10];

    return weights.map((weight) {
      final basePrice = weight * currentPrice;
      final gst = (basePrice * cartController.gstRate.value) / 100;

      return CoinType(
        grams: weight,
        name: 'ZG ${weight.toInt()}g $metalName Mint Bar',
        description: '$purity · BIS Hallmarked',
        basePrice: basePrice,
        gst: gst,
        totalPrice: basePrice + gst,
        ratePerGram: currentPrice,
        isPopular: weight == 1,
        metal: metal,
      );
    }).toList();
  }

  Future<void> convertToCoin(double grams, int quantity) async {
    final metal = selectedMetal.value;
    final balance = metal == 'GOLD'
        ? walletBalance.value?.goldGrams ?? 0.0
        : walletBalance.value?.silverGrams ?? 0.0;

    if (balance < (grams * quantity)) {
      SnackbarUtils.showError('You do not have enough $metal in your wallet.');
      return;
    }

    isLoading.value = true;
    try {
      await _coinRepository.convertToCoin(
        BuyCoinRequest(
          coinGrams: grams.toInt(),
          quantity: quantity,
          metal: metal,
        ),
      );
      await loadData();
      SnackbarUtils.showSuccess('Conversion successful!');
    } catch (e) {
      SnackbarUtils.showError('Conversion failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
