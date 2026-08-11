import 'wallet_models.dart';

class MetalGift {
  final String id;
  final String senderId;
  final String recipientId;
  final String metalType;
  final String giftType;
  final double? metalGrams;
  final int? coinGrams;
  final int? coinQuantity;
  final String? message;
  final String? occasion;
  final String status;
  final DateTime createdAt;

  MetalGift({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.metalType,
    required this.giftType,
    this.metalGrams,
    this.coinGrams,
    this.coinQuantity,
    this.message,
    this.occasion,
    required this.status,
    required this.createdAt,
  });

  factory MetalGift.fromJson(Map<String, dynamic> json) {
    return MetalGift(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId'] ?? json['sender_id'] ?? '',
      recipientId: json['recipientId'] ?? json['recipient_id'] ?? '',
      metalType: json['metalType'] ?? json['metal_type'] ?? '',
      giftType: json['giftType'] ?? json['gift_type'] ?? 'VIRTUAL',
      metalGrams: json['metalGrams'] != null || json['metal_grams'] != null
          ? parseDouble(json['metalGrams'] ?? json['metal_grams'])
          : null,
      coinGrams: json['coinGrams'] != null || json['coin_grams'] != null
          ? parseInt(json['coinGrams'] ?? json['coin_grams'])
          : null,
      coinQuantity:
          json['coinQuantity'] != null || json['coin_quantity'] != null
          ? parseInt(json['coinQuantity'] ?? json['coin_quantity'])
          : null,
      message: json['message'],
      occasion: json['occasion'],
      status: json['status'] ?? 'PENDING',
      createdAt: parseDateTime(json['createdAt'] ?? json['created_at']),
    );
  }
}

class GiftSendRequest {
  final String recipientId;
  final String metalType;
  final String giftType;
  final double? metalGrams;
  final int? coinGrams;
  final int? coinQuantity;
  final String? message;
  final String? occasion;

  GiftSendRequest({
    required this.recipientId,
    required this.metalType,
    required this.giftType,
    this.metalGrams,
    this.coinGrams,
    this.coinQuantity,
    this.message,
    this.occasion,
  });

  Map<String, dynamic> toJson() => {
    'recipientId': recipientId,
    'metalType': metalType,
    'giftType': giftType,
    if (metalGrams != null) 'metalGrams': metalGrams,
    if (coinGrams != null) 'coinGrams': coinGrams,
    if (coinQuantity != null) 'coinQuantity': coinQuantity,
    if (message != null) 'message': message,
    if (occasion != null) 'occasion': occasion,
  };
}
