import '../datasources/admin_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/auth_models.dart';
import '../../core/network/error_handler.dart';

import '../models/admin_models.dart';

abstract class AdminRepository {
  Future<BaseResponse<List<User>>> getAllUsers();
  Future<BaseResponse<UserTransactionHistory>> getUserTransactionHistory(
    String userId,
  );
  Future<BaseResponse<void>> updateMetalPrices(Map<String, dynamic> prices);
  Future<BaseResponse<double>> getCurrentGst();
  Future<BaseResponse<void>> updateGstRate(double rate);
  Future<BaseResponse<List<GstConfig>>> getGstHistory();
  Future<BaseResponse<List<SellRequest>>> getSellRequests();
  Future<BaseResponse<void>> approveSellRequest(String id);
  Future<BaseResponse<void>> rejectSellRequest(String id, String remark);
}

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;
  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<User>>> getAllUsers() async {
    try {
      return await _remoteDataSource.getAllUsers();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<UserTransactionHistory>> getUserTransactionHistory(
    String userId,
  ) async {
    try {
      return await _remoteDataSource.getUserTransactionHistory(userId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateMetalPrices(
    Map<String, dynamic> prices,
  ) async {
    try {
      return await _remoteDataSource.updateMetalPrices(prices);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateGstRate(double rate) async {
    try {
      return await _remoteDataSource.updateGstRate(rate);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<double>> getCurrentGst() async {
    try {
      return await _remoteDataSource.getCurrentGst();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<GstConfig>>> getGstHistory() async {
    try {
      return await _remoteDataSource.getGstHistory();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<SellRequest>>> getSellRequests() async {
    try {
      return await _remoteDataSource.getSellRequests();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> approveSellRequest(String id) async {
    try {
      return await _remoteDataSource.approveSellRequest(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> rejectSellRequest(String id, String remark) async {
    try {
      return await _remoteDataSource.rejectSellRequest(id, remark);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
