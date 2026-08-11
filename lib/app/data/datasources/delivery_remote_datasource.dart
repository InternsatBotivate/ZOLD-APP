import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/delivery_models.dart';

abstract class DeliveryRemoteDataSource {
  Future<BaseResponse<List<DeliveryModel>>> getDeliveries();
  Future<BaseResponse<List<DeliveryModel>>> getAssignedDeliveries();
  Future<BaseResponse<void>> initiateDelivery(InitiateDeliveryRequest request);
  Future<BaseResponse<void>> cancelDelivery(String deliveryId);
  Future<BaseResponse<void>> updateDeliveryStatus(
    String deliveryId,
    String tentativeDate,
  );
  Future<BaseResponse<void>> completeDelivery(String deliveryId);
  Future<BaseResponse<void>> verifyDelivery(String deliveryId, int otp);
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final Dio _dio;
  DeliveryRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<List<DeliveryModel>>> getDeliveries() async {
    final response = await _dio.get('/delivery');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => DeliveryModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<List<DeliveryModel>>> getAssignedDeliveries() async {
    final response = await _dio.get('/delivery/assigned');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => DeliveryModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<void>> initiateDelivery(
    InitiateDeliveryRequest request,
  ) async {
    final response = await _dio.post('/delivery', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> cancelDelivery(String deliveryId) async {
    final response = await _dio.post('/delivery/$deliveryId');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> updateDeliveryStatus(
    String deliveryId,
    String tentativeDate,
  ) async {
    final response = await _dio.patch(
      '/delivery/assigned/$deliveryId',
      data: {'tentativeDate': tentativeDate},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> completeDelivery(String deliveryId) async {
    final response = await _dio.post('/delivery/complete/$deliveryId');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> verifyDelivery(String deliveryId, int otp) async {
    final response = await _dio.post(
      '/delivery/complete-verify/$deliveryId',
      data: {'enteredOtp': otp},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
