import 'wallet_models.dart';

class Rate {
  final double buyRate;
  final double sellRate;
  final String metal;

  Rate({required this.buyRate, required this.sellRate, required this.metal});

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      buyRate: parseDouble(json['buyRate'] ?? json['buy_rate']),
      sellRate: parseDouble(json['sellRate'] ?? json['sell_rate']),
      metal: json['metal'] ?? '',
    );
  }

  static Rate empty(String metal) =>
      Rate(buyRate: 0, sellRate: 0, metal: metal);
}

class RateResponse {
  final Rate gold;
  final Rate silver;

  RateResponse({required this.gold, required this.silver});

  factory RateResponse.fromJson(Map<String, dynamic> json) {
    return RateResponse(
      gold: json['goldRate'] != null
          ? Rate.fromJson(json['goldRate'] as Map<String, dynamic>)
          : Rate.empty('GOLD'),
      silver: json['silverRate'] != null
          ? Rate.fromJson(json['silverRate'] as Map<String, dynamic>)
          : Rate.empty('SILVER'),
    );
  }
}

class RateHistory {
  final String id;
  final String metal;
  final double buyRate;
  final double sellRate;
  final bool isActive;
  final DateTime createdAt;

  RateHistory({
    required this.id,
    required this.metal,
    required this.buyRate,
    required this.sellRate,
    required this.isActive,
    required this.createdAt,
  });

  factory RateHistory.fromJson(Map<String, dynamic> json) {
    return RateHistory(
      id: json['id']?.toString() ?? '',
      metal: json['metal'] ?? '',
      buyRate: parseDouble(json['buyRate'] ?? json['buy_rate']),
      sellRate: parseDouble(json['sellRate'] ?? json['sell_rate']),
      isActive: json['isActive'] ?? json['is_active'] ?? false,
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.parse((json['createdAt'] ?? json['created_at']) as String)
          : DateTime.now(),
    );
  }
}

class LiveRate {
  final double buyRate;
  final double sellRate;
  final String? source;

  LiveRate({required this.buyRate, required this.sellRate, this.source});

  factory LiveRate.fromJson(Map<String, dynamic> json) {
    return LiveRate(
      buyRate: parseDouble(json['buyRate'] ?? json['buy_rate']),
      sellRate: parseDouble(json['sellRate'] ?? json['sell_rate']),
      source: json['source'],
    );
  }
}

class LiveMarketResponse {
  final LiveRate gold;
  final LiveRate silver;

  LiveMarketResponse({required this.gold, required this.silver});

  factory LiveMarketResponse.fromJson(Map<String, dynamic> json) {
    return LiveMarketResponse(
      gold: LiveRate.fromJson(json['gold'] as Map<String, dynamic>),
      silver: LiveRate.fromJson(json['silver'] as Map<String, dynamic>),
    );
  }
}
