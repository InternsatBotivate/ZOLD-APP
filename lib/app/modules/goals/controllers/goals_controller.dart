import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/goal_models.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../data/repositories/rate_repository.dart';

class GoalsController extends GetxController {
  final GoalRepository goalRepository;
  final RateRepository rateRepository;

  GoalsController({required this.goalRepository, required this.rateRepository});

  final RxList<Goal> activeGoals = <Goal>[].obs;
  final RxList<Goal> historyGoals = <Goal>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isHistoryLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  final RxDouble goldPrice = 0.0.obs;
  final RxDouble silverPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRates();
    fetchGoals();
    fetchGoalHistory();
  }

  Future<void> fetchRates() async {
    try {
      final response = await rateRepository.getCurrentRates();
      if (response.success && response.data != null) {
        goldPrice.value = response.data!.gold.buyRate;
        silverPrice.value = response.data!.silver.buyRate;
      }
    } catch (e) {
      debugPrint('Error fetching rates: $e');
    }
  }

  Future<void> fetchGoals() async {
    isLoading.value = true;
    try {
      final response = await goalRepository.getGoals();
      if (response.success) {
        activeGoals.assignAll(
          response.data!.where((g) => g.status == 'ACTIVE').toList(),
        );
      }
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGoalHistory() async {
    isHistoryLoading.value = true;
    try {
      final response = await goalRepository.getGoalHistory();
      if (response.success) {
        historyGoals.assignAll(response.data!);
      }
    } catch (e) {
      debugPrint('Error fetching goal history: $e');
    } finally {
      isHistoryLoading.value = false;
    }
  }

  Future<void> createGoal(CreateGoalRequest request) async {
    isActionLoading.value = true;
    try {
      final response = await goalRepository.createGoal(request);
      if (response.success) {
        activeGoals.insert(0, response.data!);
        Get.back();
        SnackbarUtils.showSuccess(
          'Goal "${request.goalName}" created successfully! 🎯',
        );
      }
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> updateGoal(String id, UpdateGoalRequest request) async {
    isActionLoading.value = true;
    try {
      final response = await goalRepository.updateGoal(id, request);
      if (response.success) {
        final index = activeGoals.indexWhere((g) => g.id == id);
        if (index != -1) {
          activeGoals[index] = response.data!;
        }
        Get.back();
        SnackbarUtils.showSuccess('Goal updated successfully');
      }
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> deleteGoal(String id) async {
    isActionLoading.value = true;
    try {
      final response = await goalRepository.deleteGoal(id);
      if (response.success) {
        activeGoals.removeWhere((g) => g.id == id);
        Get.back();
        SnackbarUtils.showSuccess('Goal deleted successfully');
      }
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  double getProgress(Goal goal) {
    if (goal.targetGrams > 0 && goal.targetAmount == 0) {
      return (goal.currentGrams / goal.targetGrams).clamp(0.0, 1.0);
    }
    if (goal.targetAmount > 0) {
      return (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  int getDaysLeft(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    return diff.inDays;
  }
}
