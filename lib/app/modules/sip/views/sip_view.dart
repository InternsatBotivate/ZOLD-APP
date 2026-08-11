import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/sip_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/payment_processing_overlay.dart';
import '../../../data/models/sip_models.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/snackbar_utils.dart';

class SipView extends GetView<SipController> {
  const SipView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: controller.fetchData,
            color: AppColors.primaryGold,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(isDark),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActiveSipsSection(isDark),
                        const SizedBox(height: 32),
                        Obx(() {
                          if (controller.isAdmin) {
                            return Column(
                              children: [
                                _buildAdminCreateButton(isDark),
                                const SizedBox(height: 32),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        _buildAvailablePlansSection(isDark),
                        const SizedBox(height: 32),
                        _buildBenefitsBanner(isDark),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payment Processing Overlay
          Obx(
            () => PaymentProcessingOverlay(
              isVisible: controller.isProcessing.value,
              statusText: controller.paymentStatus.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? AppColors.bgDark : AppColors.sipBgLight,
      centerTitle: true,
      title: Text(
        'SIP Plans',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF3D2F0A),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF3D2F0A),
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.sipCalculator),
          icon: Icon(
            Icons.calculate_outlined,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF3D2F0A),
          ),
          tooltip: 'SIP Calculator',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgDark : null,
            gradient: isDark
                ? null
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.sipBgLight,
                      AppColors.sipBgLight,
                      Colors.white,
                    ],
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Systematic Investment Plans for Gold & Silver',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF6B7280),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.bgDarkSecondary : null,
                    gradient: isDark
                        ? null
                        : const RadialGradient(
                            colors: [
                              AppColors.sipRadialStart,
                              AppColors.sipRadialMid,
                              AppColors.sipRadialEnd,
                            ],
                            center: Alignment.center,
                            radius: 1.2,
                          ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.sipBorder.withValues(alpha: 0.7),
                      width: 2,
                    ),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(
                                0xFFB8960C,
                              ).withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Available Plans',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.primaryGold
                              : const Color(0xFF5A4A1A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Shimmer.fromColors(
                            baseColor: isDark
                                ? Colors.grey[800]!
                                : Colors.grey.shade300,
                            highlightColor: isDark
                                ? Colors.grey[700]!
                                : Colors.grey.shade100,
                            child: Container(
                              height: 30,
                              width: 40,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }
                        return Text(
                          '${controller.sipPlans.length}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF3D2F0A),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCreateButton(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : null,
        gradient: isDark
            ? null
            : const RadialGradient(
                colors: [
                  AppColors.sipRadialStart,
                  AppColors.sipRadialMid,
                  AppColors.sipRadialEnd,
                ],
                center: Alignment.center,
                radius: 1.5,
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.sipBorder.withValues(alpha: 0.7),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: _showCreateSipPlanDialog,
        icon: Icon(
          Icons.add,
          color: isDark ? AppColors.primaryGold : const Color(0xFF5A4A1A),
        ),
        label: const Text(
          'Create New SIP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark
              ? AppColors.primaryGold
              : const Color(0xFF5A4A1A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSipsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR ACTIVE SIPS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.userSipsLoading.value) {
            return _buildActiveSipsShimmer(isDark);
          }
          if (controller.userSips.isEmpty) {
            return _buildEmptyActiveSips(isDark);
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.userSips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final sip = controller.userSips[index];
              return _buildActiveSipCard(sip, isDark);
            },
          );
        }),
      ],
    );
  }

  Widget _buildEmptyActiveSips(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: isDark
                ? AppColors.textMutedDark.withValues(alpha: 0.3)
                : Colors.grey.shade300,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            'No active SIPs yet.',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Subscribe to a plan below to get started.',
            style: TextStyle(
              color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSipCard(Sip sip, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFF3F4F6),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB8960C), Color(0xFFD4AF37)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                                : const Color(0xFFFDF7DE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.savings,
                            color: Color(0xFFB8960C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sip.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF1F2937),
                              ),
                            ),
                            Text(
                              '${StringUtils.capitalizeFirst(sip.metal)} · ${StringUtils.capitalizeFirst(sip.type)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF065F46).withValues(alpha: 0.2)
                            : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildSipStat(
                          'Per Month',
                          '₹${sip.investmentAmount.toStringAsFixed(2)}',
                          isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildSipStat(
                          'Next SIP',
                          _getNextDeductionDate(sip.dayOfMonth),
                          isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildSipStat(
                          'Total Invested',
                          '₹${sip.totalInvestedAmount.toStringAsFixed(2)}',
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.primaryGold : null,
                          gradient: isDark
                              ? null
                              : const RadialGradient(
                                  colors: [
                                    AppColors.sipRadialStart,
                                    AppColors.sipRadialMid,
                                    AppColors.sipRadialEnd,
                                  ],
                                  center: Alignment.center,
                                  radius: 2.0,
                                ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? Colors.transparent
                                : AppColors.sipBorder.withValues(alpha: 0.7),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () => _showTopupDialog(sip),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: isDark
                                ? Colors.black
                                : const Color(0xFF5A4A1A),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Top-up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showModifyDialog(sip),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF4B5563),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Edit Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSipStat(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailablePlansSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AVAILABLE PLANS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return _buildAvailablePlansShimmer(isDark);
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.sipPlans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final plan = controller.sipPlans[index];
              return _buildPlanCard(plan, isDark);
            },
          );
        }),
      ],
    );
  }

  Widget _buildPlanCard(SipPlan plan, bool isDark) {
    final isSubscribed = controller.userSips.any((s) => s.sipId == plan.id);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFF3F4F6),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                          : const Color(0xFFFDF7DE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.savings,
                      color: Color(0xFFB8960C),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '${StringUtils.capitalizeFirst(plan.metal)} · ${StringUtils.capitalizeFirst(plan.type)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Min. Investment',
                    style: TextStyle(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${plan.minInvestment.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!isSubscribed)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryGold : null,
                gradient: isDark
                    ? null
                    : const RadialGradient(
                        colors: [
                          AppColors.sipRadialStart,
                          AppColors.sipRadialMid,
                          AppColors.sipRadialEnd,
                        ],
                        center: Alignment.center,
                        radius: 2.0,
                      ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.transparent
                      : AppColors.sipBorder.withValues(alpha: 0.7),
                ),
              ),
              child: ElevatedButton(
                onPressed: () => _showSubscribeDialog(plan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: isDark
                      ? Colors.black
                      : const Color(0xFF5A4A1A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Subscribe to this SIP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF064E3B).withValues(alpha: 0.2)
                    : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitsBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : const Color(0xFFFDF7DE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFF6E7B8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFFB8960C), size: 24),
              const SizedBox(width: 12),
              Text(
                'Benefits of Gold SIP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF3D2F0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            'Rupee cost averaging reduces market timing risk',
            isDark,
          ),
          _buildBenefitItem('Disciplined approach to gold investment', isDark),
          _buildBenefitItem('Start with as low as ₹100 per day', isDark),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFB8960C),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF5A4A1A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextDeductionDate(int dayOfMonth) {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, dayOfMonth);
    if (now.day >= dayOfMonth) {
      target = DateTime(now.year, now.month + 1, dayOfMonth);
    }
    return DateFormat('dd MMM yyyy').format(target);
  }

  void _showSubscribeDialog(SipPlan plan) {
    Get.bottomSheet(
      SubscribeSipSheet(plan: plan, controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showTopupDialog(Sip sip) {
    Get.bottomSheet(
      TopupSipSheet(sip: sip, controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showModifyDialog(Sip sip) {
    Get.bottomSheet(
      ModifySipSheet(sip: sip, controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showCreateSipPlanDialog() {
    Get.bottomSheet(
      CreateSipPlanSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildActiveSipsShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey.shade100,
      child: Column(
        children: List.generate(
          1,
          (index) => Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailablePlansShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey.shade100,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            height: 140,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widgets & Classes

void _showDayPicker(RxInt selectedDay) {
  final isDark = Get.isDarkMode;
  Get.dialog(
    Dialog(
      backgroundColor: isDark ? AppColors.bgDarkSecondary : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pick a Day',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : null,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.textSecondaryDark : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'SIP will be deducted on this day every month (1–28)',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMutedDark
                    : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 28,
              itemBuilder: (context, index) {
                final day = index + 1;
                return Obx(() {
                  final isSelected = selectedDay.value == day;
                  return GestureDetector(
                    onTap: () {
                      selectedDay.value = day;
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFB8960C)
                            : (isDark
                                  ? Colors.white10
                                  : const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF374151)),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDaySelector(RxInt selectedDay) {
  final isDark = Get.isDarkMode;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Day of SIP',
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.textMutedDark : const Color(0xFF9CA3AF),
        ),
      ),
      Obx(
        () => InkWell(
          onTap: () => _showDayPicker(selectedDay),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDay.value}${_getOrdinalSuffix(selectedDay.value)} of every month',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF1F2937),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark
                      ? AppColors.textMutedDark
                      : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildNoteBox(
  TextEditingController amountController,
  RxInt selectedDay,
) {
  final isDark = Get.isDarkMode;
  return ListenableBuilder(
    listenable: amountController,
    builder: (context, child) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF451A03).withValues(alpha: 0.1)
              : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? const Color(0xFFB45309).withValues(alpha: 0.2)
                : const Color(0xFFFEF3C7),
          ),
        ),
        child: Obx(() {
          final day = selectedDay.value;
          final suffix = _getOrdinalSuffix(day);
          final amount = amountController.text.isEmpty
              ? '0.00'
              : amountController.text;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFFB45309),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Starting from the $day$suffix of every month, ₹$amount will be automatically deducted towards this SIP until you cancel it.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFB45309),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    },
  );
}

String _getOrdinalSuffix(int n) {
  if (n >= 11 && n <= 13) return 'th';
  switch (n % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

Widget _buildMetalOption(String metal, RxString selected) {
  final isDark = Get.isDarkMode;
  final isSelected = selected.value == metal;
  return Expanded(
    child: GestureDetector(
      onTap: () => selected.value = metal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? const Color(0xFFB8960C).withValues(alpha: 0.1)
                    : const Color(0xFFFDF7DE))
              : (isDark ? AppColors.bgDarkSecondary : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB8960C)
                : (isDark ? Colors.white10 : Colors.grey.shade200),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          StringUtils.capitalizeFirst(metal),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? (isDark ? AppColors.primaryGold : const Color(0xFF5A4A1A))
                : (isDark ? AppColors.textSecondaryDark : Colors.grey),
          ),
        ),
      ),
    ),
  );
}

Widget _buildFormSheet({
  required String title,
  required String subtitle,
  required List<Widget> content,
  required VoidCallback onConfirm,
  required String confirmText,
}) {
  final isDark = Get.isDarkMode;
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
    ),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.textSecondaryDark : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...content,
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryGold : null,
                  gradient: isDark
                      ? null
                      : const RadialGradient(
                          colors: [
                            AppColors.sipRadialStart,
                            AppColors.sipRadialMid,
                            AppColors.sipRadialEnd,
                          ],
                          center: Alignment.center,
                          radius: 2.0,
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.transparent
                        : AppColors.sipBorder.withValues(alpha: 0.7),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: isDark
                        ? Colors.black
                        : const Color(0xFF5A4A1A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSummaryRow(String label, String value) {
  final isDark = Get.isDarkMode;
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : Colors.grey,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? AppColors.textPrimaryDark : null,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInputField({
  required String label,
  required TextEditingController controller,
  String? placeholder,
  TextInputType? keyboardType,
}) {
  final isDark = Get.isDarkMode;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : null,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? AppColors.textPrimaryDark : null),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: isDark ? AppColors.textMutedDark : Colors.grey.shade400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: isDark ? AppColors.bgDarkSecondary : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB8960C)),
          ),
        ),
      ),
    ],
  );
}

class SubscribeSipSheet extends StatefulWidget {
  final SipPlan plan;
  final SipController controller;
  const SubscribeSipSheet({
    super.key,
    required this.plan,
    required this.controller,
  });

  @override
  State<SubscribeSipSheet> createState() => _SubscribeSipSheetState();
}

class _SubscribeSipSheetState extends State<SubscribeSipSheet> {
  late final TextEditingController amountController;
  final selectedDay = 1.obs;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.plan.minInvestment.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormSheet(
      title: 'Subscribe to SIP',
      subtitle: widget.plan.name,
      content: [
        _buildSummaryRow(
          'Metal',
          StringUtils.capitalizeFirst(widget.plan.metal),
        ),
        _buildSummaryRow(
          'Min. Investment',
          '₹${widget.plan.minInvestment.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Investment Amount (₹)',
          controller: amountController,
          placeholder: 'e.g. 500',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDaySelector(selectedDay),
        const SizedBox(height: 20),
        _buildNoteBox(amountController, selectedDay),
      ],
      onConfirm: () {
        final amt =
            double.tryParse(amountController.text) ?? widget.plan.minInvestment;
        if (amt < widget.plan.minInvestment) {
          SnackbarUtils.showError(
            'Amount must be at least ₹${widget.plan.minInvestment.toStringAsFixed(2)}',
          );
          return;
        }
        Get.back();
        widget.controller.subscribeToSip(widget.plan, amt, selectedDay.value);
      },
      confirmText: 'Confirm & Pay',
    );
  }
}

class TopupSipSheet extends StatefulWidget {
  final Sip sip;
  final SipController controller;
  const TopupSipSheet({super.key, required this.sip, required this.controller});

  @override
  State<TopupSipSheet> createState() => _TopupSipSheetState();
}

class _TopupSipSheetState extends State<TopupSipSheet> {
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: '500');
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormSheet(
      title: 'Top-up Investment',
      subtitle: widget.sip.name,
      content: [
        _buildSummaryRow(
          'Metal',
          StringUtils.capitalizeFirst(widget.sip.metal),
        ),
        _buildSummaryRow(
          'Recurring SIP amount',
          '₹${widget.sip.investmentAmount.toStringAsFixed(2)}/mo',
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Top-up Amount (₹)',
          controller: amountController,
          placeholder: 'e.g. 1000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        const Text(
          'This is a one-time charge. Your monthly SIP amount stays unchanged.',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
      onConfirm: () {
        final amt = double.tryParse(amountController.text) ?? 0;
        if (amt <= 0) {
          SnackbarUtils.showError('Please enter a valid amount');
          return;
        }
        Get.back();
        widget.controller.topupSip(widget.sip.sipId, widget.sip.metal, amt);
      },
      confirmText: 'Pay Now',
    );
  }
}

class ModifySipSheet extends StatefulWidget {
  final Sip sip;
  final SipController controller;
  const ModifySipSheet({
    super.key,
    required this.sip,
    required this.controller,
  });

  @override
  State<ModifySipSheet> createState() => _ModifySipSheetState();
}

class _ModifySipSheetState extends State<ModifySipSheet> {
  late final TextEditingController amountController;
  late final RxInt selectedDay;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.sip.investmentAmount.toStringAsFixed(0),
    );
    selectedDay = widget.sip.dayOfMonth.obs;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormSheet(
      title: 'Modify SIP',
      subtitle: widget.sip.name,
      content: [
        _buildInputField(
          label: 'Monthly Amount (₹)',
          controller: amountController,
          placeholder: 'e.g. 500',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDaySelector(selectedDay),
      ],
      onConfirm: () {
        final amt =
            double.tryParse(amountController.text) ??
            widget.sip.investmentAmount;
        Get.back();
        widget.controller.modifySip(widget.sip.sipId, amt, selectedDay.value);
      },
      confirmText: 'Save Changes',
    );
  }
}

class CreateSipPlanSheet extends StatefulWidget {
  final SipController controller;
  const CreateSipPlanSheet({super.key, required this.controller});

  @override
  State<CreateSipPlanSheet> createState() => _CreateSipPlanSheetState();
}

class _CreateSipPlanSheetState extends State<CreateSipPlanSheet> {
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  final selectedMetal = 'GOLD'.obs;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormSheet(
      title: 'Create New SIP Plan',
      subtitle: 'Add a new plan for users',
      content: [
        _buildInputField(
          label: 'Plan Name',
          controller: nameController,
          placeholder: 'e.g. Monthly Gold Savings',
        ),
        const SizedBox(height: 20),
        const Text(
          'Metal',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              _buildMetalOption('GOLD', selectedMetal),
              const SizedBox(width: 12),
              _buildMetalOption('SILVER', selectedMetal),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'Minimum Investment (₹)',
          controller: amountController,
          placeholder: 'e.g. 100',
          keyboardType: TextInputType.number,
        ),
      ],
      onConfirm: () {
        final name = nameController.text.trim();
        final amt = double.tryParse(amountController.text) ?? 0;
        if (name.isEmpty || amt <= 0) {
          SnackbarUtils.showError('Please fill all fields correctly');
          return;
        }
        Get.back();
        widget.controller.createSipPlan(
          CreateSipRequest(
            name: name,
            type: 'REGULAR',
            metal: selectedMetal.value,
            minInvestment: amt,
          ),
        );
      },
      confirmText: 'Create SIP',
    );
  }
}
