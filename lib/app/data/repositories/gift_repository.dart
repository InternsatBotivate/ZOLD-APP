import '../../core/network/error_handler.dart';
import '../datasources/gift_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/gift_models.dart';
import '../models/auth_models.dart';

abstract class GiftRepository {
  Future<BaseResponse<User>> lookupUser(String phone);
  Future<BaseResponse<void>> sendGift(GiftSendRequest request);
}

class GiftRepositoryImpl implements GiftRepository {
  final GiftRemoteDataSource _remoteDataSource;
  GiftRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<User>> lookupUser(String phone) async {
    try {
      return await _remoteDataSource.lookupUser(phone);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> sendGift(GiftSendRequest request) async {
    try {
      return await _remoteDataSource.sendGift(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
