import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/coin_models.dart';
import 'package:zold_gold/app/data/models/payment_models.dart';

abstract class CartRemoteDataSource {
  Future<BaseResponse<Cart>> getCart();
  Future<BaseResponse<Cart>> addCartItem(CartItem item);
  Future<BaseResponse<Cart>> removeCartItem(
    CartItem item, {
    bool removeAll = false,
  });
  Future<BaseResponse<CoinPurchaseSession>> initiateCheckout();
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId);
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request);
  Future<BaseResponse<void>> recordFailure(Map<String, dynamic> failureDetails);
  Future<BaseResponse<void>> cancelSession(String sessionId);
  Future<BaseResponse<CoinPurchaseSession?>> getActiveSession();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;
  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<Cart>> getCart() async {
    final response = await _dio.get('/coin-purchase-session/cart');
    return BaseResponse.fromJson(
      response.data,
      (json) => Cart.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<Cart>> addCartItem(CartItem item) async {
    final response = await _dio.post(
      '/coin-purchase-session/cart/item',
      data: item.toJson(),
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => Cart.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<Cart>> removeCartItem(
    CartItem item, {
    bool removeAll = false,
  }) async {
    final response = await _dio.delete(
      '/coin-purchase-session/cart/item',
      data: {...item.toJson(), 'removeAll': removeAll},
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => Cart.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<CoinPurchaseSession>> initiateCheckout() async {
    final response = await _dio.post('/coin-purchase-session/checkout');
    return BaseResponse.fromJson(
      response.data,
      (json) => CoinPurchaseSession.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId) async {
    final response = await _dio.post(
      '/coin-purchase-session/create-order',
      data: {'sessionId': sessionId, 'session_id': sessionId},
    );
    return BaseResponse.fromJson(response.data, (json) {
      if (json == null) throw Exception('Order creation returned empty data');
      return RazorpayOrder.fromJson(json as Map<String, dynamic>);
    });
  }

  @override
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request) async {
    final response = await _dio.post(
      '/coin-purchase-session/verify-payment',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> recordFailure(
    Map<String, dynamic> failureDetails,
  ) async {
    final response = await _dio.post(
      '/coin-purchase-session/record-failure',
      data: failureDetails,
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> cancelSession(String sessionId) async {
    final response = await _dio.post(
      '/coin-purchase-session/cancel',
      data: {'sessionId': sessionId},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<CoinPurchaseSession?>> getActiveSession() async {
    final response = await _dio.get('/coin-purchase-session/active');
    return BaseResponse.fromJson(response.data, (json) {
      if (json == null) return null;
      final map = json as Map<String, dynamic>;
      if (map['session'] == null) return null;
      return CoinPurchaseSession.fromJson(map);
    });
  }
}
