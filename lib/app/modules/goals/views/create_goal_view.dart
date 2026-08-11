import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/goals_controller.dart';
import '../../../data/models/goal_models.dart';

class CreateGoalView extends StatefulWidget {
  const CreateGoalView({super.key});

  @override
  State<CreateGoalView> createState() => _CreateGoalViewState();
}

class _CreateGoalViewState extends State<CreateGoalView> {
  final controller = Get.find<GoalsController>();
  final _formKey = GlobalKey<FormState>();

  String _metalType = 'GOLD';
  String _goalType = 'amount'; // 'amount' or 'grams'
  String _goalName = '';
  String _category = 'wedding';
  double _targetAmount = 100000;
  double _targetGrams = 1;
  DateTime _deadline = DateTime.now().add(const Duration(days: 365));
  String _paymentFrequency = 'MONTHLY';
  bool _autoAllocate = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController(
    text: '100000',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _categories = [
    {'id': 'wedding', 'name': 'Wedding', 'icon': '💍'},
    {'id': 'festival', 'name': 'Festival', 'icon': '🪔'},
    {'id': 'emergency', 'name': 'Emergency', 'icon': '🛡️'},
    {'id': 'investment', 'name': 'Investment', 'icon': '📈'},
    {'id': 'gift', 'name': 'Gift', 'icon': '🎁'},
    {'id': 'custom', 'name': 'Custom', 'icon': '⭐'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGold = _metalType == 'GOLD';
    final accentColor = isGold
        ? AppColors.primaryGold
        : (isDark ? const Color(0xFF94A3B8) : Colors.blueGrey);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : accentColor,
        elevation: 0,
        title: Text(
          'Create Goal',
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
              // Metal Type Selector
              Text(
                'Metal Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(
                      'GOLD',
                      _metalType == 'GOLD',
                      accentColor,
                      isDark,
                    ),
                    _buildToggleButton(
                      'SILVER',
                      _metalType == 'SILVER',
                      isDark ? const Color(0xFF94A3B8) : Colors.blueGrey,
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
                  hintText: 'e.g., Wedding Jewellery, Diwali Gold',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.textMutedDark : null,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.cardBorder,
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
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final isSelected = _category == cat['id'];
                  return IntrinsicWidth(
                    child: InkWell(
                      onTap: () => setState(() => _category = cat['id']),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          minHeight: 80,
                        ),
                        padding: const EdgeInsets.all(8),
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
                                      ? Colors.white.withValues(alpha: 0.05)
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
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Goal Type Toggle
              Text(
                'Goal Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : null,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    _buildTypeButton(
                      'amount',
                      'By Amount (₹)',
                      _goalType == 'amount',
                      accentColor,
                      isDark,
                    ),
                    _buildTypeButton(
                      'grams',
                      'By Weight (g)',
                      _goalType == 'grams',
                      accentColor,
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Target Input
              Text(
                _goalType == 'amount' ? 'Target Amount' : 'Target Weight',
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
                  prefixText: _goalType == 'amount' ? '₹ ' : 'g ',
                  prefixStyle: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : null,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.cardBorder,
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    if (_goalType == 'amount') {
                      _targetAmount = double.tryParse(val) ?? 0;
                    } else {
                      _targetGrams = double.tryParse(val) ?? 0;
                    }
                  });
                },
                validator: (val) {
                  final d = double.tryParse(val ?? '');
                  if (d == null || d <= 0) return 'Please enter a valid amount';
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
                  if (picked != null) {
                    setState(() => _deadline = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.cardBorder,
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
              const SizedBox(height: 24),

              // Auto-Allocate
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-Allocate Purchases',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : null,
                            ),
                          ),
                          Text(
                            'Automatically add a portion of your purchases to this goal',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _autoAllocate,
                      onChanged: (val) => setState(() => _autoAllocate = val),
                      activeThumbColor: accentColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Goal Notifications
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bgDarkSecondary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.cardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Goal Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : null,
                            ),
                          ),
                        ),
                        Switch(
                          value: true, // Matching Next.js default/visual state
                          onChanged: (val) {},
                          activeThumbColor: Colors.blue,
                        ),
                      ],
                    ),
                    Text(
                      'Progress reports and milestones',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Goal Summary
              _buildSummaryCard(accentColor, isDark),
              const SizedBox(height: 32),

              // Create Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isActionLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.createGoal(
                                CreateGoalRequest(
                                  goalName: _goalName,
                                  goalCategory: _category,
                                  targetAmount: _goalType == 'amount'
                                      ? _targetAmount
                                      : 0,
                                  targetGrams: _goalType == 'grams'
                                      ? _targetGrams
                                      : 0,
                                  metalType: _metalType,
                                  paymentFrequency: _paymentFrequency,
                                  targetDate: _deadline.toIso8601String(),
                                  autoAllocate: _autoAllocate,
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
                            'Create Goal',
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

  Widget _buildToggleButton(
    String type,
    bool isSelected,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _metalType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textMutedDark : Colors.grey),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    String type,
    String label,
    bool isSelected,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _goalType = type;
            _targetController.text = type == 'amount' ? '100000' : '1';
            if (type == 'amount') {
              _targetAmount = 100000;
            } else {
              _targetGrams = 1;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textMutedDark : Colors.grey),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
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
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.cardBorder),
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

  Widget _buildSummaryCard(Color accentColor, bool isDark) {
    final daysLeft = _deadline.difference(DateTime.now()).inDays;
    final periodCount = _calculatePeriodCount(daysLeft);
    final isAmount = _goalType == 'amount';
    final installment = isAmount
        ? _targetAmount / periodCount
        : _targetGrams / periodCount;

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Text(
            'Goal Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : null,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Metal',
            _metalType == 'GOLD' ? '🥇 Gold' : '🥈 Silver',
            isDark,
          ),
          _buildSummaryRow(
            'Target',
            isAmount
                ? '₹${_targetAmount.toStringAsFixed(0)}'
                : '${_targetGrams.toStringAsFixed(3)}g',
            isDark,
          ),
          _buildSummaryRow(
            'Deadline',
            DateFormat('dd MMM yyyy').format(_deadline),
            isDark,
          ),
          _buildSummaryRow('Days to achieve', '$daysLeft days', isDark),
          Divider(height: 24, color: isDark ? Colors.white10 : null),
          _buildSummaryRow(
            '${StringUtils.capitalizeFirst(_paymentFrequency.toLowerCase())} need',
            isAmount
                ? '₹${installment.toStringAsFixed(2)}'
                : '${installment.toStringAsFixed(3)}g',
            isDark,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
              color: isBold
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePeriodCount(int daysLeft) {
    if (daysLeft <= 0) return 1;
    switch (_paymentFrequency) {
      case 'QUATERLY':
        return (daysLeft / 91).clamp(1.0, double.infinity);
      case 'YEARLY':
        return (daysLeft / 365).clamp(1.0, double.infinity);
      default:
        return (daysLeft / 30).clamp(1.0, double.infinity);
    }
  }
}
