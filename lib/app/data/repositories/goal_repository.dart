import '../../core/network/error_handler.dart';
import '../datasources/goal_remote_datasource.dart';
import '../models/base_response.dart';
import '../models/goal_models.dart';

abstract class GoalRepository {
  Future<BaseResponse<Goal>> createGoal(CreateGoalRequest request);
  Future<BaseResponse<List<Goal>>> getGoals();
  Future<BaseResponse<List<Goal>>> getGoalHistory();
  Future<BaseResponse<Goal>> updateGoal(String id, UpdateGoalRequest request);
  Future<BaseResponse<void>> deleteGoal(String id);
}

class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource _remoteDataSource;
  GoalRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<Goal>> createGoal(CreateGoalRequest request) async {
    try {
      return await _remoteDataSource.createGoal(request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<Goal>>> getGoals() async {
    try {
      return await _remoteDataSource.getGoals();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<List<Goal>>> getGoalHistory() async {
    try {
      return await _remoteDataSource.getGoalHistory();
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<Goal>> updateGoal(
    String id,
    UpdateGoalRequest request,
  ) async {
    try {
      return await _remoteDataSource.updateGoal(id, request);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  @override
  Future<BaseResponse<void>> deleteGoal(String id) async {
    try {
      return await _remoteDataSource.deleteGoal(id);
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }
}
