import '../models/base_response.dart';
import '../models/partner_models.dart';
import '../datasources/partner_remote_datasource.dart';

abstract class PartnerRepository {
  Future<BaseResponse<List<Partner>>> getPartners({String? city});
  Future<BaseResponse<Partner>> getPartnerDetails();
  Future<BaseResponse<void>> registerPartner(Map<String, dynamic> data);
  Future<BaseResponse<void>> updatePartnerDetails(Map<String, dynamic> data);
}

class PartnerRepositoryImpl implements PartnerRepository {
  final PartnerRemoteDataSource _remoteDataSource;
  PartnerRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<Partner>>> getPartners({String? city}) {
    return _remoteDataSource.getPartners(city: city);
  }

  @override
  Future<BaseResponse<Partner>> getPartnerDetails() {
    return _remoteDataSource.getPartnerDetails();
  }

  @override
  Future<BaseResponse<void>> registerPartner(Map<String, dynamic> data) {
    return _remoteDataSource.registerPartner(data);
  }

  @override
  Future<BaseResponse<void>> updatePartnerDetails(Map<String, dynamic> data) {
    return _remoteDataSource.updatePartnerDetails(data);
  }
}
