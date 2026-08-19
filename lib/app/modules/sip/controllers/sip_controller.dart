import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/repositories/sip_repository.dart';
import '../../../data/models/sip_models.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class SipController extends GetxController {
  final SipRepository _sipRepository;
  final _logger = Logger();

  SipController({required SipRepository sipRepository})
    : _sipRepository = sipRepository;

  final isLoading = true.obs;
  final userSipsLoading = true.obs;
  final sipPlans = <SipPlan>[].obs;
  final userSips = <Sip>[].obs;

  final creating = false.obs;
  final subscribing = false.obs;
  final toppingUp = false.obs;
  final modifying = false.obs;

  // Payment Processing State
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;

  final countdown = 5.obs;
  final successPlan = Rxn<SipPlan>();

  late Razorpay _razorpay;

  // For Razorpay tracking
  SipOrderResponse? _pendingSipOrder;
  TopupOrderResponse? _pendingTopupOrder;
  String? _pendingSipId;
  Timer? _successTimer;

  bool get isAdmin => AuthService.to.user.value?.role == 'ADMIN';

  late Worker _successWorker;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _successWorker = ever(successPlan, (plan) {
      if (plan != null) {
        _showSuccessDialog(plan);
      }
    });

    fetchData();
  }

  void _showSuccessDialog(SipPlan plan) {
    Get.dialog(
      Obx(
        () => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Closing in ${countdown.value}s',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [
                          AppColors.sipRadialStart,
                          AppColors.sipRadialMid,
                          AppColors.sipRadialEnd,
                        ],
                        center: Alignment.center,
                        radius: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.sipBorder.withValues(alpha: 0.7),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        successPlan.value = null;
                        if (Get.isDialogOpen ?? false) Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color(0xFF5A4A1A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _successWorker.dispose();
    _razorpay.clear();
    _successTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchData() async {
    await Future.wait([fetchSipPlans(), fetchUserSips()]);
  }

  Future<void> fetchSipPlans() async {
    try {
      isLoading.value = true;
      final response = await _sipRepository.getAllSips();
      sipPlans.value = response.data ?? [];
      if (!response.success && response.message != null) {
        SnackbarUtils.showInfo(response.message!);
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to load SIP plans: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserSips() async {
    try {
      userSipsLoading.value = true;
      final response = await _sipRepository.getMySips();
      userSips.value = response.data ?? [];
    } catch (e) {
      // Fail silently
    } finally {
      userSipsLoading.value = false;
    }
  }

  Future<void> createSipPlan(CreateSipRequest request) async {
    try {
      creating.value = true;
      final response = await _sipRepository.createSip(request);
      if (response.success) {
        SnackbarUtils.showSuccess('SIP plan created successfully');
        fetchSipPlans();
      }
    } catch (e) {
      SnackbarUtils.showError('Failed to create SIP plan.');
    } finally {
      creating.value = false;
    }
  }

  Future<void> subscribeToSip(SipPlan plan, double amount, int day) async {
    try {
      subscribing.value = true;
      isProcessing.value = true;
      paymentStatus.value = 'Creating Order...';
      final response = await _sipRepository.createSipOrder(
        SipOrderRequest(
          sipId: plan.id,
          name: plan.name,
          metal: plan.metal,
          amount: amount,
          dayOfMonth: day,
        ),
      );

      if (response.success && response.data != null) {
        _pendingSipOrder = response.data;
        _pendingTopupOrder = null;
        _pendingSipId = plan.id;

        _logger.i(
          '[PAYMENT_FLOW] SIP Order created: ${response.data!.orderId}',
        );
        paymentStatus.value = 'Opening Razorpay...';

        var options = {
          'key': response.data!.keyId,
          'amount': response.data!.amount,
          'name': 'Zold',
          'order_id': response.data!.orderId,
          'description':
              '${plan.name} — ${StringUtils.capitalizeFirst(plan.metal)} SIP',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {
            'contact': AuthService.to.user.value?.phone ?? '',
            'email': AuthService.to.user.value?.email ?? '',
          },
          'external': {
            'wallets': ['paytm'],
          },
        };
        _logger.i('[PAYMENT_FLOW] Opening Razorpay Gateway for SIP...');
        paymentStatus.value = 'Waiting for Payment...';
        _razorpay.open(options);
      } else {
        isProcessing.value = false;
        paymentStatus.value = '';
      }
    } catch (e) {
      isProcessing.value = false;
      paymentStatus.value = '';
      SnackbarUtils.showError('Something went wrong with the subscription.');
    } finally {
      subscribing.value = false;
    }
  }

  Future<void> topupSip(String sipId, String metal, double amount) async {
    try {
      toppingUp.value = true;
      isProcessing.value = true;
      paymentStatus.value = 'Connecting Payment...';
      final response = await _sipRepository.createTopupOrder(
        TopupOrderRequest(sipId: sipId, metal: metal, amount: amount),
      );

      if (response.success && response.data != null) {
        _pendingTopupOrder = response.data;
        _pendingSipOrder = null;
        _pendingSipId = sipId;

        paymentStatus.value = 'Opening Razorpay...';
        var options = {
          'key': response.data!.keyId,
          'amount': response.data!.amount,
          'name': 'Zold',
          'order_id': response.data!.orderId,
          'description': 'Top-up — SIP',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {
            'contact': AuthService.to.user.value?.phone ?? '',
            'email': AuthService.to.user.value?.email ?? '',
          },
          'external': {
            'wallets': ['paytm'],
          },
        };
        paymentStatus.value = 'Waiting for Payment...';
        _razorpay.open(options);
      } else {
        isProcessing.value = false;
        paymentStatus.value = '';
      }
    } catch (e) {
      isProcessing.value = false;
      paymentStatus.value = '';
      SnackbarUtils.showError('Failed to initiate top-up.');
    } finally {
      toppingUp.value = false;
    }
  }

  Future<void> modifySip(String sipId, double amount, int day) async {
    try {
      modifying.value = true;
      await _sipRepository.modifySip(
        ModifySipRequest(
          sipId: sipId,
          investmentAmount: amount,
          dayOfMonth: day,
        ),
      );
      SnackbarUtils.showSuccess('SIP modified successfully');
      fetchUserSips();
    } catch (e) {
      SnackbarUtils.showError('Failed to modify SIP.');
    } finally {
      modifying.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _logger.i(
      '[PAYMENT_FLOW] SIP Success Callback: PaymentID: ${response.paymentId}',
    );
    try {
      final sipId = _pendingSipId;
      if (sipId == null) {
        _logger.e('[PAYMENT_FLOW] SIP ID missing in callback');
        SnackbarUtils.showError(
          'Transaction ID missing. Please check your history.',
        );
        return;
      }

      isProcessing.value = true;
      paymentStatus.value = 'Verifying Payment...';

      if (_pendingSipOrder != null) {
        _logger.i('[PAYMENT_FLOW] Verifying SIP Subscription...');
        await _sipRepository.verifySip(
          SipVerifyRequest(
            sipId: sipId,
            orderId: response.orderId ?? '',
            paymentId: response.paymentId ?? '',
            signature: response.signature ?? '',
            sipDetails: _pendingSipOrder!.sipDetails,
            orderDetails: _pendingSipOrder!.orderDetails,
          ),
        );
        _logger.i('[PAYMENT_FLOW] SIP Subscription verified');

        final plan = sipPlans.firstWhereOrNull((p) => p.id == sipId);
        paymentStatus.value = 'Finalizing Transaction...';
        if (plan != null) {
          _showSuccessModal(plan);
        } else {
          SnackbarUtils.showSuccess('Subscribed to SIP successfully');
        }
      } else if (_pendingTopupOrder != null) {
        _logger.i('[PAYMENT_FLOW] Verifying SIP Top-up...');
        await _sipRepository.verifyTopup(
          TopupVerifyRequest(
            sipId: sipId,
            orderId: response.orderId ?? '',
            paymentId: response.paymentId ?? '',
            signature: response.signature ?? '',
            topupDetails: _pendingTopupOrder!.topupDetails,
            orderDetails: _pendingTopupOrder!.orderDetails,
          ),
        );
        paymentStatus.value = 'Finalizing Transaction...';
        _logger.i('[PAYMENT_FLOW] SIP Top-up verified');
        SnackbarUtils.showSuccess('Top-up successful');
      }
      fetchUserSips();

      // Refresh wallet
      try {
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().refreshData();
        }
        if (Get.isRegistered<NotificationsController>()) {
          Get.find<NotificationsController>().fetchNotifications();
        }
      } catch (e) {
        debugPrint('SIP refresh error: $e');
      }
    } catch (e) {
      _logger.e('[PAYMENT_FLOW] SIP Verification failed: $e');
      SnackbarUtils.showError('Payment verification failed: $e');
    } finally {
      isProcessing.value = false;
      paymentStatus.value = '';
      _pendingSipOrder = null;
      _pendingTopupOrder = null;
      _pendingSipId = null;
    }
  }

  void _showSuccessModal(SipPlan plan) {
    successPlan.value = plan;
    countdown.value = 5;

    _successTimer?.cancel();
    _successTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;
      if (countdown.value <= 0) {
        if (Get.isDialogOpen ?? false) Get.back();
        successPlan.value = null;
        timer.cancel();
      }
      if (successPlan.value == null) {
        timer.cancel();
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _logger.e(
      '[PAYMENT_FLOW] SIP Error Callback: Code: ${response.code}, Message: ${response.message}',
    );
    isProcessing.value = false;
    paymentStatus.value = '';
    SnackbarUtils.showError(response.message ?? 'Unknown error');
    _pendingSipOrder = null;
    _pendingTopupOrder = null;
    _pendingSipId = null;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    SnackbarUtils.showInfo(response.walletName ?? '');
  }
}
