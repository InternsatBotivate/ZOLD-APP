import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/coin_models.dart';
import '../../../data/models/payment_models.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../routes/app_routes.dart';

class CoinCheckoutController extends GetxController {
  final CartRepository _cartRepository;
  late Razorpay _razorpay;
  final _logger = Logger();

  CoinCheckoutController(this._cartRepository);

  final isLoading = false.obs;
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;
  final session = Rxn<CoinPurchaseSession>();
  final remainingTime = 300.obs; // Default 5 minutes
  final sessionExpired = false.obs;
  final expiredCountdown = 10.obs;
  final paid = false.obs;
  final popupCountdown = 10.obs;

  Timer? _timer;
  Timer? _expiredTimer;
  Timer? _successTimer;

  @override
  void onInit() {
    super.onInit();
    _logger.i('[PAYMENT_FLOW] CoinCheckoutController Initialized');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    restoreSession();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _expiredTimer?.cancel();
    _successTimer?.cancel();
    _razorpay.clear();
    super.onClose();
  }

  Future<void> restoreSession() async {
    isLoading.value = true;
    try {
      final response = await _cartRepository.getActiveSession();
      if (response.data != null) {
        session.value = response.data;
        _startTimer();
        _logger.i(
          '[PAYMENT_FLOW] Active Coin Session Restored: ${response.data!.id}',
        );
      } else {
        // No active session, redirect back to coins page as per Next.js logic
        Get.offNamed(Routes.goldCoins);
      }
    } catch (e) {
      Get.offNamed(Routes.goldCoins);
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (session.value != null) {
      final now = DateTime.now();
      final difference = session.value!.expiresAt.difference(now).inSeconds;
      remainingTime.value = difference > 0 ? difference : 0;

      if (remainingTime.value <= 0) {
        _handleSessionExpired();
        return;
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final diff = session.value!.expiresAt.difference(now).inSeconds;
        remainingTime.value = diff > 0 ? diff : 0;

        if (remainingTime.value <= 0) {
          timer.cancel();
          _handleSessionExpired();
        }
      });
    }
  }

  void _handleSessionExpired() {
    _logger.w('[PAYMENT_FLOW] Coin Session Expired');
    sessionExpired.value = true;
    Get.find<CartController>().refreshCart(); // Clear local cart

    expiredCountdown.value = 10;
    _expiredTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (expiredCountdown.value > 1) {
        expiredCountdown.value--;
      } else {
        timer.cancel();
        Get.until((route) => Get.currentRoute == Routes.goldCoins);
      }
    });
  }

  Future<void> initiatePayment() async {
    if (session.value == null || sessionExpired.value || isProcessing.value) {
      _logger.w(
        '[PAYMENT_FLOW] Attempted coin payment with null/expired session or already processing',
      );
      return;
    }

    _logger.i(
      '[PAYMENT_FLOW] Initiating coin payment for session: ${session.value!.id}',
    );
    isProcessing.value = true;
    paymentStatus.value = 'Creating Order...';

    try {
      final orderResponse = await _cartRepository.createOrder(
        session.value!.id,
      );
      if (!orderResponse.success || orderResponse.data == null) {
        _logger.e(
          '[PAYMENT_FLOW] Coin Order creation failed: ${orderResponse.message}',
        );
        isProcessing.value = false;
        SnackbarUtils.showError(
          orderResponse.message ?? 'Failed to create order',
        );
        return;
      }
      final order = orderResponse.data!;

      paymentStatus.value = 'Opening Razorpay...';

      _logger.i(
        '[PAYMENT_FLOW] Coin Order created: ${order.id}, Amount: ${order.amount}',
      );

      final metalDescriptor =
          session.value!.items.any((i) => i.metal == 'SILVER')
          ? 'Silver Coins'
          : 'Gold Coins';

      var options = {
        'key': ApiConstants.razorpayKey,
        'amount': order.amount,
        'name': 'Zold Gold',
        'order_id': order.id,
        'description': 'Purchase of $metalDescriptor',
        'timeout': 300,
        'prefill': {
          'contact': AuthService.to.user.value?.phone ?? '',
          'email': AuthService.to.user.value?.email ?? '',
        },
        'theme': {'color': '#B8960C'},
      };

      _logger.i('[PAYMENT_FLOW] Opening Razorpay Gateway for Coins...');
      _razorpay.open(options);

      paymentStatus.value = 'Waiting for Payment...';
    } catch (e) {
      _logger.e('[PAYMENT_FLOW] Exception in coin payment: $e');
      isProcessing.value = false;
      SnackbarUtils.showError('Something went wrong during payment initialization.');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _logger.i(
      '[PAYMENT_FLOW] Coin Success Callback: PaymentID: ${response.paymentId}',
    );
    final currentSession = session.value;
    if (currentSession == null) {
      _logger.e('[PAYMENT_FLOW] Session lost during coin payment verification');
      return;
    }

    isProcessing.value = true;
    paymentStatus.value = 'Verifying Payment...';

    try {
      _logger.i(
        '[PAYMENT_FLOW] Verifying Coin payment for Order: ${response.orderId}',
      );
      await _cartRepository.verifyPayment(
        PaymentVerifyRequest(
          sessionId: currentSession.id,
          orderId: response.orderId ?? '',
          paymentId: response.paymentId ?? '',
          signature: response.signature ?? '',
        ),
      );

      _logger.i('[PAYMENT_FLOW] Coin Payment verified successfully');
      SnackbarUtils.showSuccess('Payment successful!');
      paymentStatus.value = 'Finalizing Transaction...';
      paid.value = true;
      Get.find<CartController>().refreshCart();

      // Refresh wallet if registered
      try {
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshData();
        }
        if (Get.isRegistered<NotificationsController>()) {
          Get.find<NotificationsController>().fetchNotifications();
        }
      } catch (e) {
        debugPrint('Coin checkout refresh error: $e');
      }

      popupCountdown.value = 10;
      _successTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (popupCountdown.value > 1) {
          popupCountdown.value--;
        } else {
          timer.cancel();
          Get.offAllNamed(Routes.home, arguments: {'tab': 1});
        }
      });
    } catch (e) {
      _logger.e('[PAYMENT_FLOW] Coin Verification failed: $e');
      SnackbarUtils.showError('Payment verification failed');
    } finally {
      isProcessing.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _logger.e(
      '[PAYMENT_FLOW] Coin Error Callback: Code: ${response.code}, Message: ${response.message}',
    );

    isProcessing.value = false;

    if (session.value != null) {
      _cartRepository.recordFailure({
        'sessionId': session.value!.id,
        'razorpay_order_id': response.message,
        'reason': response.message,
      });
    }
    SnackbarUtils.showError(response.message ?? 'Unknown error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _logger.i(
      '[PAYMENT_FLOW] External wallet selected: ${response.walletName}',
    );
  }

  Future<void> cancelSession() async {
    if (isProcessing.value) return;
    if (session.value == null) {
      Get.back();
      return;
    }
    _logger.i('[PAYMENT_FLOW] Cancelling Coin Session: ${session.value!.id}');
    isLoading.value = true;
    try {
      await _cartRepository.cancelSession(session.value!.id);
    } catch (e) {
      // Ignore
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }
}
