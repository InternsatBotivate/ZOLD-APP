import 'package:flutter/foundation.dart';
import 'wallet_models.dart';

class SellRequest {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String metal;
  final String quantity;
  final double amount;
  final String paymentMode;
  final String status;
  final DateTime date;
  final String type; // METAL or COIN

  SellRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.metal,
    required this.quantity,
    required this.amount,
    required this.paymentMode,
    required this.status,
    required this.date,
    required this.type,
  });

  factory SellRequest.fromJson(Map<String, dynamic> json, String type) {
    if (type == 'METAL') {
      return SellRequest(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        userName: json['user']?['name'] ?? 'Unknown',
        userEmail: json['user']?['email'] ?? 'N/A',
        metal: json['metalType'] ?? '',
        quantity: "${parseDouble(json['metalGrams']).toStringAsFixed(3)}g",
        amount: parseDouble(json['finalAmount']),
        paymentMode: json['paymentMode'] ?? 'N/A',
        status: json['status'] ?? 'PENDING',
        date: parseDateTime(json['createdAt']),
        type: 'METAL',
      );
    } else {
      return SellRequest(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        userName: json['user']?['name'] ?? 'Unknown',
        userEmail: json['user']?['email'] ?? 'N/A',
        metal: json['metal'] ?? '',
        quantity: "${json['weight']}g (${json['quantity']}pc)",
        amount: parseDouble(json['final_amount'] ?? json['finalAmount']),
        paymentMode: json['payment_mode'] ?? json['paymentMode'] ?? 'N/A',
        status: json['status'] ?? 'PENDING',
        date: parseDateTime(json['created_at'] ?? json['createdAt']),
        type: 'COIN',
      );
    }
  }
}

class UserTransactionHistory {
  final List<MetalTransaction> metalTransactions;
  final List<CoinTransaction> coinTransactions;

  UserTransactionHistory({
    required this.metalTransactions,
    required this.coinTransactions,
  });

  factory UserTransactionHistory.fromJson(Map<String, dynamic> json) {
    return UserTransactionHistory(
      metalTransactions: (json['metalTransactions'] as List? ?? [])
          .map((e) => MetalTransaction.fromJson(e))
          .toList(),
      coinTransactions: (json['coinTransactions'] as List? ?? [])
          .map((e) => CoinTransaction.fromJson(e))
          .toList(),
    );
  }
}

class MetalTransaction {
  final String id;
  final String transactionType;
  final String metalType;
  final double metalGrams;
  final double finalAmount;
  final double ratePerGram;
  final String status;
  final DateTime createdAt;

  MetalTransaction({
    required this.id,
    required this.transactionType,
    required this.metalType,
    required this.metalGrams,
    required this.finalAmount,
    required this.ratePerGram,
    required this.status,
    required this.createdAt,
  });

  factory MetalTransaction.fromJson(Map<String, dynamic> json) {
    return MetalTransaction(
      id: json['id']?.toString() ?? '',
      transactionType: json['transactionType'] ?? '',
      metalType: json['metalType'] ?? '',
      metalGrams: parseDouble(json['metalGrams']),
      finalAmount: parseDouble(json['finalAmount']),
      ratePerGram: parseDouble(json['ratePerGram']),
      status: json['status'] ?? '',
      createdAt: parseDateTime(json['createdAt']),
    );
  }
}

class CoinTransaction {
  final String id;
  final String metal;
  final String weight;
  final int quantity;
  final double finalAmount;
  final String status;
  final String paymentMode;
  final DateTime createdAt;

  CoinTransaction({
    required this.id,
    required this.metal,
    required this.weight,
    required this.quantity,
    required this.finalAmount,
    required this.status,
    required this.paymentMode,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id']?.toString() ?? '',
      metal: json['metal'] ?? '',
      weight: json['weight']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      finalAmount: parseDouble(json['final_amount'] ?? json['finalAmount']),
      status: json['status'] ?? '',
      paymentMode: json['payment_mode'] ?? json['paymentMode'] ?? '',
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
    );
  }
}

class GstConfig {
  final String id;
  final double rate;
  final String updatedBy;
  final bool isActive;
  final DateTime createdAt;
  final String? adminName;

  GstConfig({
    required this.id,
    required this.rate,
    required this.updatedBy,
    required this.isActive,
    required this.createdAt,
    this.adminName,
  });

  factory GstConfig.fromJson(Map<String, dynamic> json) {
    try {
      return GstConfig(
        id: json['id']?.toString() ?? '',
        rate: parseDouble(json['rate'] ?? json['ratePercent']),
        updatedBy: json['updatedBy']?.toString() ?? '',
        isActive: json['isActive'] ?? false,
        createdAt: parseDateTime(json['createdAt']),
        adminName: json['admin'] != null && json['admin'] is Map
            ? json['admin']['name']?.toString()
            : json['adminName']?.toString(),
      );
    } catch (e) {
      debugPrint("ERROR: GstConfig.fromJson failed: $e");
      // Fallback to avoid crash
      return GstConfig(
        id: '',
        rate: 0.0,
        updatedBy: '',
        isActive: false,
        createdAt: DateTime.now(),
      );
    }
  }
}
