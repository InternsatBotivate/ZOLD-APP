import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/sip_models.dart';

abstract class SipRemoteDataSource {
  Future<BaseResponse<Sip>> createSip(CreateSipRequest request);
  Future<BaseResponse<List<Sip>>> getMySips();
  Future<BaseResponse<List<SipPlan>>> getAllSips();
  Future<BaseResponse<SipOrderResponse>> createSipOrder(
    SipOrderRequest request,
  );
  Future<BaseResponse<void>> verifySip(SipVerifyRequest request);
  Future<BaseResponse<TopupOrderResponse>> createTopupOrder(
    TopupOrderRequest request,
  );
  Future<BaseResponse<void>> verifyTopup(TopupVerifyRequest request);
  Future<BaseResponse<void>> modifySip(ModifySipRequest request);
}

class SipRemoteDataSourceImpl implements SipRemoteDataSource {
  final Dio _dio;
  SipRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<Sip>> createSip(CreateSipRequest request) async {
    final response = await _dio.post('/sip/create', data: request.toJson());
    return BaseResponse.fromJson(
      response.data,
      (json) => Sip.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<List<Sip>>> getMySips() async {
    final response = await _dio.get('/sip/my-sips');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => Sip.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<List<SipPlan>>> getAllSips() async {
    final response = await _dio.get('/sip/all');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => SipPlan.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<SipOrderResponse>> createSipOrder(
    SipOrderRequest request,
  ) async {
    final response = await _dio.post('/sip/order', data: request.toJson());
    return BaseResponse.fromJson(
      response.data,
      (json) => SipOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> verifySip(SipVerifyRequest request) async {
    final response = await _dio.post('/sip/verify', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<TopupOrderResponse>> createTopupOrder(
    TopupOrderRequest request,
  ) async {
    final response = await _dio.post(
      '/sip/topup/order',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => TopupOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> verifyTopup(TopupVerifyRequest request) async {
    final response = await _dio.post(
      '/sip/topup/verify',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> modifySip(ModifySipRequest request) async {
    final response = await _dio.patch('/sip/modify', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
