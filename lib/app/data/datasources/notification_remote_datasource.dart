import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/notification_models.dart';

abstract class NotificationRemoteDataSource {
  Future<BaseResponse<NotificationResponse>> getNotifications();
  Future<BaseResponse<void>> markAllRead();
  Future<BaseResponse<void>> markAsRead(String id);
  Future<BaseResponse<void>> clearAll();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;
  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<NotificationResponse>> getNotifications() async {
    final response = await _dio.get('/notifications');
    return BaseResponse.fromJson(
      response.data,
      (json) => NotificationResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> markAllRead() async {
    final response = await _dio.patch('/notifications/read');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> markAsRead(String id) async {
    final response = await _dio.patch('/notifications/$id/read');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> clearAll() async {
    final response = await _dio.delete('/notifications');
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
