import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/auth_models.dart';
import '../models/wallet_models.dart';

import '../models/admin_models.dart';

abstract class AdminRemoteDataSource {
  Future<BaseResponse<List<User>>> getAllUsers();
  Future<BaseResponse<UserTransactionHistory>> getUserTransactionHistory(
    String userId,
  );
  Future<BaseResponse<void>> updateMetalPrices(Map<String, dynamic> prices);
  Future<BaseResponse<void>> updateGstRate(double rate);
  Future<BaseResponse<double>> getCurrentGst();
  Future<BaseResponse<List<GstConfig>>> getGstHistory();
  Future<BaseResponse<List<SellRequest>>> getSellRequests();
  Future<BaseResponse<void>> approveSellRequest(String id);
  Future<BaseResponse<void>> rejectSellRequest(String id, String remark);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio _dio;
  AdminRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<List<User>>> getAllUsers() async {
    final response = await _dio.get('/users');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => User.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<UserTransactionHistory>> getUserTransactionHistory(
    String userId,
  ) async {
    final response = await _dio.get(
      '/admin/transactions/history',
      queryParameters: {'userId': userId},
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => UserTransactionHistory.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> updateMetalPrices(
    Map<String, dynamic> prices,
  ) async {
    final response = await _dio.post(
      '/admin/update-prices',
      data: {'metalPrice': prices},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> updateGstRate(double rate) async {
    final response = await _dio.post('/admin/gst', data: {'rate': rate});
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<double>> getCurrentGst() async {
    try {
      final response = await _dio.get('/meta/gst');
      debugPrint(
        "RAW API RESPONSE: GET /meta/gst -> ${json.encode(response.data)}",
      );

      if (response.data is! Map<String, dynamic>) {
        return BaseResponse(
          success: false,
          message: "Unexpected response format",
          data: 0.0,
        );
      }

      return BaseResponse.fromJson(response.data as Map<String, dynamic>, (
        json,
      ) {
        try {
          if (json is Map && json.containsKey('rate')) {
            return parseDouble(json['rate']);
          }
          return parseDouble(json);
        } catch (e) {
          debugPrint("ERROR: getCurrentGst fromJsonT failed: $e");
          return 0.0;
        }
      });
    } catch (e) {
      debugPrint("ERROR: getCurrentGst failed: $e");
      return BaseResponse(success: false, message: e.toString(), data: 0.0);
    }
  }

  @override
  Future<BaseResponse<List<GstConfig>>> getGstHistory() async {
    try {
      final response = await _dio.get('/admin/gst/history');
      debugPrint(
        "RAW API RESPONSE: GET /admin/gst/history -> ${json.encode(response.data)}",
      );

      if (response.data is! Map<String, dynamic>) {
        return BaseResponse(
          success: false,
          message: "Unexpected response format",
          data: [],
        );
      }

      return BaseResponse.fromJson(response.data as Map<String, dynamic>, (
        json,
      ) {
        try {
          if (json is List) {
            return json
                .whereType<Map<String, dynamic>>()
                .map((e) => GstConfig.fromJson(e))
                .toList();
          }
          return <GstConfig>[];
        } catch (e) {
          debugPrint("ERROR: getGstHistory fromJsonT failed: $e");
          return <GstConfig>[];
        }
      });
    } catch (e) {
      debugPrint("ERROR: getGstHistory failed: $e");
      return BaseResponse(success: false, message: e.toString(), data: []);
    }
  }

  @override
  Future<BaseResponse<List<SellRequest>>> getSellRequests() async {
    final response = await _dio.get('/admin/transactions/sell-history');
    return BaseResponse.fromJson(response.data, (json) {
      if (json is Map) {
        final metal = (json['metalSellTransactions'] as List? ?? []);
        final coin = (json['coinSellTransactions'] as List? ?? []);

        final List<SellRequest> merged = [
          ...metal.map(
            (e) => SellRequest.fromJson(e as Map<String, dynamic>, 'METAL'),
          ),
          ...coin.map(
            (e) => SellRequest.fromJson(e as Map<String, dynamic>, 'COIN'),
          ),
        ];

        merged.sort((a, b) => b.date.compareTo(a.date));
        return merged;
      }
      return [];
    });
  }

  @override
  Future<BaseResponse<void>> approveSellRequest(String id) async {
    final response = await _dio.post('/admin/transactions/approve/$id');
    return BaseResponse.fromJson(response.data, (_) {});
  }

  @override
  Future<BaseResponse<void>> rejectSellRequest(String id, String remark) async {
    final response = await _dio.post(
      '/admin/transactions/reject/$id',
      data: {'remark': remark},
    );
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
