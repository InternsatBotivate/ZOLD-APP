import '../../core/network/error_handler.dart';
import '../datasources/coin_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/coin_models.dart';

abstract class CoinRepository {
  Future<BaseResponse<List<CoinType>>> getCoinTypes();
  Future<BaseResponse<List<CoinInventory>>> getUserInventory();
  Future<BaseResponse<void>> buyCoin(BuyCoinRequest request);
  Future<BaseResponse<void>> convertToCoin(BuyCoinRequest request);
  Future<BaseResponse<List<CoinTransaction>>> getTransactionHistory({
    int limit = 20,
  });
}

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource _remoteDataSource;
  CoinRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<CoinType>>> getCoinTypes() async {
    try {
      return await _remoteDataSource.getCoinTypes();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<CoinInventory>>> getUserInventory() async {
    try {
      return await _remoteDataSource.getUserInventory();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> buyCoin(BuyCoinRequest request) async {
    try {
      return await _remoteDataSource.buyCoin(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> convertToCoin(BuyCoinRequest request) async {
    try {
      return await _remoteDataSource.convertToCoin(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<CoinTransaction>>> getTransactionHistory({
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getTransactionHistory(limit: limit);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
