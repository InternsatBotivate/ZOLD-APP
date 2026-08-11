import 'package:dio/dio.dart';
import '../../core/storage/secure_storage.dart';
import '../models/auth_models.dart';
import '../models/base_response.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse<LoginResponse>> login(LoginRequest request);
  Future<BaseResponse<Map<String, dynamic>>> signup(SignupRequest request);
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest request);
  Future<BaseResponse<void>> resendOtp(String email);
  Future<BaseResponse<void>> forgotPassword(ForgotPasswordRequest request);
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest request);
  Future<BaseResponse<void>> logout();
  Future<BaseResponse<User>> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  String? _extractToken(Response response) {
    final cookies = response.headers['set-cookie'];
    if (cookies == null || cookies.isEmpty) return null;

    for (var cookie in cookies) {
      if (cookie.startsWith('token=')) {
        return cookie.split(';').first.split('=').last;
      }
    }
    return null;
  }

  @override
  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    final token = _extractToken(response);
    final data = Map<String, dynamic>.from(response.data);

    if (!data.containsKey('data')) {
      data['data'] = {'token': token ?? data['token'], 'user': data['user']};
    } else if (token != null) {
      data['data']['token'] = token;
    }

    return BaseResponse.fromJson(
      data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> signup(
    SignupRequest request,
  ) async {
    final response = await _dio.post('/auth/signup', data: request.toJson());
    final data = Map<String, dynamic>.from(response.data);

    // Backend returns response directly without 'data' key for signup
    if (!data.containsKey('data')) {
      data['data'] = data;
    }

    return BaseResponse.fromJson(data, (json) => json as Map<String, dynamic>);
  }

  @override
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest request) async {
    final response = await _dio.post(
      '/auth/verify-otp',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> resendOtp(String email) async {
    final response = await _dio.post(
      '/auth/resend-otp',
      data: {'email': email},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await _dio.post(
      '/auth/forgot-password',
      data: request.toJson(),
    );
    final token = _extractToken(response);
    if (token != null) {
      await SecureStorage().saveToken(token);
    }
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await _dio.post(
      '/auth/reset-password',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> logout() async {
    final response = await _dio.post('/auth/logout');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<User>> getMe() async {
    final response = await _dio.get(
      '/auth/me',
    ); // Backend uses /auth/me for getMe
    final data = Map<String, dynamic>.from(response.data);
    if (!data.containsKey('data')) {
      data['data'] = data['user'];
    }
    return BaseResponse.fromJson(
      data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }
}
