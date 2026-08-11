import '../../core/network/error_handler.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/wallet_models.dart';

abstract class WalletRepository {
  Future<BaseResponse<WalletBalance>> getBalance();
  Future<BaseResponse<List<Transaction>>> getTransactions();
  Future<BaseResponse<WalletStats>> getStats();
}

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<WalletBalance>> getBalance() async {
    try {
      return await _remoteDataSource.getBalance();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<Transaction>>> getTransactions() async {
    try {
      return await _remoteDataSource.getTransactions();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<WalletStats>> getStats() async {
    try {
      return await _remoteDataSource.getStats();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
