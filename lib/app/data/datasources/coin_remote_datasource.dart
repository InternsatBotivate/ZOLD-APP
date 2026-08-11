import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/coin_models.dart';

abstract class CoinRemoteDataSource {
  Future<BaseResponse<List<CoinType>>> getCoinTypes();
  Future<BaseResponse<List<CoinInventory>>> getUserInventory();
  Future<BaseResponse<void>> buyCoin(BuyCoinRequest request);
  Future<BaseResponse<void>> convertToCoin(BuyCoinRequest request);
  Future<BaseResponse<List<CoinTransaction>>> getTransactionHistory({
    int limit = 20,
  });
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final Dio _dio;
  CoinRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<List<CoinType>>> getCoinTypes() async {
    final response = await _dio.get('/coins/types');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => CoinType.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<List<CoinInventory>>> getUserInventory() async {
    final response = await _dio.get('/coins/inventory');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => CoinInventory.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<void>> buyCoin(BuyCoinRequest request) async {
    final response = await _dio.post('/coins/buy', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> convertToCoin(BuyCoinRequest request) async {
    final response = await _dio.post('/coins/convert', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<List<CoinTransaction>>> getTransactionHistory({
    int limit = 20,
  }) async {
    final response = await _dio.get(
      '/coins/transactions',
      queryParameters: {'limit': limit},
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => CoinTransaction.fromJson(e)).toList(),
    );
  }
}
