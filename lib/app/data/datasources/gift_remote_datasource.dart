import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/gift_models.dart';
import '../models/auth_models.dart';

abstract class GiftRemoteDataSource {
  Future<BaseResponse<User>> lookupUser(String phone);
  Future<BaseResponse<void>> sendGift(GiftSendRequest request);
}

class GiftRemoteDataSourceImpl implements GiftRemoteDataSource {
  final Dio _dio;
  GiftRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<User>> lookupUser(String phone) async {
    final response = await _dio.get(
      '/metal-gifts/lookup',
      queryParameters: {'phone': phone},
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> sendGift(GiftSendRequest request) async {
    final response = await _dio.post(
      '/metal-gifts/send',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
