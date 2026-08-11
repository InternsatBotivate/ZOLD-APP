import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/services/socket_service.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/snackbar_utils.dart';

class CartController extends GetxController {
  final CartRepository _cartRepository;
  final RateRepository _rateRepository;

  CartController(this._cartRepository, this._rateRepository);

  final isLoading = false.obs;
  final isUpdating = false.obs;
  final checkoutLoading = false.obs;
  final cartItems = <CartItem>[].obs;
  final goldRate = 0.0.obs;
  final silverRate = 0.0.obs;
  final gstRate = 3.0.obs;

  static const double maxSubtotal = 200000.0;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[CartController] onInit called - new instance created');
    refreshCart();
    _initSocketListeners();
  }

  Function(dynamic)? _goldListener;
  Function(dynamic)? _silverListener;

  void _initSocketListeners() {
    _goldListener = (data) {
      if (data != null) {
        goldRate.value = (data['buyRate'] as num).toDouble();
      }
    };

    _silverListener = (data) {
      if (data != null) {
        silverRate.value = (data['buyRate'] as num).toDouble();
      }
    };

    SocketService.to.on('goldPriceUpdate', _goldListener!);
    SocketService.to.on('silverPriceUpdate', _silverListener!);
  }

  @override
  void onClose() {
    if (_goldListener != null) {
      SocketService.to.off('goldPriceUpdate', _goldListener);
    }
    if (_silverListener != null) {
      SocketService.to.off('silverPriceUpdate', _silverListener);
    }
    super.onClose();
  }

  Future<void> refreshCart() async {
    isLoading.value = true;
    try {
      await Future.wait([fetchRates(), fetchGstRate(), fetchCartItems()]);
    } catch (e, st) {
      debugPrint('[CartController] refreshCart FAILED: $e');
      debugPrint('$st');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRates() async {
    try {
      final response = await _rateRepository.getCurrentRates();
      if (response.data != null) {
        goldRate.value = response.data!.gold.buyRate;
        silverRate.value = response.data!.silver.buyRate;
      }
    } catch (e) {
      debugPrint('[CartController] fetchRates FAILED: $e');
    }
  }

  Future<void> fetchGstRate() async {
    try {
      final response = await _rateRepository.getGst();
      if (response.data != null) {
        gstRate.value = response.data!;
      }
    } catch (e) {
      debugPrint('[CartController] fetchGstRate FAILED: $e');
    }
  }

  Future<void> fetchCartItems() async {
    try {
      final response = await _cartRepository.getCart();
      debugPrint('[CartController] getCart() raw response: ${response.data}');
      if (response.data != null) {
        debugPrint(
          '[CartController] items from server: ${response.data!.items.length}',
        );
        cartItems.value = List<CartItem>.from(response.data!.items);
      } else {
        debugPrint('[CartController] getCart() returned null data');
      }
    } catch (e, st) {
      debugPrint('[CartController] fetchCartItems FAILED: $e');
      debugPrint('$st');
    }
  }

  Future<void> addItem(double weight, String metal) async {
    isUpdating.value = true;
    // Optimistic Update
    final existingIndex = cartItems.indexWhere(
      (i) => i.weight == weight && i.metal.toUpperCase() == metal.toUpperCase(),
    );

    if (existingIndex != -1) {
      final item = cartItems[existingIndex];
      cartItems[existingIndex] = CartItem(
        weight: item.weight,
        metal: item.metal,
        quantity: item.quantity + 1,
        basePrice: item.basePrice,
        gst: item.gst,
      );
    } else {
      cartItems.add(CartItem(weight: weight, metal: metal, quantity: 1));
    }

    try {
      final response = await _cartRepository.addCartItem(
        CartItem(weight: weight, metal: metal, quantity: 1),
      );
      debugPrint('[CartController] addCartItem response: ${response.data}');
      // Removed overwrite of cartItems with response data to maintain optimistic state
    } catch (e, st) {
      debugPrint('[CartController] addCartItem FAILED: $e');
      debugPrint('$st');
      await refreshCart(); // Revert to server state on error
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> removeItem(
    double weight,
    String metal, {
    bool removeAll = false,
  }) async {
    isUpdating.value = true;
    // Optimistic Update
    final existingIndex = cartItems.indexWhere(
      (i) => i.weight == weight && i.metal.toUpperCase() == metal.toUpperCase(),
    );

    if (existingIndex != -1) {
      if (removeAll || cartItems[existingIndex].quantity <= 1) {
        cartItems.removeAt(existingIndex);
      } else {
        final item = cartItems[existingIndex];
        cartItems[existingIndex] = CartItem(
          weight: item.weight,
          metal: item.metal,
          quantity: item.quantity - 1,
          basePrice: item.basePrice,
          gst: item.gst,
        );
      }
    }

    try {
      final response = await _cartRepository.removeCartItem(
        CartItem(weight: weight, metal: metal, quantity: 1),
        removeAll: removeAll,
      );
      debugPrint('[CartController] removeCartItem response: ${response.data}');
      // Removed overwrite of cartItems with response data to maintain optimistic state
    } catch (e, st) {
      debugPrint('[CartController] removeCartItem FAILED: $e');
      debugPrint('$st');
      await refreshCart(); // Revert to server state on error
    } finally {
      isUpdating.value = false;
    }
  }

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      final rate = item.metal.toUpperCase() == 'GOLD'
          ? goldRate.value
          : silverRate.value;
      total += item.weight * rate * item.quantity;
    }
    return total;
  }

  bool get isSubtotalExceeded => subtotal > maxSubtotal;

  double get gstAmount => (subtotal * gstRate.value) / 100;
  double get totalAmount => subtotal + gstAmount;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;
    if (isSubtotalExceeded) {
      SnackbarUtils.showError('Maximum subtotal allowed is ₹2,00,000');
      return;
    }

    checkoutLoading.value = true;
    try {
      await _cartRepository.initiateCheckout();
      await refreshCart(); // Ensure local cart reflects locked status
      Get.back(); // Close drawer
      Get.toNamed(Routes.coinCheckout);
    } catch (e, st) {
      debugPrint('[CartController] checkout FAILED: $e');
      debugPrint('$st');
    } finally {
      checkoutLoading.value = false;
    }
  }
}
