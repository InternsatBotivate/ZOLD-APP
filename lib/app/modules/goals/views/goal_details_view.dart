import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/goals_controller.dart';
import '../../../data/models/goal_models.dart';
import 'edit_goal_view.dart';

class GoalDetailsView extends GetView<GoalsController> {
  final Goal goal;
  const GoalDetailsView({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = controller.getProgress(goal);
    final daysLeft = controller.getDaysLeft(goal.targetDate);
    final isGold = goal.metal == 'GOLD';
    final accentColor = isGold
        ? AppColors.primaryGold
        : (isDark ? const Color(0xFF94A3B8) : Colors.blueGrey);
    final categoryIcon = _getCategoryIcon(goal.goalCategory);
    final milestone = _getMilestoneMessage(progress);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : accentColor,
        elevation: 0,
        title: Text(
          goal.goalName,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: isDark ? AppColors.textPrimaryDark : Colors.white,
            ),
            onPressed: () => Get.to(() => EditGoalView(goal: goal)),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: isDark ? AppColors.textPrimaryDark : Colors.white,
            ),
            onPressed: () => _showDeleteConfirmation(isDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDark : accentColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                border: isDark
                    ? Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Text(categoryIcon, style: const TextStyle(fontSize: 48)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${StringUtils.capitalizeFirst(goal.goalCategory)} Goal',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          isGold ? '🥇 Gold' : '🥈 Silver',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Section
                  _buildSectionTitle('Progress', isDark),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}% completed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : null,
                              ),
                            ),
                            Text(
                              milestone['text'],
                              style: TextStyle(
                                color: milestone['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            accentColor,
                          ),
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildProgressInfo(
                              'Saved',
                              goal.targetGrams > 0 && goal.targetAmount == 0
                                  ? '${goal.currentGrams.toStringAsFixed(3)}g'
                                  : '₹${goal.currentAmount.toStringAsFixed(0)}',
                              isDark,
                            ),
                            _buildProgressInfo(
                              'Target',
                              goal.targetGrams > 0 && goal.targetAmount == 0
                                  ? '${goal.targetGrams.toStringAsFixed(3)}g'
                                  : '₹${goal.targetAmount.toStringAsFixed(0)}',
                              isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildStatCard(
                        'Current Value',
                        goal.targetGrams > 0 && goal.targetAmount == 0
                            ? '${goal.currentGrams.toStringAsFixed(3)}g'
                            : '₹${goal.currentAmount.toStringAsFixed(0)}',
                        goal.targetGrams > 0 && goal.targetAmount == 0
                            ? null
                            : '${goal.currentGrams.toStringAsFixed(3)}g saved',
                        isDark,
                      ),
                      _buildStatCard(
                        'Target Value',
                        goal.targetGrams > 0 && goal.targetAmount == 0
                            ? '${goal.targetGrams.toStringAsFixed(3)}g'
                            : '₹${goal.targetAmount.toStringAsFixed(0)}',
                        null,
                        isDark,
                      ),
                      _buildStatCard(
                        'Remaining',
                        goal.targetGrams > 0 && goal.targetAmount == 0
                            ? '${(goal.targetGrams - goal.currentGrams).clamp(0, double.infinity).toStringAsFixed(3)}g'
                            : '₹${(goal.targetAmount - goal.currentAmount).clamp(0, double.infinity).toStringAsFixed(0)}',
                        goal.targetGrams > 0 && goal.targetAmount == 0
                            ? null
                            : controller.goldPrice.value > 0
                            ? '${((goal.targetAmount - goal.currentAmount) / (isGold ? controller.goldPrice.value : controller.silverPrice.value)).clamp(0, double.infinity).toStringAsFixed(3)}g to reach'
                            : null,
                        isDark,
                      ),
                      _buildStatCard(
                        'Days Left',
                        daysLeft > 0 ? '$daysLeft' : '0',
                        'Until ${DateFormat('MMM yyyy').format(goal.targetDate)}',
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),

                  // Monthly Need
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installment Need',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _calculateMonthlyNeed(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Based on ${goal.paymentFrequency.toLowerCase()} frequency',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Auto Allocate Status
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: goal.autoAllocate
                          ? Colors.green.withValues(alpha: isDark ? 0.2 : 0.05)
                          : (isDark ? AppColors.bgDarkSecondary : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: goal.autoAllocate
                            ? Colors.green.withValues(alpha: isDark ? 0.3 : 0.2)
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : AppColors.cardBorder),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: goal.autoAllocate
                              ? Colors.green
                              : (isDark
                                    ? AppColors.textMutedDark
                                    : Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto-Allocate ${goal.autoAllocate ? "Active" : "Inactive"}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: goal.autoAllocate
                                      ? Colors.green
                                      : (isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimary),
                                ),
                              ),
                              Text(
                                goal.autoAllocate
                                    ? 'Purchases are automatically allocated to this goal'
                                    : 'Enable to auto-allocate purchases',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          Routes.buySell,
                          parameters: {
                            'metal': goal.metal.toLowerCase(),
                            'action': 'buy',
                          },
                        );
                      },
                      icon: const Icon(Icons.shopping_bag, color: Colors.white),
                      label: Text(
                        'Buy ${StringUtils.capitalizeFirst(goal.metal)} for Goal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : null,
      ),
    );
  }

  Widget _buildProgressInfo(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String? value, String? sub, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? '—',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : null,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _calculateMonthlyNeed() {
    final daysLeft = controller.getDaysLeft(goal.targetDate);
    if (daysLeft <= 0) return 'Overdue';

    double periodCount;
    switch (goal.paymentFrequency) {
      case 'QUATERLY':
        periodCount = (daysLeft / 91).clamp(1.0, double.infinity);
        break;
      case 'YEARLY':
        periodCount = (daysLeft / 365).clamp(1.0, double.infinity);
        break;
      default: // MONTHLY
        periodCount = (daysLeft / 30).clamp(1.0, double.infinity);
    }

    if (goal.targetGrams > 0 && goal.targetAmount == 0) {
      final remaining = (goal.targetGrams - goal.currentGrams).clamp(
        0.0,
        double.infinity,
      );
      return '${(remaining / periodCount).toStringAsFixed(3)}g / ${goal.paymentFrequency.toLowerCase().replaceAll('ly', '')}';
    } else {
      final remaining = (goal.targetAmount - goal.currentAmount).clamp(
        0.0,
        double.infinity,
      );
      return '₹${(remaining / periodCount).toStringAsFixed(0)} / ${goal.paymentFrequency.toLowerCase().replaceAll('ly', '')}';
    }
  }

  void _showDeleteConfirmation(bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.bgDarkSecondary : null,
        title: Text(
          'Delete Goal?',
          style: TextStyle(color: isDark ? AppColors.textPrimaryDark : null),
        ),
        content: Text(
          'Are you sure you want to delete this goal? This action cannot be undone.',
          style: TextStyle(color: isDark ? AppColors.textSecondaryDark : null),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () => controller.deleteGoal(goal.id),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'wedding':
        return '💍';
      case 'festival':
        return '🪔';
      case 'emergency':
        return '🛡️';
      case 'investment':
        return '📈';
      case 'gift':
        return '🎁';
      default:
        return '⭐';
    }
  }

  Map<String, dynamic> _getMilestoneMessage(double progress) {
    if (progress >= 1.0) {
      return {'text': '🎉 Goal Achieved!', 'color': Colors.green};
    }
    if (progress >= 0.75) {
      return {'text': '💪 Almost there!', 'color': Colors.orange};
    }
    if (progress >= 0.5) {
      return {'text': '🔥 Halfway done!', 'color': Colors.blue};
    }
    if (progress >= 0.25) {
      return {'text': '🌟 Great start!', 'color': Colors.purple};
    }
    return {'text': '🚀 Keep going!', 'color': Colors.grey};
  }
}
