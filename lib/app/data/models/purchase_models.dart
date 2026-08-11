import 'wallet_models.dart';

class MetalPurchaseSession {
  final String id;
  final String metalType;
  final String transactionType;
  final double metalGrams;
  final double lockedRate;
  final double totalAmount;
  final double gst;
  final double finalAmount;
  final double gstRate;
  final String status;
  final DateTime expiresAt;

  MetalPurchaseSession({
    required this.id,
    required this.metalType,
    required this.transactionType,
    required this.metalGrams,
    required this.lockedRate,
    required this.totalAmount,
    required this.gst,
    required this.finalAmount,
    required this.gstRate,
    required this.status,
    required this.expiresAt,
  });

  factory MetalPurchaseSession.fromJson(Map<String, dynamic> json) {
    return MetalPurchaseSession(
      id: json['id']?.toString() ?? '',
      metalType: json['metalType'] ?? json['metal_type'] ?? '',
      transactionType:
          json['transactionType'] ?? json['transaction_type'] ?? '',
      metalGrams: parseDouble(json['metalGrams'] ?? json['metal_grams']),
      lockedRate: parseDouble(json['lockedRate'] ?? json['locked_rate']),
      totalAmount: parseDouble(json['totalAmount'] ?? json['total_amount']),
      gst: parseDouble(json['gst']),
      finalAmount: parseDouble(json['finalAmount'] ?? json['final_amount']),
      gstRate: parseDouble(json['gstRate'] ?? json['gst_rate']),
      status: json['status']?.toString() ?? '',
      expiresAt: parseDateTime(
        json['expiresAt'] ?? json['expires_at'],
      ),
    );
  }
}

class InitiatePurchaseRequest {
  final String metalType;
  final String transactionType;
  final double metalGrams;

  InitiatePurchaseRequest({
    required this.metalType,
    required this.transactionType,
    required this.metalGrams,
  });

  Map<String, dynamic> toJson() => {
    'metalType': metalType,
    'transactionType': transactionType,
    'metalGrams': metalGrams,
  };
}
