import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/purchase_models.dart';
import 'package:zold_gold/app/data/models/payment_models.dart';

abstract class PurchaseRemoteDataSource {
  Future<BaseResponse<MetalPurchaseSession>> initiatePurchase(
    InitiatePurchaseRequest request,
  );
  Future<BaseResponse<MetalPurchaseSession>> getActiveSession();
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId);
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request);
  Future<BaseResponse<void>> executeSell(String sessionId);
  Future<BaseResponse<void>> recordFailure(Map<String, dynamic> failureDetails);
  Future<BaseResponse<void>> cancelSession(String sessionId);
}

class PurchaseRemoteDataSourceImpl implements PurchaseRemoteDataSource {
  final Dio _dio;
  PurchaseRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<MetalPurchaseSession>> initiatePurchase(
    InitiatePurchaseRequest request,
  ) async {
    final response = await _dio.post(
      '/metal-purchase-session/initiate',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => MetalPurchaseSession.fromJson(
        (json as Map<String, dynamic>)['session'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<BaseResponse<MetalPurchaseSession>> getActiveSession() async {
    final response = await _dio.get('/metal-purchase-session/active');
    return BaseResponse.fromJson(response.data, (json) {
      if (json == null) return null;
      final data = json as Map<String, dynamic>;
      if (data['session'] == null) return null;
      return MetalPurchaseSession.fromJson(
        data['session'] as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId) async {
    final response = await _dio.post(
      '/metal-purchase-session/create-order',
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
      '/metal-purchase-session/verify-payment',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> executeSell(String sessionId) async {
    final response = await _dio.post(
      '/metal-purchase-session/checkout',
      data: {'sessionId': sessionId},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> recordFailure(
    Map<String, dynamic> failureDetails,
  ) async {
    final response = await _dio.post(
      '/metal-purchase-session/payment-failed',
      data: failureDetails,
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> cancelSession(String sessionId) async {
    final response = await _dio.post(
      '/metal-purchase-session/cancel',
      data: {'sessionId': sessionId},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
