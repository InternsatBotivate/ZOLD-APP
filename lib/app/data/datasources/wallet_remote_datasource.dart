import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/wallet_models.dart';

abstract class WalletRemoteDataSource {
  Future<BaseResponse<WalletBalance>> getBalance();
  Future<BaseResponse<List<Transaction>>> getTransactions();
  Future<BaseResponse<WalletStats>> getStats();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio _dio;
  WalletRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<WalletBalance>> getBalance() async {
    final response = await _dio.get('/wallet/balance');
    return BaseResponse.fromJson(
      response.data,
      (json) => WalletBalance.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<List<Transaction>>> getTransactions() async {
    final response = await _dio.get('/wallet/transactions');
    final data = response.data['data'] ?? response.data;
    final metalTransactions = (data['metalTransactions'] as List?) ?? [];
    final coinTransactions = (data['coinTransactions'] as List?) ?? [];

    final List<Transaction> transactions = [
      ...metalTransactions.map(
        (e) => Transaction.fromJson({...e, 'kind': 'METAL'}),
      ),
      ...coinTransactions.map(
        (e) => Transaction.fromJson({...e, 'kind': 'COIN'}),
      ),
    ];

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return BaseResponse(
      success: true,
      message: 'Transactions fetched',
      data: transactions,
    );
  }

  @override
  Future<BaseResponse<WalletStats>> getStats() async {
    final response = await _dio.get('/wallet/stats');
    return BaseResponse.fromJson(
      response.data,
      (json) => WalletStats.fromJson(json as Map<String, dynamic>),
    );
  }
}
