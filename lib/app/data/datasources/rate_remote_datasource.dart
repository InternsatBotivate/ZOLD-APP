import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/rate_models.dart';
import '../models/wallet_models.dart';

abstract class RateRemoteDataSource {
  Future<BaseResponse<RateResponse>> getCurrentRates();
  Future<BaseResponse<LiveMarketResponse>> getLiveMarketRates();
  Future<BaseResponse<List<RateHistory>>> getRateHistory(
    String metal, {
    int? limit,
  });
  Future<BaseResponse<double>> getGst();
}

class RateRemoteDataSourceImpl implements RateRemoteDataSource {
  final Dio _dio;
  RateRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<RateResponse>> getCurrentRates() async {
    final response = await _dio.get('/rates/current');
    return BaseResponse.fromJson(
      response.data,
      (json) => RateResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<LiveMarketResponse>> getLiveMarketRates() async {
    final response = await _dio.get('/rates/live-market');
    return BaseResponse.fromJson(
      response.data,
      (json) => LiveMarketResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<List<RateHistory>>> getRateHistory(
    String metal, {
    int? limit,
  }) async {
    final response = await _dio.get(
      '/rates/history',
      queryParameters: {'metal': metal, if (limit != null) 'limit': limit},
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => RateHistory.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<double>> getGst() async {
    final response = await _dio.get('/meta/gst');
    return BaseResponse.fromJson(
      response.data,
      (json) => parseDouble((json as Map<String, dynamic>)['rate']),
    );
  }
}
