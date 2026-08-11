import 'package:dio/dio.dart';
import '../models/base_response.dart';
import '../models/goal_models.dart';

abstract class GoalRemoteDataSource {
  Future<BaseResponse<Goal>> createGoal(CreateGoalRequest request);
  Future<BaseResponse<List<Goal>>> getGoals();
  Future<BaseResponse<List<Goal>>> getGoalHistory();
  Future<BaseResponse<Goal>> updateGoal(String id, UpdateGoalRequest request);
  Future<BaseResponse<void>> deleteGoal(String id);
}

class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final Dio _dio;
  GoalRemoteDataSourceImpl(this._dio);

  @override
  Future<BaseResponse<Goal>> createGoal(CreateGoalRequest request) async {
    final response = await _dio.post('/gold-goals', data: request.toJson());
    return BaseResponse.fromJson(
      response.data,
      (json) => Goal.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<List<Goal>>> getGoals() async {
    final response = await _dio.get('/gold-goals');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => Goal.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<List<Goal>>> getGoalHistory() async {
    final response = await _dio.get('/gold-goals/history');
    return BaseResponse.fromJson(
      response.data,
      (json) => (json as List).map((e) => Goal.fromJson(e)).toList(),
    );
  }

  @override
  Future<BaseResponse<Goal>> updateGoal(
    String id,
    UpdateGoalRequest request,
  ) async {
    final response = await _dio.patch(
      '/gold-goals/$id',
      data: request.toJson(),
    );
    return BaseResponse.fromJson(
      response.data,
      (json) => Goal.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<BaseResponse<void>> deleteGoal(String id) async {
    final response = await _dio.delete('/gold-goals/$id');
    return BaseResponse.fromJson(response.data, (_) {});
  }
}
