import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/partner_models.dart';

abstract class PartnerRemoteDataSource {
  Future<BaseResponse<List<Partner>>> getPartners({String? city});
  Future<BaseResponse<Partner>> getPartnerDetails();
  Future<BaseResponse<void>> registerPartner(Map<String, dynamic> data);
  Future<BaseResponse<void>> updatePartnerDetails(Map<String, dynamic> data);
}

class PartnerRemoteDataSourceImpl implements PartnerRemoteDataSource {
  final Dio _dio;
  PartnerRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<List<Partner>>> getPartners({String? city}) async {
    final response = await _dio.get(
      '/partner',
      queryParameters: city != null ? {'city': city} : null,
    );
    return BaseResponse.fromJson(response.data, (json) {
      if (json is List) {
        return json.map((e) => Partner.fromJson(e)).toList();
      } else if (json is Map<String, dynamic>) {
        final partnersList = json['partners'];
        if (partnersList is List) {
          return partnersList.map((e) => Partner.fromJson(e)).toList();
        }
      }
      return [];
    });
  }

  @override
  Future<BaseResponse<Partner>> getPartnerDetails() async {
    final response = await _dio.get('/partner/details');
    return BaseResponse.fromJson(response.data, (json) {
      if (json is List && json.isNotEmpty && json[0] is Map<String, dynamic>) {
        return Partner.fromJson(json[0] as Map<String, dynamic>);
      } else if (json is Map<String, dynamic>) {
        return Partner.fromJson(json);
      }
      throw Exception('Invalid partner details format');
    });
  }

  @override
  Future<BaseResponse<void>> registerPartner(Map<String, dynamic> data) async {
    final response = await _dio.post('/partner/register', data: data);
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> updatePartnerDetails(
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post('/partner/details', data: data);
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
