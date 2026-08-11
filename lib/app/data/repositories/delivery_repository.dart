import '../../core/network/error_handler.dart';
import '../datasources/delivery_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/delivery_models.dart';

abstract class DeliveryRepository {
  Future<BaseResponse<List<DeliveryModel>>> getDeliveries();
  Future<BaseResponse<List<DeliveryModel>>> getAssignedDeliveries();
  Future<BaseResponse<void>> initiateDelivery(InitiateDeliveryRequest request);
  Future<BaseResponse<void>> cancelDelivery(String deliveryId);
  Future<BaseResponse<void>> updateDeliveryStatus(
    String deliveryId,
    String tentativeDate,
  );
  Future<BaseResponse<void>> completeDelivery(String deliveryId);
  Future<BaseResponse<void>> verifyDelivery(String deliveryId, int otp);
}

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource _remoteDataSource;
  DeliveryRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<DeliveryModel>>> getDeliveries() async {
    try {
      return await _remoteDataSource.getDeliveries();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<DeliveryModel>>> getAssignedDeliveries() async {
    try {
      return await _remoteDataSource.getAssignedDeliveries();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> initiateDelivery(
    InitiateDeliveryRequest request,
  ) async {
    try {
      return await _remoteDataSource.initiateDelivery(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> cancelDelivery(String deliveryId) async {
    try {
      return await _remoteDataSource.cancelDelivery(deliveryId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateDeliveryStatus(
    String deliveryId,
    String tentativeDate,
  ) async {
    try {
      return await _remoteDataSource.updateDeliveryStatus(
        deliveryId,
        tentativeDate,
      );
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> completeDelivery(String deliveryId) async {
    try {
      return await _remoteDataSource.completeDelivery(deliveryId);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> verifyDelivery(String deliveryId, int otp) async {
    try {
      return await _remoteDataSource.verifyDelivery(deliveryId, otp);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
