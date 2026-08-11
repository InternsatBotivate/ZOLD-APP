import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/goals_controller.dart';
import 'create_goal_view.dart';
import 'goal_details_view.dart';
import '../../../data/models/goal_models.dart';

class GoalsView extends GetView<GoalsController> {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.background,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.primaryGold,
          elevation: 0,
          title: Text(
            'My Metal Goals',
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
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Active Goals'),
              Tab(text: 'History'),
            ],
            labelColor: isDark ? AppColors.primaryGold : Colors.white,
            unselectedLabelColor: isDark
                ? AppColors.textMutedDark
                : Colors.white70,
            indicatorColor: isDark ? AppColors.primaryGold : Colors.white,
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(
          children: [_buildActiveTab(isDark), _buildHistoryTab(isDark)],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(() => const CreateGoalView()),
          backgroundColor: AppColors.primaryGold,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New Goal', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildActiveTab(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.activeGoals.isEmpty) {
        return _buildEmptyState(
          icon: '🎯',
          title: 'No Active Goals',
          subtitle: 'Create your first metal savings goal!',
          buttonText: 'Create Your First Goal',
          isDark: isDark,
          onTap: () => Get.to(() => const CreateGoalView()),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchGoals,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...controller.activeGoals.map(
              (goal) => _buildGoalCard(goal, isDark),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHistoryTab(bool isDark) {
    return Obx(() {
      if (controller.isHistoryLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.historyGoals.isEmpty) {
        return _buildEmptyState(
          icon: '📜',
          title: 'No History Yet',
          subtitle: 'Completed and cancelled goals will appear here.',
          isDark: isDark,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchGoalHistory,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.historyGoals.length,
          itemBuilder: (context, index) {
            final goal = controller.historyGoals[index];
            return _buildGoalCard(goal, isDark, isHistory: true);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState({
    required String icon,
    required String title,
    required String subtitle,
    String? buttonText,
    bool isDark = false,
    VoidCallback? onTap,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : null,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (buttonText != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, bool isDark, {bool isHistory = false}) {
    final progress = controller.getProgress(goal);
    final daysLeft = controller.getDaysLeft(goal.targetDate);
    final isGold = goal.metal == 'GOLD';
    final metalColor = isGold
        ? AppColors.primaryGold
        : (isDark ? const Color(0xFF94A3B8) : Colors.blueGrey);
    final categoryIcon = _getCategoryIcon(goal.goalCategory);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.bgDarkSecondary : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.cardBorder,
        ),
      ),
      child: InkWell(
        onTap: () => Get.to(() => GoalDetailsView(goal: goal)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: metalColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(categoryIcon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            goal.goalName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: metalColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${StringUtils.capitalizeFirst(goal.goalCategory)} • ${StringUtils.capitalizeFirst(goal.metal)} • ${isHistory ? "Ended ${DateFormat('dd MMM yyyy').format(goal.targetDate)}" : (daysLeft > 0 ? "$daysLeft days left" : "Overdue")}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(metalColor),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          goal.targetGrams > 0 && goal.targetAmount == 0
                              ? '${goal.currentGrams.toStringAsFixed(3)}g saved'
                              : '₹${goal.currentAmount.toStringAsFixed(0)} saved',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          goal.targetGrams > 0 && goal.targetAmount == 0
                              ? '${goal.targetGrams.toStringAsFixed(3)}g target'
                              : '₹${goal.targetAmount.toStringAsFixed(0)} target',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    if (goal.autoAllocate) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Auto-allocate',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isHistory) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (goal.status == 'COMPLETED'
                                      ? Colors.green
                                      : Colors.red)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          goal.status == 'COMPLETED'
                              ? 'Completed'
                              : 'Cancelled',
                          style: TextStyle(
                            fontSize: 10,
                            color: goal.status == 'COMPLETED'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
}
