import 'wallet_models.dart';

class Sip {
  final String id;
  final String sipId;
  final String metal;
  final double investmentAmount;
  final double totalInvestedAmount;
  final int dayOfMonth;
  final DateTime createdAt;
  final String name;
  final String type;
  final String status;

  Sip({
    required this.id,
    required this.sipId,
    required this.metal,
    required this.investmentAmount,
    required this.totalInvestedAmount,
    required this.dayOfMonth,
    required this.createdAt,
    required this.name,
    required this.type,
    this.status = 'ACTIVE',
  });

  factory Sip.fromJson(Map<String, dynamic> json) {
    final sipData = json['sip'] as Map<String, dynamic>?;
    return Sip(
      id: json['id']?.toString() ?? '',
      sipId: json['sip_id']?.toString() ?? json['sipId']?.toString() ?? '',
      metal: json['metal']?.toString() ?? 'GOLD',
      investmentAmount: parseDouble(
        json['investment_amount'] ?? json['investmentAmount'],
      ),
      totalInvestedAmount: parseDouble(
        json['total_invested_amount'] ?? json['totalInvestedAmount'],
      ),
      dayOfMonth: parseInt(json['day_of_month'] ?? json['dayOfMonth']),
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
      name: sipData?['name']?.toString() ?? 'SIP Plan',
      type: sipData?['type']?.toString() ?? 'REGULAR',
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }
}

class SipPlan {
  final String id;
  final String name;
  final String type;
  final String metal;
  final double minInvestment;
  final DateTime? createdAt;

  SipPlan({
    required this.id,
    required this.name,
    required this.type,
    required this.metal,
    required this.minInvestment,
    this.createdAt,
  });

  factory SipPlan.fromJson(Map<String, dynamic> json) {
    return SipPlan(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'REGULAR',
      metal: json['metal']?.toString() ?? 'GOLD',
      minInvestment: parseDouble(
        json['min_investment'] ?? json['minInvestment'],
      ),
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? parseDateTime(json['created_at'] ?? json['createdAt'])
          : null,
    );
  }
}

class CreateSipRequest {
  final String name;
  final String type;
  final String metal;
  final double minInvestment;

  CreateSipRequest({
    required this.name,
    required this.type,
    required this.metal,
    required this.minInvestment,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'metal': metal,
    'minInvestment': minInvestment,
  };
}

class SipOrderRequest {
  final String sipId;
  final String name;
  final String metal;
  final double amount;
  final int dayOfMonth;

  SipOrderRequest({
    required this.sipId,
    required this.name,
    required this.metal,
    required this.amount,
    required this.dayOfMonth,
  });

  Map<String, dynamic> toJson() => {
    'sipId': sipId,
    'name': name,
    'metal': metal,
    'amount': amount,
    'day_of_month': dayOfMonth,
  };
}

class SipOrderResponse {
  final String orderId;
  final int amount;
  final String currency;
  final String keyId;
  final Map<String, dynamic> sipDetails;
  final Map<String, dynamic> orderDetails;

  SipOrderResponse({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
    required this.sipDetails,
    required this.orderDetails,
  });

  factory SipOrderResponse.fromJson(Map<String, dynamic> json) {
    return SipOrderResponse(
      orderId: json['orderId'] ?? json['order_id']?.toString() ?? '',
      amount: parseInt(json['amount']),
      currency: json['currency']?.toString() ?? 'INR',
      keyId: json['keyId'] ?? json['key_id']?.toString() ?? '',
      sipDetails: json['sipDetails'] ?? json['sip_details'] ?? {},
      orderDetails: json['orderDetails'] ?? json['order_details'] ?? {},
    );
  }
}

class TopupOrderResponse {
  final String orderId;
  final int amount;
  final String currency;
  final String keyId;
  final Map<String, dynamic> topupDetails;
  final Map<String, dynamic> orderDetails;

  TopupOrderResponse({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
    required this.topupDetails,
    required this.orderDetails,
  });

  factory TopupOrderResponse.fromJson(Map<String, dynamic> json) {
    return TopupOrderResponse(
      orderId: json['orderId'] ?? json['order_id']?.toString() ?? '',
      amount: parseInt(json['amount']),
      currency: json['currency']?.toString() ?? 'INR',
      keyId: json['keyId'] ?? json['key_id']?.toString() ?? '',
      topupDetails: json['topupDetails'] ?? json['topup_details'] ?? {},
      orderDetails: json['orderDetails'] ?? json['order_details'] ?? {},
    );
  }
}

class SipVerifyRequest {
  final String sipId;
  final String orderId;
  final String paymentId;
  final String signature;
  final Map<String, dynamic> sipDetails;
  final Map<String, dynamic> orderDetails;

  SipVerifyRequest({
    required this.sipId,
    required this.orderId,
    required this.paymentId,
    required this.signature,
    required this.sipDetails,
    required this.orderDetails,
  });

  Map<String, dynamic> toJson() => {
    'sipId': sipId,
    'orderId': orderId,
    'paymentId': paymentId,
    'signature': signature,
    'sipDetails': sipDetails,
    'orderDetails': orderDetails,
  };
}

class TopupVerifyRequest {
  final String sipId;
  final String orderId;
  final String paymentId;
  final String signature;
  final Map<String, dynamic> topupDetails;
  final Map<String, dynamic> orderDetails;

  TopupVerifyRequest({
    required this.sipId,
    required this.orderId,
    required this.paymentId,
    required this.signature,
    required this.topupDetails,
    required this.orderDetails,
  });

  Map<String, dynamic> toJson() => {
    'sipId': sipId,
    'orderId': orderId,
    'paymentId': paymentId,
    'signature': signature,
    'topupDetails': topupDetails,
    'orderDetails': orderDetails,
  };
}

class TopupOrderRequest {
  final String sipId;
  final String metal;
  final double amount;

  TopupOrderRequest({
    required this.sipId,
    required this.metal,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'sipId': sipId,
    'metal': metal,
    'amount': amount,
  };
}

class ModifySipRequest {
  final String sipId;
  final double investmentAmount;
  final int dayOfMonth;

  ModifySipRequest({
    required this.sipId,
    required this.investmentAmount,
    required this.dayOfMonth,
  });

  Map<String, dynamic> toJson() => {
    'sipId': sipId,
    'investment_amount': investmentAmount,
    'day_of_month': dayOfMonth,
  };
}
