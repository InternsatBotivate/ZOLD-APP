import '../../core/network/error_handler.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/coin_models.dart';
import 'package:zold_gold/app/data/models/payment_models.dart';

abstract class CartRepository {
  Future<BaseResponse<Cart>> getCart();
  Future<BaseResponse<Cart>> addCartItem(CartItem item);
  Future<BaseResponse<Cart>> removeCartItem(
    CartItem item, {
    bool removeAll = false,
  });
  Future<BaseResponse<CoinPurchaseSession>> initiateCheckout();
  Future<BaseResponse<RazorpayOrder>> createOrder(String sessionId);
  Future<BaseResponse<void>> verifyPayment(PaymentVerifyRequest request);
  Future<BaseResponse<void>> recordFailure(Map<String, dynamic> failureDetails);
  Future<BaseResponse<void>> cancelSession(String sessionId);
  Future<BaseResponse<CoinPurchaseSession?>> getActiveSession();
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<Cart>> getCart() async {
    try {
      return await _remoteDataSource.getCart();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<Cart>> addCartItem(CartItem item) async {
    try {
      return await _remoteDataSource.addCartItem(item);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<Cart>> removeCartItem(
    CartItem item, {
    bool removeAll = false,
  }) async {
    try {
      return await _remoteDataSource.removeCartItem(item, removeAll: removeAll);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<CoinPurchaseSession>> initiateCheckout() async {
    try {
      return await _remoteDataSource.initiateCheckout();
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

  @override
  Future<BaseResponse<CoinPurchaseSession?>> getActiveSession() async {
    try {
      return await _remoteDataSource.getActiveSession();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
