import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/profile_models.dart';
import '../models/auth_models.dart';
import '../models/notification_models.dart';

abstract class ProfileRemoteDataSource {
  Future<BaseResponse<User>> getProfile();
  Future<BaseResponse<List<BankAccount>>> getBankAccounts();
  Future<BaseResponse<BankAccount>> addBankAccount(BankAccount account);
  Future<BaseResponse<void>> updateBankAccount(String id, BankAccount account);
  Future<BaseResponse<void>> deleteBankAccount(String id);
  Future<BaseResponse<void>> setPrimaryBankAccount(String id);

  Future<BaseResponse<List<Address>>> getAddresses();
  Future<BaseResponse<Address>> addAddress(Address address);
  Future<BaseResponse<void>> updateAddress(String id, Address address);
  Future<BaseResponse<void>> deleteAddress(String id);
  Future<BaseResponse<void>> setPrimaryAddress(String id);

  Future<BaseResponse<List<UserSession>>> getSessions();
  Future<BaseResponse<void>> revokeSession(String id);
  Future<BaseResponse<void>> revokeAllSessions();

  Future<BaseResponse<SecuritySettings>> getSecuritySettings();
  Future<BaseResponse<void>> updateSecuritySettings(SecuritySettings settings);

  Future<BaseResponse<NotificationSettings>> getNotificationSettings();
  Future<BaseResponse<void>> updateNotificationSettings(
    NotificationSettings settings,
  );

  Future<BaseResponse<void>> updatePassword(PasswordRequest request);
  Future<BaseResponse<void>> updateProfile(UpdateProfileRequest request);
  Future<BaseResponse<void>> uploadProfilePicture(String filePath);

  Future<BaseResponse<List<PaymentMethod>>> getPaymentMethods();
  Future<BaseResponse<void>> addPaymentMethod(PaymentMethod method);
  Future<BaseResponse<void>> deletePaymentMethod(String id);
  Future<BaseResponse<void>> setPrimaryPaymentMethod(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<User>> getProfile() async {
    final response = await _dio.get('/profile');
    return BaseResponse.fromJson(
      response.data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final response = await _dio.get('/payment-methods');
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as List).map((e) => PaymentMethod.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: true, data: [], message: 'Not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> addPaymentMethod(PaymentMethod method) async {
    try {
      final response = await _dio.post('/payment-methods', data: method.toJson());
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> deletePaymentMethod(String id) async {
    try {
      final response = await _dio.delete('/payment-methods/$id');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> setPrimaryPaymentMethod(String id) async {
    try {
      final response = await _dio.put('/payment-methods/$id/set-primary');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<List<BankAccount>>> getBankAccounts() async {
    try {
      final response = await _dio.get('/bank-accounts');
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as List).map((e) => BankAccount.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: true, data: [], message: 'Not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<BankAccount>> addBankAccount(BankAccount account) async {
    final response = await _dio.post('/bank-accounts', data: account.toJson());
    return BaseResponse.fromJson(
      response.data,
      (json) => BankAccount.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> updateBankAccount(
    String id,
    BankAccount account,
  ) async {
    final response = await _dio.put(
      '/bank-accounts/$id',
      data: account.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> deleteBankAccount(String id) async {
    final response = await _dio.delete('/bank-accounts/$id');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> setPrimaryBankAccount(String id) async {
    final response = await _dio.put('/bank-accounts/$id/set-primary');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<List<Address>>> getAddresses() async {
    try {
      final response = await _dio.get('/saved-addresses');
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as List).map((e) => Address.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: true, data: [], message: 'Not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<Address>> addAddress(Address address) async {
    try {
      final response = await _dio.post(
        '/saved-addresses',
        data: address.toJson(),
      );
      return BaseResponse.fromJson(
        response.data,
        (json) => Address.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> updateAddress(String id, Address address) async {
    try {
      final response = await _dio.put(
        '/saved-addresses/$id',
        data: address.toJson(),
      );
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> deleteAddress(String id) async {
    try {
      final response = await _dio.delete('/saved-addresses/$id');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> setPrimaryAddress(String id) async {
    try {
      final response = await _dio.put('/saved-addresses/$id/set-primary');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<List<UserSession>>> getSessions() async {
    try {
      final response = await _dio.get('/sessions');
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as List).map((e) => UserSession.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: true, data: [], message: 'Not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> revokeSession(String id) async {
    try {
      final response = await _dio.delete('/sessions/$id');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> revokeAllSessions() async {
    try {
      final response = await _dio.post('/sessions/revoke-all');
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<SecuritySettings>> getSecuritySettings() async {
    try {
      final response = await _dio.get('/sessions/security-settings');
      return BaseResponse.fromJson(
        response.data,
        (json) => SecuritySettings.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(
          success: true,
          data: SecuritySettings(
            twoFactorEnabled: false,
            dataSharing: false,
            profileVisibility: 'contacts',
            readReceipts: true,
          ),
          message: 'Not found',
        );
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> updateSecuritySettings(
    SecuritySettings settings,
  ) async {
    try {
      final response = await _dio.put(
        '/sessions/security-settings',
        data: settings.toJson(),
      );
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<NotificationSettings>> getNotificationSettings() async {
    try {
      final response = await _dio.get('/profile/notification-settings');
      return BaseResponse.fromJson(
        response.data,
        (json) => NotificationSettings.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(
          success: true,
          data: NotificationSettings(),
          message: 'Not found',
        );
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    try {
      final response = await _dio.put(
        '/profile/notification-settings',
        data: settings.toJson(),
      );
      return BaseResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return BaseResponse(success: false, message: 'Endpoint not found');
      }
      rethrow;
    }
  }

  @override
  Future<BaseResponse<void>> updatePassword(PasswordRequest request) async {
    final response = await _dio.put(
      '/profile/password',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> updateProfile(UpdateProfileRequest request) async {
    final response = await _dio.put('/profile', data: request.toJson());
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> uploadProfilePicture(String filePath) async {
    final formData = FormData.fromMap({
      'updated_image': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/users/upload', data: formData);
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
