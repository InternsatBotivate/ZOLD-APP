import 'wallet_models.dart';

class CartItem {
  final double weight;
  final String metal;
  final int quantity;
  final double basePrice;
  final double gst;

  CartItem({
    required this.weight,
    required this.metal,
    required this.quantity,
    this.basePrice = 0.0,
    this.gst = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          weight == other.weight &&
          metal == other.metal &&
          quantity == other.quantity &&
          basePrice == other.basePrice &&
          gst == other.gst;

  @override
  int get hashCode =>
      weight.hashCode ^
      metal.hashCode ^
      quantity.hashCode ^
      basePrice.hashCode ^
      gst.hashCode;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      weight: parseDouble(json['weight']),
      metal: json['metal'] ?? 'GOLD',
      quantity: parseInt(json['quantity'] ?? 1),
      basePrice: parseDouble(
        json['basePrice'] ?? json['item_price'] ?? json['base_price'],
      ),
      gst: parseDouble(json['gst']),
    );
  }

  Map<String, dynamic> toJson() => {
    'weight': weight.toInt(),
    'metal': metal,
    'quantity': quantity,
  };
}

class Cart {
  final List<CartItem> items;
  final double totalAmount;

  Cart({required this.items, required this.totalAmount});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items:
          (json['items'] as List?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: parseDouble(json['totalAmount'] ?? json['total_amount']),
    );
  }
}
