import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/sip_calculator_controller.dart';
import '../../../core/theme/app_colors.dart';

class SipCalculatorView extends GetView<SipCalculatorController> {
  const SipCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildControls(isDark),
                  const SizedBox(height: 32),
                  _buildResultsCard(isDark),
                  const SizedBox(height: 32),
                  _buildChartSection(isDark),
                  const SizedBox(height: 32),
                  _buildPresetsSection(isDark),
                  const SizedBox(height: 32),
                  _buildCTA(isDark),
                  const SizedBox(height: 16),
                  _buildFootnote(isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? AppColors.bgDark : AppColors.sipHeaderStart,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.1),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textPrimaryDark : Colors.white,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgDark : null,
            gradient: isDark
                ? null
                : const LinearGradient(
                    colors: [AppColors.sipHeaderStart, AppColors.sipHeaderEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryGold.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calculate,
                        color: isDark ? AppColors.primaryGold : Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SIP Calculator',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Plan your gold investment',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(bool isDark) {
    return Column(
      children: [
        _buildSlider(
          label: 'Monthly Investment',
          valueObs: controller.monthlyInvestment,
          min: 500,
          max: 50000,
          step: 500,
          prefix: '₹',
          isCurrency: true,
          isDark: isDark,
        ),
        const SizedBox(height: 32),
        _buildSlider(
          label: 'Duration',
          valueObs: controller.duration,
          min: 3,
          max: 120,
          step: 3,
          suffix: ' months',
          customValue: (val) =>
              val == 120 ? '10 years' : '${val.toInt()} months',
          minLabel: '3 months',
          maxLabel: '10 years',
          isDark: isDark,
        ),
        const SizedBox(height: 32),
        _buildSlider(
          label: 'Expected Annual Return',
          valueObs: controller.expectedReturn,
          min: 5,
          max: 20,
          step: 0.5,
          suffix: '%',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required RxDouble valueObs,
    required double min,
    required double max,
    double? step,
    String prefix = '',
    String suffix = '',
    String Function(double)? customValue,
    String? minLabel,
    String? maxLabel,
    bool isCurrency = false,
    required bool isDark,
  }) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                customValue != null
                    ? customValue(valueObs.value)
                    : (isCurrency
                          ? '₹${valueObs.value.toStringAsFixed(3)}'
                          : '${valueObs.value % 1 == 0 ? valueObs.value.toInt() : valueObs.value}$suffix'),
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryGold
                      : AppColors.sipHeaderStart,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: isDark
                  ? AppColors.primaryGold
                  : AppColors.sipHeaderStart,
              inactiveTrackColor: isDark
                  ? Colors.white10
                  : Colors.grey.shade200,
              thumbColor: isDark
                  ? AppColors.primaryGold
                  : AppColors.sipHeaderStart,
              overlayColor:
                  (isDark ? AppColors.primaryGold : AppColors.sipHeaderStart)
                      .withValues(alpha: 0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: valueObs.value,
              min: min,
              max: max,
              divisions: step != null ? ((max - min) / step).round() : null,
              onChanged: (val) => valueObs.value = val,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel ?? '$prefix${min.toInt()}$suffix',
                style: TextStyle(
                  color: isDark ? AppColors.textMutedDark : Colors.grey,
                  fontSize: 11,
                ),
              ),
              Text(
                maxLabel ?? '$prefix${max.toInt()}$suffix',
                style: TextStyle(
                  color: isDark ? AppColors.textMutedDark : Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard(bool isDark) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : null,
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [AppColors.sipHeaderStart, AppColors.sipHeaderEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(24),
          border: isDark
              ? Border.all(color: Colors.white.withValues(alpha: 0.05))
              : null,
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.sipHeaderStart)
                  .withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated Returns',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            _buildResultRow(
              'Total Investment',
              '₹${controller.totalInvestment.toStringAsFixed(3)}',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Est. Returns',
              '+₹${controller.estimatedReturns.toStringAsFixed(3)}',
              isDark,
              valueColor: isDark ? AppColors.success : Colors.greenAccent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: isDark ? Colors.white10 : Colors.white24,
                height: 1,
              ),
            ),
            _buildResultRow(
              'Total Value',
              '₹${controller.totalValue.toStringAsFixed(3)}',
              isDark,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color:
                valueColor ??
                (isDark ? AppColors.textPrimaryDark : Colors.white),
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Investment Breakdown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: Obx(
              () => PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      color: isDark
                          ? const Color(0xFF8B7FA8).withValues(alpha: 0.8)
                          : const Color(0xFF8B7FA8),
                      value: controller.totalInvestment,
                      title: '',
                      radius: 20,
                    ),
                    PieChartSectionData(
                      color: isDark
                          ? AppColors.primaryGold
                          : const Color(0xFFD4AF37),
                      value: controller.estimatedReturns,
                      title: '',
                      radius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Investment', const Color(0xFF8B7FA8), isDark),
              const SizedBox(width: 24),
              _buildLegendItem('Returns', const Color(0xFFD4AF37), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Presets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _buildPresetButton('Starter Plan', 2000, 12, isDark),
            _buildPresetButton('Growth Plan', 5000, 24, isDark),
            _buildPresetButton('Premium Plan', 10000, 36, isDark),
            _buildPresetButton('Elite Plan', 20000, 60, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton(
    String label,
    double amount,
    double months,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => controller.setPreset(amount, months),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/mo • ${months >= 12 ? (months / 12).toInt() : months.toInt()} ${months >= 12 ? (months / 12 == 1 ? "year" : "years") : "months"}',
              style: TextStyle(
                color: isDark
                    ? AppColors.textMutedDark
                    : const Color(0xFF6B7280),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColors.primaryGold
              : AppColors.sipHeaderStart,
          foregroundColor: isDark ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start SIP Investment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFootnote(bool isDark) {
    return Center(
      child: Text(
        '*Returns are estimated based on historical gold price appreciation.\nActual returns may vary.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
          fontSize: 11,
          height: 1.4,
        ),
      ),
    );
  }
}
