import 'wallet_models.dart';

// Unified payment models for Razorpay integration
class RazorpayOrder {
  final String id;
  final int amount;
  final String currency;
  final String? status;
  final String? keyId;

  RazorpayOrder({
    required this.id,
    required this.amount,
    required this.currency,
    this.status,
    this.keyId,
  });

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    // Handle both root response and nested 'order' response
    final map = json.containsKey('order')
        ? json['order'] as Map<String, dynamic>
        : json;
    return RazorpayOrder(
      id: (map['orderId'] ?? map['id'] ?? map['order_id'] ?? '').toString(),
      amount: parseInt(map['amount']),
      currency: (map['currency'] ?? 'INR').toString(),
      status: map['status']?.toString(),
      keyId: (map['keyId'] ?? map['key_id'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'currency': currency,
    if (status != null) 'status': status,
    if (keyId != null) 'keyId': keyId,
  };
}

class PaymentVerifyRequest {
  final String sessionId;
  final String orderId;
  final String paymentId;
  final String signature;

  PaymentVerifyRequest({
    required this.sessionId,
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'session_id': sessionId,
    'orderId': orderId,
    'paymentId': paymentId,
    'signature': signature,
    'razorpay_order_id': orderId,
    'razorpay_payment_id': paymentId,
    'razorpay_signature': signature,
  };
}
