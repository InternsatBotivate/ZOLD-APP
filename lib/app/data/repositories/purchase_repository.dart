import '../../core/network/error_handler.dart';
import '../datasources/purchase_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/purchase_models.dart';
import 'package:zold_gold/app/data/models/payment_models.dart';

abstract class PurchaseRepository {
  Future<BaseResponse<MetalPurchaseSession>> initiatePurchase(
    InitiatePurchaseRequest request,
  );
  Future<BaseResponse<MetalPurchaseSession>> getActiveSession();
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId);
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request);
  Future<BaseResponse<void>> executeSell(String sessionId);
  Future<BaseResponse<void>> recordFailure(Map<String, dynamic> failureDetails);
  Future<BaseResponse<void>> cancelSession(String sessionId);
}

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource _remoteDataSource;
  PurchaseRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<MetalPurchaseSession>> initiatePurchase(
    InitiatePurchaseRequest request,
  ) async {
    try {
      return await _remoteDataSource.initiatePurchase(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<MetalPurchaseSession>> getActiveSession() async {
    try {
      return await _remoteDataSource.getActiveSession();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId) async {
    try {
      return await _remoteDataSource.createOrder(sessionId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request) async {
    try {
      return await _remoteDataSource.verifyPayment(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> executeSell(String sessionId) async {
    try {
      return await _remoteDataSource.executeSell(sessionId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> recordFailure(
    Map<String, dynamic> failureDetails,
  ) async {
    try {
      return await _remoteDataSource.recordFailure(failureDetails);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> cancelSession(String sessionId) async {
    try {
      return await _remoteDataSource.cancelSession(sessionId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
