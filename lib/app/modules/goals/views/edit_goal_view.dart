import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/goals_controller.dart';
import '../../../data/models/goal_models.dart';

class EditGoalView extends StatefulWidget {
  final Goal goal;
  const EditGoalView({super.key, required this.goal});

  @override
  State<EditGoalView> createState() => _EditGoalViewState();
}

class _EditGoalViewState extends State<EditGoalView> {
  final controller = Get.find<GoalsController>();
  final _formKey = GlobalKey<FormState>();

  late String _goalName;
  late String _category;
  late double _targetValue;
  late DateTime _deadline;
  late String _paymentFrequency;

  late TextEditingController _nameController;
  late TextEditingController _targetController;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'wedding', 'name': 'Wedding', 'icon': '💍'},
    {'id': 'festival', 'name': 'Festival', 'icon': '🪔'},
    {'id': 'emergency', 'name': 'Emergency', 'icon': '🛡️'},
    {'id': 'investment', 'name': 'Investment', 'icon': '📈'},
    {'id': 'gift', 'name': 'Gift', 'icon': '🎁'},
    {'id': 'custom', 'name': 'Custom', 'icon': '⭐'},
  ];

  @override
  void initState() {
    super.initState();
    _goalName = widget.goal.goalName;
    _category = widget.goal.goalCategory;
    final isGrams =
        widget.goal.targetGrams > 0 && widget.goal.targetAmount == 0;
    _targetValue = isGrams ? widget.goal.targetGrams : widget.goal.targetAmount;
    _deadline = widget.goal.targetDate;
    _paymentFrequency = widget.goal.paymentFrequency;

    _nameController = TextEditingController(text: _goalName);
    _targetController = TextEditingController(
      text: isGrams
          ? _targetValue.toStringAsFixed(3)
          : _targetValue.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGold = widget.goal.metal == 'GOLD';
    final accentColor = isGold
        ? AppColors.primaryGold
        : (isDark ? const Color(0xFF94A3B8) : Colors.blueGrey);
    final isGrams =
        widget.goal.targetGrams > 0 && widget.goal.targetAmount == 0;
    final currentProgress = isGrams
        ? widget.goal.currentGrams
        : widget.goal.currentAmount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : accentColor,
        elevation: 0,
        title: Text(
          'Edit Goal',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Name
              Text(
                'Goal Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : AppColors.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : AppColors.cardBorder,
                    ),
                  ),
                ),
                onChanged: (val) => _goalName = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter a goal name'
                    : null,
              ),
              const SizedBox(height: 24),

              // Category
              Text(
                'Goal Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _category == cat['id'];
                  return InkWell(
                    onTap: () => setState(() => _category = cat['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentColor.withValues(alpha: 0.1)
                            : (isDark
                                  ? AppColors.bgDarkSecondary
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? accentColor
                              : (isDark
                                    ? Colors.white10
                                    : AppColors.cardBorder),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat['icon'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textPrimaryDark : null,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Target Input
              Text(
                isGrams ? 'Target Weight (g)' : 'Target Amount (₹)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
                decoration: InputDecoration(
                  prefixText: isGrams ? 'g ' : '₹ ',
                  prefixStyle: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : null,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : AppColors.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : AppColors.cardBorder,
                    ),
                  ),
                ),
                onChanged: (val) => _targetValue = double.tryParse(val) ?? 0,
                validator: (val) {
                  final d = double.tryParse(val ?? '');
                  if (d == null || d <= 0) return 'Please enter a valid target';
                  if (d < currentProgress) {
                    return 'Target cannot be less than current progress (${isGrams ? "${currentProgress.toStringAsFixed(3)}g" : "₹${currentProgress.toStringAsFixed(0)}"})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Frequency
              Text(
                'Contribution Frequency',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildFreqButton('MONTHLY', accentColor, isDark),
                  const SizedBox(width: 8),
                  _buildFreqButton('QUATERLY', accentColor, isDark),
                  const SizedBox(width: 8),
                  _buildFreqButton('YEARLY', accentColor, isDark),
                ],
              ),
              const SizedBox(height: 24),

              // Target Date
              Text(
                'Target Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) setState(() => _deadline = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.cardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(_deadline),
                        style: TextStyle(
                          color: isDark ? AppColors.textPrimaryDark : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isActionLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateGoal(
                                widget.goal.id,
                                UpdateGoalRequest(
                                  goalName: _goalName,
                                  goalCategory: _category,
                                  targetAmount: isGrams ? null : _targetValue,
                                  targetGrams: isGrams ? _targetValue : null,
                                  paymentFrequency: _paymentFrequency,
                                  targetDate: _deadline.toIso8601String(),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isActionLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreqButton(String freq, Color accentColor, bool isDark) {
    final isSelected = _paymentFrequency == freq;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _paymentFrequency = freq),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor
                : (isDark ? AppColors.bgDarkSecondary : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : (isDark ? Colors.white10 : AppColors.cardBorder),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            StringUtils.capitalizeFirst(freq),
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textPrimary),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
