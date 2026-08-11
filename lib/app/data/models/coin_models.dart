import 'wallet_models.dart';
import 'cart_models.dart';

export 'cart_models.dart';

class CoinType {
  final double grams;
  final String name;
  final String description;
  final double basePrice;
  final double gst;
  final double totalPrice;
  final double ratePerGram;
  final bool isPopular;
  final String metal;

  CoinType({
    required this.grams,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.gst,
    required this.totalPrice,
    required this.ratePerGram,
    this.isPopular = false,
    this.metal = 'GOLD',
  });

  factory CoinType.fromJson(Map<String, dynamic> json) {
    return CoinType(
      grams: parseDouble(json['grams']),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: parseDouble(json['basePrice'] ?? json['base_price']),
      gst: parseDouble(json['gst']),
      totalPrice: parseDouble(json['totalPrice'] ?? json['total_amount']),
      ratePerGram: parseDouble(json['ratePerGram'] ?? json['rate_per_gram']),
      isPopular: json['isPopular'] ?? json['is_popular'] ?? false,
      metal: json['metal'] ?? 'GOLD',
    );
  }
}

class CoinInventory {
  final String id;
  final String userId;
  final String metal;
  final int coinGrams;
  final int quantity;

  CoinInventory({
    required this.id,
    required this.userId,
    required this.metal,
    required this.coinGrams,
    required this.quantity,
  });

  factory CoinInventory.fromJson(Map<String, dynamic> json) {
    return CoinInventory(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      metal: json['metal'] ?? 'GOLD',
      coinGrams: parseInt(json['coinGrams'] ?? json['coin_grams']),
      quantity: parseInt(json['quantity']),
    );
  }
}

class CoinTransaction {
  final String id;
  final String type;
  final String metal;
  final int weight;
  final int quantity;
  final double ratePerGram;
  final double finalAmount;
  final String status;
  final DateTime createdAt;

  CoinTransaction({
    required this.id,
    required this.type,
    required this.metal,
    required this.weight,
    required this.quantity,
    required this.ratePerGram,
    required this.finalAmount,
    required this.status,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      metal: json['metal'] ?? 'GOLD',
      weight: parseInt(json['weight']),
      quantity: parseInt(json['quantity']),
      ratePerGram: parseDouble(json['rate_per_gram'] ?? json['ratePerGram']),
      finalAmount: parseDouble(json['final_amount'] ?? json['finalAmount']),
      status: json['status'] ?? '',
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
    );
  }
}

class BuyCoinRequest {
  final int coinGrams;
  final int quantity;
  final String metal;

  BuyCoinRequest({
    required this.coinGrams,
    required this.quantity,
    this.metal = 'GOLD',
  });

  Map<String, dynamic> toJson() => {
    'coinGrams': coinGrams,
    'quantity': quantity,
    'metal': metal,
  };
}

class CoinPurchaseSession {
  final String id;
  final List<CartItem> items;
  final double totalBasePrice;
  final double totalGst;
  final double totalAmount;
  final String status;
  final DateTime expiresAt;

  CoinPurchaseSession({
    required this.id,
    required this.items,
    required this.totalBasePrice,
    required this.totalGst,
    required this.totalAmount,
    required this.status,
    required this.expiresAt,
  });

  factory CoinPurchaseSession.fromJson(Map<String, dynamic> json) {
    final sessionData = (json['session'] as Map<String, dynamic>?) ?? {};
    final itemsList = (json['lockedCartItems'] as List?) ?? [];

    final items = itemsList
        .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .toList();

    double subtotal = 0;
    for (var item in items) {
      subtotal += item.basePrice;
    }

    final gstRate = parseDouble(
      sessionData['gstRate'] ?? sessionData['gst_rate'] ?? 3.0,
    );
    final totalGst = (subtotal * gstRate) / 100;

    return CoinPurchaseSession(
      id: sessionData['id']?.toString() ?? '',
      items: items,
      totalBasePrice: subtotal,
      totalGst: totalGst,
      totalAmount: subtotal + totalGst,
      status: sessionData['status']?.toString() ?? 'ACTIVE',
      expiresAt: parseDateTime(
        sessionData['expires_at'] ?? sessionData['expiresAt'],
      ),
    );
  }
}
