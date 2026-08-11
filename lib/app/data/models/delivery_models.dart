import 'wallet_models.dart';

class DeliveryModel {
  final String id;
  final String metal;
  final int coinGrams;
  final int quantity;
  final String status;
  final String address;
  final DateTime createdAt;
  final DateTime? tentativeDate;
  final DateTime? completionDate;
  final DeliveryUser? user;
  final DeliveryPartner? partner;

  DeliveryModel({
    required this.id,
    required this.metal,
    required this.coinGrams,
    required this.quantity,
    required this.status,
    required this.address,
    required this.createdAt,
    this.tentativeDate,
    this.completionDate,
    this.user,
    this.partner,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id']?.toString() ?? '',
      metal: json['metal']?.toString() ?? 'GOLD',
      coinGrams:
          int.tryParse(
            json['coin_grams']?.toString() ??
                json['coinGrams']?.toString() ??
                '0',
          ) ??
          0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'PENDING',
      address: json['addressOfDelivery']?.toString() ?? '',
      createdAt: parseDateTime(json['createdAt']),
      tentativeDate: json['tentativeDate'] != null
          ? parseDateTime(json['tentativeDate'])
          : null,
      completionDate: json['completionDate'] != null
          ? parseDateTime(json['completionDate'])
          : null,
      user: json['user'] != null ? DeliveryUser.fromJson(json['user']) : null,
      partner: json['partner'] != null
          ? DeliveryPartner.fromJson(json['partner'])
          : null,
    );
  }
}

class DeliveryUser {
  final String name;
  final String phone;

  DeliveryUser({required this.name, required this.phone});

  factory DeliveryUser.fromJson(Map<String, dynamic> json) {
    return DeliveryUser(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class DeliveryPartner {
  final String ownerName;
  final String businessName;
  final String fullAddress;
  final String area;
  final String city;
  final String pincode;
  final String phone;

  DeliveryPartner({
    required this.ownerName,
    required this.businessName,
    required this.fullAddress,
    required this.area,
    required this.city,
    required this.pincode,
    required this.phone,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      ownerName: json['owner_name']?.toString() ?? '',
      businessName: json['business_name']?.toString() ?? '',
      fullAddress: json['full_address']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      phone: json['user'] != null
          ? json['user']['phone']?.toString() ?? ''
          : '',
    );
  }
}

class InitiateDeliveryRequest {
  final String metal;
  final int coinGrams;
  final int quantity;
  final String partnerId;
  final String address;

  InitiateDeliveryRequest({
    required this.metal,
    required this.coinGrams,
    required this.quantity,
    required this.partnerId,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'metal': metal,
    'coinGrams': coinGrams,
    'quantity': quantity,
    'partnerId': partnerId,
    'deliveryAddress': address,
  };
}
