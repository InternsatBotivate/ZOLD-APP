import '../../core/network/error_handler.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';
import '../models/base_response.dart';

abstract class AuthRepository {
  Future<BaseResponse<LoginResponse>> login(LoginRequest request);
  Future<BaseResponse<Map<String, dynamic>>> signup(SignupRequest request);
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest request);
  Future<BaseResponse<void>> resendOtp(String email);
  Future<BaseResponse<void>> forgotPassword(ForgotPasswordRequest request);
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest request);
  Future<BaseResponse<void>> logout();
  Future<BaseResponse<User>> getMe();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      return await _remoteDataSource.login(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> signup(
    SignupRequest request,
  ) async {
    try {
      return await _remoteDataSource.signup(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> verifyOtp(VerifyOtpRequest request) async {
    try {
      return await _remoteDataSource.verifyOtp(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> resendOtp(String email) async {
    try {
      return await _remoteDataSource.resendOtp(email);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      return await _remoteDataSource.forgotPassword(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      return await _remoteDataSource.resetPassword(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> logout() async {
    try {
      return await _remoteDataSource.logout();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<User>> getMe() async {
    try {
      return await _remoteDataSource.getMe();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
