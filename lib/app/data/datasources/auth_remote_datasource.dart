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
      // Handle 'token=xyz; Path=/; HttpOnly'
      if (cookie.contains('token=')) {
        final parts = cookie.split(';');
        for (var part in parts) {
          final trimmedPart = part.trim();
          if (trimmedPart.startsWith('token=')) {
            return trimmedPart.substring('token='.length);
          }
        }
      }
    }
    return null;
  }

  @override
  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    final token = _extractToken(response);
    final data = Map<String, dynamic>.from(response.data);

    // Backend returns { success: true, user: { ... } }
    // We need to inject the token if it's in the cookie
    final userData = data['user'] as Map<String, dynamic>?;
    
    if (userData != null) {
      data['data'] = {
        'token': token ?? data['token'] ?? '',
        'user': userData,
      };
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
    // e.g. { success: true, message: "...", role: "USER", referralCode: "..." }
    if (!data.containsKey('data')) {
      // Create a shallow copy to avoid circular reference if BaseResponse uses 'data' key
      data['data'] = Map<String, dynamic>.from(data);
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
    final response = await _dio.get('/auth/me');
    final data = Map<String, dynamic>.from(response.data);
    
    // Backend returns { success: true, user: { ... } }
    if (!data.containsKey('data') && data.containsKey('user')) {
      data['data'] = data['user'];
    }
    
    return BaseResponse.fromJson(
      data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }
}
