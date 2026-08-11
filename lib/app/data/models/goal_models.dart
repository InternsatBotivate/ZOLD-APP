import 'wallet_models.dart';

class Goal {
  final String id;
  final String goalName;
  final String goalCategory;
  final double targetAmount;
  final double currentAmount;
  final double targetGrams;
  final double currentGrams;
  final String metal;
  final String status;
  final DateTime targetDate;
  final DateTime? completionDate;
  final bool autoAllocate;
  final String paymentFrequency;

  Goal({
    required this.id,
    required this.goalName,
    required this.goalCategory,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetGrams,
    required this.currentGrams,
    required this.metal,
    required this.status,
    required this.targetDate,
    this.completionDate,
    required this.autoAllocate,
    required this.paymentFrequency,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] ?? '',
      goalName: json['goalName'] ?? json['goal_name'] ?? '',
      goalCategory: json['goalCategory'] ?? json['goal_category'] ?? 'custom',
      targetAmount: parseDouble(json['targetAmount'] ?? json['target_amount']),
      currentAmount: parseDouble(
        json['currentAmount'] ?? json['current_amount'],
      ),
      targetGrams: parseDouble(json['targetGrams'] ?? json['target_grams']),
      currentGrams: parseDouble(json['currentGrams'] ?? json['current_grams']),
      metal: json['metal'] ?? 'GOLD',
      status: json['status'] ?? 'ACTIVE',
      targetDate: parseDateTime(json['targetDate'] ?? json['target_date']),
      completionDate:
          json['completionDate'] != null || json['completion_date'] != null
          ? parseDateTime(json['completionDate'] ?? json['completion_date'])
          : null,
      autoAllocate: json['autoAllocate'] ?? json['auto_allocate'] ?? false,
      paymentFrequency:
          json['paymentFrequency'] ?? json['payment_frequency'] ?? 'MONTHLY',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalName': goalName,
    'goalCategory': goalCategory,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'targetGrams': targetGrams,
    'currentGrams': currentGrams,
    'metal': metal,
    'status': status,
    'targetDate': targetDate.toIso8601String(),
    'completionDate': completionDate?.toIso8601String(),
    'autoAllocate': autoAllocate,
    'paymentFrequency': paymentFrequency,
  };
}

class CreateGoalRequest {
  final String goalName;
  final String goalCategory;
  final double targetAmount;
  final double targetGrams;
  final String metalType;
  final String paymentFrequency;
  final String targetDate;
  final bool autoAllocate;

  CreateGoalRequest({
    required this.goalName,
    required this.goalCategory,
    required this.targetAmount,
    required this.targetGrams,
    required this.metalType,
    required this.paymentFrequency,
    required this.targetDate,
    this.autoAllocate = false,
  });

  Map<String, dynamic> toJson() => {
    'goalName': goalName,
    'goalCategory': goalCategory,
    'targetAmount': targetAmount,
    'targetGrams': targetGrams,
    'metalType': metalType,
    'paymentFrequency': paymentFrequency,
    'targetDate': targetDate,
    'autoAllocate': autoAllocate,
  };
}

class UpdateGoalRequest {
  final String? goalName;
  final String? goalCategory;
  final double? targetAmount;
  final double? targetGrams;
  final String? paymentFrequency;
  final String? targetDate;

  UpdateGoalRequest({
    this.goalName,
    this.goalCategory,
    this.targetAmount,
    this.targetGrams,
    this.paymentFrequency,
    this.targetDate,
  });

  Map<String, dynamic> toJson() => {
    if (goalName != null) 'goalName': goalName,
    if (goalCategory != null) 'goalCategory': goalCategory,
    if (targetAmount != null) 'targetAmount': targetAmount,
    if (targetGrams != null) 'targetGrams': targetGrams,
    if (paymentFrequency != null) 'paymentFrequency': paymentFrequency,
    if (targetDate != null) 'targetDate': targetDate,
  };
}
