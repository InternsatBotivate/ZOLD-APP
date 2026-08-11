import '../../core/network/error_handler.dart';
import '../datasources/sip_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/sip_models.dart';

abstract class SipRepository {
  Future<BaseResponse<Sip>> createSip(CreateSipRequest request);
  Future<BaseResponse<List<Sip>>> getMySips();
  Future<BaseResponse<List<SipPlan>>> getAllSips();
  Future<BaseResponse<SipOrderResponse>> createSipOrder(
    SipOrderRequest request,
  );
  Future<BaseResponse<void>> verifySip(SipVerifyRequest request);
  Future<BaseResponse<TopupOrderResponse>> createTopupOrder(
    TopupOrderRequest request,
  );
  Future<BaseResponse<void>> verifyTopup(TopupVerifyRequest request);
  Future<BaseResponse<void>> modifySip(ModifySipRequest request);
}

class SipRepositoryImpl implements SipRepository {
  final SipRemoteDataSource _remoteDataSource;
  SipRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<Sip>> createSip(CreateSipRequest request) async {
    try {
      return await _remoteDataSource.createSip(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<Sip>>> getMySips() async {
    try {
      return await _remoteDataSource.getMySips();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<SipPlan>>> getAllSips() async {
    try {
      return await _remoteDataSource.getAllSips();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<SipOrderResponse>> createSipOrder(
    SipOrderRequest request,
  ) async {
    try {
      return await _remoteDataSource.createSipOrder(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> verifySip(SipVerifyRequest request) async {
    try {
      return await _remoteDataSource.verifySip(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<TopupOrderResponse>> createTopupOrder(
    TopupOrderRequest request,
  ) async {
    try {
      return await _remoteDataSource.createTopupOrder(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> verifyTopup(TopupVerifyRequest request) async {
    try {
      return await _remoteDataSource.verifyTopup(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> modifySip(ModifySipRequest request) async {
    try {
      return await _remoteDataSource.modifySip(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
