import '../../core/utils/app_date_utils.dart';

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime parseDateTime(dynamic value) {
  return AppDateUtils.parse(value);
}

class WalletBalance {
  final double goldGrams;
  final double silverGrams;
  final double rupeeBalance;
  final double goldCoinGrams;
  final double silverCoinGrams;
  final double goldValuation;
  final double silverValuation;
  final double goldCoinValuation;
  final double silverCoinValuation;
  final double totalValuation;
  final double currentGoldRate;
  final double currentSilverRate;

  WalletBalance({
    required this.goldGrams,
    required this.silverGrams,
    required this.rupeeBalance,
    required this.goldCoinGrams,
    required this.silverCoinGrams,
    required this.goldValuation,
    required this.silverValuation,
    required this.goldCoinValuation,
    required this.silverCoinValuation,
    required this.totalValuation,
    required this.currentGoldRate,
    required this.currentSilverRate,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      goldGrams: parseDouble(json['goldGrams']),
      silverGrams: parseDouble(json['silverGrams']),
      rupeeBalance: parseDouble(json['rupeeBalance']),
      goldCoinGrams: parseDouble(json['goldCoinGrams']),
      silverCoinGrams: parseDouble(json['silverCoinGrams']),
      goldValuation: parseDouble(json['goldValuation']),
      silverValuation: parseDouble(json['silverValuation']),
      goldCoinValuation: parseDouble(json['goldCoinValuation']),
      silverCoinValuation: parseDouble(json['silverCoinValuation']),
      totalValuation: parseDouble(json['totalValuation']),
      currentGoldRate: parseDouble(json['currentGoldRate']),
      currentSilverRate: parseDouble(json['currentSilverRate']),
    );
  }
}

class Transaction {
  final String id;
  final String type;
  final String kind; // METAL or COIN
  final String metal; // GOLD or SILVER
  final double grams;
  final double? coinGrams;
  final int? quantity;
  final double finalAmount;
  final String status;
  final DateTime createdAt;
  final String paymentMode;

  Transaction({
    required this.id,
    required this.type,
    required this.kind,
    required this.metal,
    required this.grams,
    this.coinGrams,
    this.quantity,
    required this.finalAmount,
    required this.status,
    required this.createdAt,
    required this.paymentMode,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Determine kind based on presence of coinGrams/quantity or a explicit field if available
    // Next.js normalization logic:
    // Metal: transactionType as type, kind: METAL, metalType as metal, metalGrams as grams, finalAmount, status, createdAt, paymentMode
    // Coin: type: BUY, kind: COIN, metal: metal, grams: weight * quantity, coinGrams: weight, quantity, final_amount, status, created_at, payment_mode

    final kind =
        json['kind'] ?? (json['metalGrams'] != null ? 'METAL' : 'COIN');

    return Transaction(
      id: json['id']?.toString() ?? '',
      type: json['transactionType'] ?? json['type'] ?? 'BUY',
      kind: kind,
      metal: json['metalType'] ?? json['metal'] ?? 'GOLD',
      grams: json['metalGrams'] != null
          ? parseDouble(json['metalGrams'])
          : parseDouble(json['weight']) * parseInt(json['quantity']),
      coinGrams: json['weight'] != null ? parseDouble(json['weight']) : null,
      quantity: json['quantity'] != null ? parseInt(json['quantity']) : null,
      finalAmount: parseDouble(json['finalAmount'] ?? json['final_amount']),
      status: json['status']?.toString() ?? 'PENDING',
      createdAt: parseDateTime(json['createdAt'] ?? json['created_at']),
      paymentMode: json['paymentMode'] ?? json['payment_mode'] ?? 'WALLET',
    );
  }
}

class WalletStats {
  final double totalBought;
  final double totalSold;
  final double avgBuyPrice;
  final double profitLoss;
  final double profitLossPercent;

  WalletStats({
    required this.totalBought,
    required this.totalSold,
    required this.avgBuyPrice,
    required this.profitLoss,
    required this.profitLossPercent,
  });

  factory WalletStats.fromJson(Map<String, dynamic> json) {
    return WalletStats(
      totalBought: parseDouble(json['totalBought']),
      totalSold: parseDouble(json['totalSold']),
      avgBuyPrice: parseDouble(json['avgBuyPrice']),
      profitLoss: parseDouble(json['profitLoss']),
      profitLossPercent: parseDouble(json['profitLossPercent']),
    );
  }
}
