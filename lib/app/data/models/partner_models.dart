import 'wallet_models.dart';

class Partner {
  final String id;
  final String name;
  final String businessName;
  final String ownerName;
  final String fullAddress;
  final String city;
  final String area;
  final String pincode;
  final String? timings;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final double rating;
  final int reviews;
  final List<String> services;
  final String servicesOffers;
  final List<String> offers;
  final String? distance;
  final String? email;
  final String? username;
  final String? userId;

  Partner({
    required this.id,
    required this.name,
    required this.businessName,
    required this.ownerName,
    required this.fullAddress,
    required this.city,
    required this.area,
    required this.pincode,
    required this.servicesOffers,
    this.timings,
    this.latitude,
    this.longitude,
    this.phone,
    this.rating = 4.5,
    this.reviews = 0,
    this.services = const [],
    this.offers = const [],
    this.distance,
    this.email,
    this.username,
    this.userId,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    var servicesList = <String>[];
    if (json['services'] != null && json['services'] is List) {
      servicesList = List<String>.from(
        json['services'],
      ).map((e) => e.toLowerCase()).toList();
    } else if (json['services_offers'] != null) {
      servicesList = [json['services_offers'].toString().toLowerCase()];
    }

    final String bName =
        json['name'] ?? json['businessName'] ?? json['business_name'] ?? '';

    return Partner(
      id: json['id']?.toString() ?? '',
      name: bName,
      businessName: bName,
      ownerName: json['ownerName'] ?? json['owner_name'] ?? '',
      fullAddress: json['fullAddress'] ?? json['full_address'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      pincode: json['pincode']?.toString() ?? '',
      servicesOffers: json['services_offers']?.toString() ?? 'PICKUP',
      timings: json['timings']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      phone: json['phone']?.toString() ?? json['business_phone']?.toString(),
      rating: parseDouble(json['rating'] ?? json['business_rating']) == 0.0
          ? 4.5
          : parseDouble(json['rating'] ?? json['business_rating']),
      reviews: parseInt(json['reviews'] ?? json['business_reviews']),
      services: servicesList,
      offers: json['offers'] != null ? List<String>.from(json['offers']) : [],
      distance: json['distance']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      userId: json['userId']?.toString(),
    );
  }
}
