import '../../core/network/error_handler.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/notification_models.dart';

abstract class NotificationRepository {
  Future<BaseResponse<NotificationResponse>> getNotifications();
  Future<BaseResponse<void>> markAllRead();
  Future<BaseResponse<void>> markAsRead(String id);
  Future<BaseResponse<void>> clearAll();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<NotificationResponse>> getNotifications() async {
    try {
      return await _remoteDataSource.getNotifications();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> markAllRead() async {
    try {
      return await _remoteDataSource.markAllRead();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> markAsRead(String id) async {
    try {
      return await _remoteDataSource.markAsRead(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> clearAll() async {
    try {
      return await _remoteDataSource.clearAll();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
