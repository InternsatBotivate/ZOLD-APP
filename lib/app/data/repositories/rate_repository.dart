import '../../core/network/error_handler.dart';
import '../datasources/rate_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/rate_models.dart';

abstract class RateRepository {
  Future<BaseResponse<RateResponse>> getCurrentRates();
  Future<BaseResponse<LiveMarketResponse>> getLiveMarketRates();
  Future<BaseResponse<List<RateHistory>>> getRateHistory(
    String metal, {
    int? limit,
  });
  Future<BaseResponse<double>> getGst();
}

class RateRepositoryImpl implements RateRepository {
  final RateRemoteDataSource _remoteDataSource;
  RateRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<RateResponse>> getCurrentRates() async {
    try {
      return await _remoteDataSource.getCurrentRates();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<LiveMarketResponse>> getLiveMarketRates() async {
    try {
      return await _remoteDataSource.getLiveMarketRates();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<RateHistory>>> getRateHistory(
    String metal, {
    int? limit,
  }) async {
    try {
      return await _remoteDataSource.getRateHistory(metal, limit: limit);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<double>> getGst() async {
    try {
      return await _remoteDataSource.getGst();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
