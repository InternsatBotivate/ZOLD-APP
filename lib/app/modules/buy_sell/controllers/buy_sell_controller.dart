import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/socket_service.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/network/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/purchase_models.dart';
import '../../../data/models/payment_models.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../routes/app_routes.dart';

enum BuySellState { input, review, success }

class BuySellController extends GetxController {
  final PurchaseRepository purchaseRepository;
  final RateRepository rateRepository;
  final WalletRepository walletRepository;

  BuySellController({
    required this.purchaseRepository,
    required this.rateRepository,
    required this.walletRepository,
  });

  // Constants
  static const double minPurchase = 1000.0;
  static const double maxPurchase = 200000.0;

  // Parameters
  final metalType = 'GOLD'.obs;
  final actionType = 'BUY'.obs;

  // State Variables
  final currentState = BuySellState.input.obs;
  final isLoading = true.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;
  final currentRate = 0.0.obs;
  final buyPrice = 0.0.obs;
  final sellPrice = 0.0.obs;
  final gstRate = 3.0.obs;
  final currentBalance = 0.0.obs;

  final amountController = TextEditingController();
  final gramsController = TextEditingController();
  final amountFocusNode = FocusNode();
  final gramsFocusNode = FocusNode();

  final metalGrams = 0.0.obs;
  final totalAmount = 0.0.obs;

  // Session details
  final session = Rxn<MetalPurchaseSession>();
  final activeOrderId = RxnString();
  final timerSeconds = 0.obs;
  Timer? _sessionTimer;
  Timer? _redirectTimer;
  final redirectCountdown = 10.obs;

  // Payment Processing State
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;

  // UI state
  final isProceedChecked = false.obs;
  final showLeaveDialog = false.obs;
  final rangeError = ''.obs;
  final isInsufficientBalance = false.obs;

  // Razorpay
  late Razorpay _razorpay;
  bool _razorpayInitialized = false;

  late Worker _refreshWorker;

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('BuySellController Initialized');
    metalType.value = Get.parameters['metal']?.toUpperCase() ?? 'GOLD';
    actionType.value = Get.parameters['action']?.toUpperCase() ?? 'BUY';

    _initRazorpay();
    _loadInitialData();
    _initSocketListeners();

    amountController.addListener(_onAmountChanged);
    gramsController.addListener(_onGramsChanged);

    _refreshWorker = everAll([metalType, actionType], (_) {
      if (currentState.value == BuySellState.input) {
        buyPrice.value = 0.0;
        sellPrice.value = 0.0;
        currentRate.value = 0.0;
        currentBalance.value = 0.0;
        refreshData(showLoader: true);
      } else {
        refreshData(showLoader: false);
      }
    });
  }

  void _initRazorpay() {
    try {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _razorpayInitialized = true;
      AppLogger.i('Razorpay Listeners Attached');
    } catch (e) {
      AppLogger.e('Failed to initialize Razorpay', e);
    }
  }

  void _loadInitialData() async {
    if (isLoading.value && currentState.value != BuySellState.input) return;

    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    try {
      await Future.wait([
        fetchInitialRates(),
        fetchGstRate(),
        fetchWalletBalance(),
        restoreActiveSession(),
      ]).timeout(const Duration(seconds: 15));
      
      _updateCurrentRate();

      if (currentState.value == BuySellState.input) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (amountFocusNode.canRequestFocus) {
            amountFocusNode.requestFocus();
          }
        });
      }

      if (buyPrice.value <= 0 || sellPrice.value <= 0) {
        throw Exception('Market rates are currently unavailable. Please try again in a moment.');
      }
    } catch (e) {
      AppLogger.e('Error loading initial data', e);
      isError.value = true;
      errorMessage.value = ErrorHandler.handleGeneralError(e).message;
    } finally {
      isLoading.value = false;
    }
  }

  void retry() => _loadInitialData();

  bool _isRefreshing = false;
  Future<void> refreshData({bool showLoader = false}) async {
    if (_isRefreshing && !showLoader) return;
    _isRefreshing = true;

    if (showLoader && currentState.value == BuySellState.input) {
      isLoading.value = true;
      _isUpdating = true;
      
      buyPrice.value = 0.0;
      sellPrice.value = 0.0;
      currentRate.value = 0.0;
      
      amountController.clear();
      gramsController.clear();
      metalGrams.value = 0.0;
      totalAmount.value = 0.0;
      rangeError.value = '';
      isInsufficientBalance.value = false;
      _isUpdating = false;
    }
    
    isError.value = false;
    errorMessage.value = '';

    try {
      await Future.wait([
        fetchInitialRates(),
        fetchGstRate(),
        fetchWalletBalance(),
        restoreActiveSession(),
      ]).timeout(const Duration(seconds: 10));
      
      _updateCurrentRate();
      
      if (currentState.value == BuySellState.input) {
        if (amountController.text.isNotEmpty || gramsController.text.isNotEmpty) {
          _syncInputs();
        }
        isProceedChecked.value = false;
      }

      if (buyPrice.value <= 0 || sellPrice.value <= 0) {
        throw Exception('Rates not available at the moment.');
      }
    } catch (e) {
      AppLogger.e('Error refreshing data', e);
      if (currentState.value == BuySellState.input && showLoader) {
        isError.value = true;
        errorMessage.value = ErrorHandler.handleGeneralError(e).message;
      }
    } finally {
      _isRefreshing = false;
      if (showLoader) isLoading.value = false;
    }
  }

  void _updateCurrentRate() {
    currentRate.value = actionType.value == 'BUY'
        ? buyPrice.value
        : sellPrice.value;
  }

  Future<void> fetchWalletBalance() async {
    try {
      final response = await walletRepository.getBalance();
      if (response.success && response.data != null) {
        if (metalType.value == 'GOLD') {
          currentBalance.value = response.data!.goldGrams;
        } else {
          currentBalance.value = response.data!.silverGrams;
        }
      }
    } catch (e) {
      AppLogger.e('Error fetching balance', e);
    }
  }

  @override
  void onClose() {
    _refreshWorker.dispose();
    _sessionTimer?.cancel();
    _redirectTimer?.cancel();
    amountController.dispose();
    gramsController.dispose();
    amountFocusNode.dispose();
    gramsFocusNode.dispose();
    
    if (_razorpayInitialized) {
      _razorpay.clear();
    }

    if (_goldListener != null) {
      SocketService.to.off('goldPriceUpdate', _goldListener);
    }
    if (_silverListener != null) {
      SocketService.to.off('silverPriceUpdate', _silverListener);
    }

    super.onClose();
  }

  Future<void> fetchGstRate() async {
    try {
      final response = await rateRepository.getGst();
      if (response.success) {
        gstRate.value = response.data!;
      }
    } catch (e) {
      AppLogger.e('Error fetching GST', e);
    }
  }

  Future<void> restoreActiveSession() async {
    try {
      final response = await purchaseRepository.getActiveSession().timeout(const Duration(seconds: 5));
      if (response.success && response.data != null) {
        final activeSession = response.data!;
        
        if (session.value?.id != activeSession.id) {
          metalType.value = activeSession.metalType;
          actionType.value = activeSession.transactionType;
          session.value = activeSession;
          currentState.value = BuySellState.review;
          startSessionTimer();
          AppLogger.i('Active Session Restored: ${activeSession.id}');
        }
      } else {
        if (currentState.value == BuySellState.review) {
          AppLogger.w('No active session on server, reverting to input state');
          session.value = null;
          _sessionTimer?.cancel();
          currentState.value = BuySellState.input;
          SnackbarUtils.showInfo('Session was cancelled or expired.');
        }
      }
    } catch (e) {
      AppLogger.e('Error restoring session', e);
      if (currentState.value == BuySellState.review) {
         final error = ErrorHandler.handleGeneralError(e);
         if (error is AuthFailure || error is NotFoundFailure) {
            session.value = null;
            _sessionTimer?.cancel();
            currentState.value = BuySellState.input;
         }
      }
    }
  }

  Future<void> fetchInitialRates() async {
    try {
      final response = await rateRepository.getCurrentRates().timeout(const Duration(seconds: 5));
      if (response.success && response.data != null) {
        final rates = response.data!;
        if (metalType.value == 'GOLD') {
          buyPrice.value = rates.gold.buyRate;
          sellPrice.value = rates.gold.sellRate;
        } else {
          buyPrice.value = rates.silver.buyRate;
          sellPrice.value = rates.silver.sellRate;
        }
        _updateCurrentRate();
      }
    } catch (e) {
      AppLogger.e('Error fetching initial rates', e);
    }
  }

  Function(dynamic)? _goldListener;
  Function(dynamic)? _silverListener;

  void _initSocketListeners() {
    _goldListener = (data) {
      if (data != null && data is Map) {
        final buy = data['buyRate'];
        final sell = data['sellRate'];
        if (buy is num && sell is num) {
          if (metalType.value == 'GOLD') {
            buyPrice.value = buy.toDouble();
            sellPrice.value = sell.toDouble();
            _updateCurrentRate();
            if (currentState.value == BuySellState.input) {
              _syncInputs();
            }
          }
        }
      }
    };

    _silverListener = (data) {
      if (data != null && data is Map) {
        final buy = data['buyRate'];
        final sell = data['sellRate'];
        if (buy is num && sell is num) {
          if (metalType.value == 'SILVER') {
            buyPrice.value = buy.toDouble();
            sellPrice.value = sell.toDouble();
            _updateCurrentRate();
            if (currentState.value == BuySellState.input) {
              _syncInputs();
            }
          }
        }
      }
    };

    SocketService.to.on('goldPriceUpdate', _goldListener!);
    SocketService.to.on('silverPriceUpdate', _silverListener!);
  }

  void _syncInputs() {
    if (_activeInput == 'amount') {
      _recalculateFromAmount();
    } else {
      _recalculateFromGrams();
    }
  }

  bool _isUpdating = false;
  String _activeInput = 'amount';

  void _onAmountChanged() {
    if (_isUpdating) return;
    _activeInput = 'amount';
    _isUpdating = true;
    _recalculateFromAmount();
    _validateInputs();
    _isUpdating = false;
  }

  void _onGramsChanged() {
    if (_isUpdating) return;
    _activeInput = 'grams';
    _isUpdating = true;
    _recalculateFromGrams();
    _validateInputs();
    _isUpdating = false;
  }

  void _recalculateFromAmount() {
    final amountText = amountController.text.replaceAll(',', '');
    var amount = double.tryParse(amountText) ?? 0.0;

    if (amount > maxPurchase) {
      amount = maxPurchase;
      final text = amount.toStringAsFixed(0);
      amountController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (currentRate.value > 0) {
      final grams = amount / currentRate.value;
      gramsController.text = amount > 0 ? grams.toStringAsFixed(4) : '';
      metalGrams.value = grams;
      totalAmount.value = amount;
    } else {
      metalGrams.value = 0.0;
      totalAmount.value = amount;
    }
  }

  void _recalculateFromGrams() {
    final gramsText = gramsController.text.replaceAll(',', '');
    final grams = double.tryParse(gramsText) ?? 0.0;
    if (currentRate.value > 0) {
      var amount = grams * currentRate.value;

      if (amount > maxPurchase) {
        amount = maxPurchase;
        final cappedGrams = amount / currentRate.value;
        final gramsTextValue = cappedGrams.toStringAsFixed(4);
        gramsController.value = TextEditingValue(
          text: gramsTextValue,
          selection: TextSelection.collapsed(offset: gramsTextValue.length),
        );
        amountController.text = amount.toStringAsFixed(2);
        metalGrams.value = cappedGrams;
        totalAmount.value = amount;
      } else {
        amountController.text = grams > 0 ? amount.toStringAsFixed(2) : '';
        metalGrams.value = grams;
        totalAmount.value = amount;
      }
    } else {
      metalGrams.value = grams;
      totalAmount.value = 0.0;
    }
  }

  void _validateInputs() {
    if (actionType.value == 'BUY') {
      if (totalAmount.value > 0) {
        if (totalAmount.value < minPurchase) {
          rangeError.value =
              'Minimum purchase amount is ₹${NumberFormat('#,##,##0').format(minPurchase)}';
        } else if (totalAmount.value > maxPurchase) {
          rangeError.value =
              'Maximum purchase allowed is ₹${NumberFormat('#,##,##0').format(maxPurchase)}';
        } else {
          rangeError.value = '';
        }
      } else {
        rangeError.value = '';
      }
      isInsufficientBalance.value = false;
    } else {
      if (totalAmount.value > maxPurchase) {
        rangeError.value =
            'Maximum sale allowed is ₹${NumberFormat('#,##,##0').format(maxPurchase)}';
      } else {
        rangeError.value = '';
      }
      isInsufficientBalance.value = metalGrams.value > currentBalance.value;
    }
  }

  void handleSwap() {
    if (_activeInput == 'amount') {
      _activeInput = 'grams';
      _recalculateFromGrams();
    } else {
      _activeInput = 'amount';
      _recalculateFromAmount();
    }
    _validateInputs();
  }

  void selectAmount(double amount) {
    amountController.text = amount.toString();
  }

  void selectGrams(double grams) {
    gramsController.text = grams.toString();
  }

  Future<void> proceedToReview() async {
    if (isProcessing.value) return; // Prevent double tap
    
    if (metalGrams.value <= 0) {
      SnackbarUtils.showError('Please enter a valid amount');
      return;
    }

    if (actionType.value == 'BUY') {
      if (totalAmount.value < minPurchase || totalAmount.value > maxPurchase) {
        SnackbarUtils.showError(
          rangeError.value.isNotEmpty ? rangeError.value : 'Invalid amount',
        );
        return;
      }
    } else {
      if (metalGrams.value > currentBalance.value) {
        SnackbarUtils.showError('Insufficient balance');
        return;
      }
      if (!isProceedChecked.value) {
        SnackbarUtils.showError('Please confirm that you understand the action');
        return;
      }
    }

    AppLogger.i('Initiating Session...');
    isProcessing.value = true;
    paymentStatus.value = 'Creating Session...';
    try {
      final request = InitiatePurchaseRequest(
        metalType: metalType.value,
        transactionType: actionType.value,
        metalGrams: metalGrams.value,
      );

      final response = await purchaseRepository.initiatePurchase(request).timeout(const Duration(seconds: 15));
      if (response.success && response.data != null) {
        session.value = response.data;
        metalType.value = response.data!.metalType.toUpperCase();
        actionType.value = response.data!.transactionType.toUpperCase();
        
        currentState.value = BuySellState.review;
        startSessionTimer();
        AppLogger.i('Session Initiated: ${response.data!.id}');
      } else {
        AppLogger.e('Initiation Failed: ${response.message}');
        SnackbarUtils.showError(response.message ?? 'Failed to initiate session');
      }
    } catch (e) {
      AppLogger.e('Initiation Exception', e);
      SnackbarUtils.showError(ErrorHandler.handleGeneralError(e).message);
    } finally {
      isProcessing.value = false;
      paymentStatus.value = '';
    }
  }

  void startSessionTimer() {
    _sessionTimer?.cancel();
    final expiry = session.value?.expiresAt;
    if (expiry == null) return;

    _updateTimer();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    final expiry = session.value?.expiresAt;
    if (expiry == null) {
       _sessionTimer?.cancel();
       return;
    }

    final diff = expiry.difference(DateTime.now()).inSeconds;
    if (diff <= 0) {
      timerSeconds.value = 0;
      _sessionTimer?.cancel();
      _handleSessionExpired();
    } else {
      timerSeconds.value = diff;
    }
  }

  bool _isShowingExpiryDialog = false;
  void _handleSessionExpired() {
    AppLogger.w('Session Expired');
    final wasInReview = currentState.value == BuySellState.review;
    session.value = null;
    
    if (wasInReview && !_isShowingExpiryDialog) {
      _isShowingExpiryDialog = true;
      Get.dialog(
        AlertDialog(
          title: const Text('Session Expired'),
          content: const Text('Your price lock has expired. Please start over with updated rates.'),
          actions: [
            TextButton(
              onPressed: () {
                _isShowingExpiryDialog = false;
                Get.back();
                currentState.value = BuySellState.input;
                refreshData(showLoader: true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      currentState.value = BuySellState.input;
    }
  }

  Future<void> cancelSession() async {
    if (session.value == null) {
      currentState.value = BuySellState.input;
      return;
    }
    
    final sessionId = session.value!.id;
    session.value = null;
    _sessionTimer?.cancel();
    currentState.value = BuySellState.input;
    
    try {
      await purchaseRepository.cancelSession(sessionId).timeout(const Duration(seconds: 5));
      AppLogger.i('Session Cancelled: $sessionId');
    } catch (e) {
      AppLogger.w('Error during session cancellation: $e');
    }
    
    refreshData(showLoader: false);
  }

  void handleClose() {
    if (isProcessing.value) return;
    if (session.value != null) {
      showLeaveDialog.value = true;
    } else {
      Get.back();
    }
  }

  Future<void> confirmLeave() async {
    await cancelSession();
    showLeaveDialog.value = false;
    Get.back();
  }

  Future<void> executeTransaction() async {
    if (session.value == null || isProcessing.value) {
      return;
    }

    AppLogger.i('Executing transaction: ${actionType.value}');
    isProcessing.value = true;
    paymentStatus.value = actionType.value == 'BUY' ? 'Creating Order...' : 'Processing Sale...';

    try {
      if (actionType.value == 'BUY') {
        final orderResponse = await purchaseRepository.createOrder(
          session.value!.id,
        ).timeout(const Duration(seconds: 20));
        
        if (orderResponse.success && orderResponse.data != null) {
          final order = orderResponse.data!;
          activeOrderId.value = order.id;

          paymentStatus.value = 'Opening Razorpay...';

          final options = {
            'key': order.keyId ?? ApiConstants.razorpayKey,
            'amount': order.amount,
            'name': 'Zold',
            'order_id': order.id,
            'description':
                'Buy ${session.value!.metalGrams.toStringAsFixed(3)}g ${metalType.value}',
            'timeout': 300,
            'prefill': {
              'contact': AuthService.to.user.value?.phone ?? '',
              'email': AuthService.to.user.value?.email ?? '',
            },
            'method': {
              'upi': true,
              'netbanking': true,
              'card': true,
              'wallet': true,
            },
            'theme': {'color': '#B8960C'},
          };
          
          if (_razorpayInitialized) {
             _razorpay.open(options);
             paymentStatus.value = 'Waiting for Payment...';
          } else {
             throw Exception('Payment gateway initialization failed. Please try again.');
          }
        } else {
          AppLogger.e('Order creation failed: ${orderResponse.message}');
          isProcessing.value = false;
          
          final msg = orderResponse.message?.toLowerCase() ?? '';
          if (msg.contains('cancelled') || msg.contains('not found') || msg.contains('expired')) {
            await cancelSession();
            SnackbarUtils.showError('Session is no longer active.');
          } else {
            SnackbarUtils.showError(orderResponse.message ?? 'Order Failure');
          }
        }
      } else {
        paymentStatus.value = 'Processing Sale...';
        final sellResponse = await purchaseRepository.executeSell(
          session.value!.id,
        ).timeout(const Duration(seconds: 30));
        
        if (sellResponse.success) {
          _onSuccess();
        } else {
          AppLogger.e('Sell failed: ${sellResponse.message}');
          isProcessing.value = false;
          
          final msg = sellResponse.message?.toLowerCase() ?? '';
          if (msg.contains('cancelled') || msg.contains('not found') || msg.contains('expired')) {
            await cancelSession();
            SnackbarUtils.showError('Session is no longer active.');
          } else {
            SnackbarUtils.showError(sellResponse.message ?? 'Failed to execute sale');
          }
        }
      }
    } catch (e) {
      AppLogger.e('Execution Exception', e);
      isProcessing.value = false;
      
      final error = ErrorHandler.handleGeneralError(e);
      if (error is AuthFailure || error is NotFoundFailure) {
        await cancelSession();
        SnackbarUtils.showError('Session is no longer active. Please start again.');
      } else {
        SnackbarUtils.showError(error.message);
      }
    }
  }

  void _onSuccess() {
    isProcessing.value = true;
    paymentStatus.value = 'Finalizing Transaction...';

    SnackbarUtils.showSuccess(
      '${actionType.value == 'BUY' ? 'Purchase' : 'Sale'} successful!',
    );

    currentState.value = BuySellState.success;
    session.value = null;
    _sessionTimer?.cancel();
    _startRedirectTimer();

    fetchWalletBalance();

    try {
      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().refreshData();
      }
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().fetchNotifications();
      }
    } catch (e) {
       AppLogger.w('Background refresh failed: $e');
    } finally {
       isProcessing.value = false;
    }
  }

  void _startRedirectTimer() {
    _redirectTimer?.cancel();
    redirectCountdown.value = 10;
    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (redirectCountdown.value <= 1) {
        timer.cancel();
        Get.offAllNamed(Routes.home, arguments: {'tab': 1});
      } else {
        redirectCountdown.value--;
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    AppLogger.i('Payment Success Callback: PaymentID: ${response.paymentId}');
    final currentSession = session.value;
    if (currentSession == null) {
      AppLogger.e('Session lost during payment verification');
      isProcessing.value = false;
      SnackbarUtils.showError('Session lost. Please contact support if amount was debited.');
      return;
    }

    isProcessing.value = true;
    paymentStatus.value = 'Verifying Payment...';

    try {
      final verifyRequest = PaymentVerifyRequest(
        sessionId: currentSession.id,
        orderId: response.orderId ?? '',
        paymentId: response.paymentId ?? '',
        signature: response.signature ?? '',
      );

      if (verifyRequest.orderId.isEmpty || verifyRequest.paymentId.isEmpty) {
        throw Exception('Incomplete payment information received.');
      }

      final verifyResponse = await purchaseRepository.verifyPayment(
        verifyRequest,
      ).timeout(const Duration(seconds: 45));
      
      if (verifyResponse.success) {
        _onSuccess();
      } else {
        AppLogger.e('Verification API failed: ${verifyResponse.message}');
        isProcessing.value = false;
        SnackbarUtils.showError(verifyResponse.message ?? 'Payment verification failed');
      }
    } catch (e) {
      AppLogger.e('Exception during verification', e);
      isProcessing.value = false;
      SnackbarUtils.showError(ErrorHandler.handleGeneralError(e).message);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppLogger.e('Razorpay Error Callback: Code: ${response.code}, Message: ${response.message}');

    isProcessing.value = false;

    if (session.value != null) {
      purchaseRepository.recordFailure({
        'sessionId': session.value!.id,
        'razorpay_order_id': activeOrderId.value ?? '',
        'razorpay_payment_id': '',
        'reason': response.message ?? 'User cancelled or failed',
      });
    }
    
    // Friendly message for user cancellation (code 0 in Razorpay)
    if (response.code == 0) {
       SnackbarUtils.showInfo('Payment cancelled.');
    } else {
       SnackbarUtils.showError(response.message ?? 'Transaction failed');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppLogger.i('External wallet selected: ${response.walletName}');
  }

  void viewPortfolio() {
    Get.offAllNamed(Routes.home, arguments: {'tab': 1});
  }

  String get timerText {
    final minutes = (timerSeconds.value / 60).floor();
    final seconds = timerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get gstAmount => totalAmount.value * (gstRate.value / 100);
  double get finalPayable => totalAmount.value + gstAmount;

  double get spreadPercentage {
    if (buyPrice.value <= 0) return 0.0;
    final diff = buyPrice.value - sellPrice.value;
    return (diff / buyPrice.value) * 100;
  }

  bool get isInputValid {
    if (actionType.value == 'BUY') {
      return totalAmount.value >= minPurchase &&
          totalAmount.value <= maxPurchase &&
          metalGrams.value > 0;
    } else {
      return metalGrams.value > 0 &&
          totalAmount.value <= maxPurchase &&
          !isInsufficientBalance.value &&
          isProceedChecked.value &&
          currentRate.value > 0;
    }
  }
}
