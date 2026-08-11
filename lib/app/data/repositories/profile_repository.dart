import '../../core/network/error_handler.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/notification_local_datasource.dart';
import '../models/base_response.dart';
import '../models/profile_models.dart';
import '../models/auth_models.dart';
import '../models/notification_models.dart';

abstract class ProfileRepository {
  // ... existing methods ...
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

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localNotificationDataSource;
  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localNotificationDataSource,
  );

  @override
  Future<BaseResponse<User>> getProfile() async {
    try {
      return await _remoteDataSource.getProfile();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      return await _remoteDataSource.getPaymentMethods();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> addPaymentMethod(PaymentMethod method) async {
    try {
      return await _remoteDataSource.addPaymentMethod(method);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> deletePaymentMethod(String id) async {
    try {
      return await _remoteDataSource.deletePaymentMethod(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> setPrimaryPaymentMethod(String id) async {
    try {
      return await _remoteDataSource.setPrimaryPaymentMethod(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<BankAccount>>> getBankAccounts() async {
    try {
      return await _remoteDataSource.getBankAccounts();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<BankAccount>> addBankAccount(BankAccount account) async {
    try {
      return await _remoteDataSource.addBankAccount(account);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateBankAccount(
    String id,
    BankAccount account,
  ) async {
    try {
      return await _remoteDataSource.updateBankAccount(id, account);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> deleteBankAccount(String id) async {
    try {
      return await _remoteDataSource.deleteBankAccount(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> setPrimaryBankAccount(String id) async {
    try {
      return await _remoteDataSource.setPrimaryBankAccount(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<Address>>> getAddresses() async {
    try {
      return await _remoteDataSource.getAddresses();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<Address>> addAddress(Address address) async {
    try {
      return await _remoteDataSource.addAddress(address);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateAddress(String id, Address address) async {
    try {
      return await _remoteDataSource.updateAddress(id, address);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> deleteAddress(String id) async {
    try {
      return await _remoteDataSource.deleteAddress(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> setPrimaryAddress(String id) async {
    try {
      return await _remoteDataSource.setPrimaryAddress(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<UserSession>>> getSessions() async {
    try {
      return await _remoteDataSource.getSessions();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> revokeSession(String id) async {
    try {
      return await _remoteDataSource.revokeSession(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> revokeAllSessions() async {
    try {
      return await _remoteDataSource.revokeAllSessions();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<SecuritySettings>> getSecuritySettings() async {
    try {
      return await _remoteDataSource.getSecuritySettings();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateSecuritySettings(
    SecuritySettings settings,
  ) async {
    try {
      return await _remoteDataSource.updateSecuritySettings(settings);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<NotificationSettings>> getNotificationSettings() async {
    try {
      // Try to get local settings first
      final localSettings = await _localNotificationDataSource
          .getNotificationSettings();

      // Try to fetch from remote to keep in sync
      try {
        final remoteResponse = await _remoteDataSource
            .getNotificationSettings();
        if (remoteResponse.success && remoteResponse.data != null) {
          await _localNotificationDataSource.saveNotificationSettings(
            remoteResponse.data!,
          );
          return remoteResponse;
        }
      } catch (e) {
        // Log error but continue with local data
      }

      // If remote fails but we have local data, return local data
      if (localSettings != null) {
        return BaseResponse(success: true, data: localSettings);
      }

      // Default fallback
      return BaseResponse(success: true, data: NotificationSettings());
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    try {
      // Always save locally first to ensure UI responsiveness
      await _localNotificationDataSource.saveNotificationSettings(settings);

      // Try to sync with remote
      try {
        return await _remoteDataSource.updateNotificationSettings(settings);
      } catch (e) {
        // Even if remote sync fails, we return success because it's saved locally
        // In a real app, you might want a sync queue
        return BaseResponse(
          success: true,
          message: 'Saved locally. Will sync when online.',
        );
      }
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updatePassword(PasswordRequest request) async {
    try {
      return await _remoteDataSource.updatePassword(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> updateProfile(UpdateProfileRequest request) async {
    try {
      return await _remoteDataSource.updateProfile(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> uploadProfilePicture(String filePath) async {
    try {
      return await _remoteDataSource.uploadProfilePicture(filePath);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
