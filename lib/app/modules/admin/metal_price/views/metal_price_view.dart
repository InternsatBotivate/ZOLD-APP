import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../controllers/metal_price_controller.dart';
import '../../../../core/widgets/shimmer_wrapper.dart';
import '../../../../data/models/rate_models.dart';

class MetalPriceView extends GetView<MetalPriceController> {
  const MetalPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.fetching.value) {
          return _buildLoadingState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAllData,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAlerts(),
                _buildLiveMarketBanner(context),
                const SizedBox(height: 24),
                _buildPlatformPrices(context),
                const SizedBox(height: 24),
                _buildRateHistory(context),
                // Extra padding for keyboard
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Manage Metal Prices',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Set buy and sell rates for Gold and Silver across the platform.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      shape: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
    );
  }

  Widget _buildAlerts() {
    return Obx(() {
      if (controller.error.isEmpty && controller.success.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          if (controller.error.isNotEmpty)
            _buildAlert(controller.error.value, isError: true),
          if (controller.success.isNotEmpty)
            _buildAlert(controller.success.value, isError: false),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildAlert(String message, {required bool isError}) {
    final color = isError ? AppColors.error : AppColors.success;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLiveMarketBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainer
            : const Color(
                0xFFEFF6FF,
              ), // Keep blue-50 for light as it matches Next.js
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? theme.dividerColor : const Color(0xFFDBEAFE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.wifi,
                    size: 16,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Market Price',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? theme.colorScheme.onSurface
                          : const Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : const Color(0xFFDBEAFE).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'GoldAPI',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? theme.colorScheme.primary
                            : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => TextButton(
                  onPressed: controller.liveLoading.value
                      ? null
                      : controller.fetchLiveMarketRates,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    controller.liveLoading.value ? 'Refreshing...' : 'Refresh',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? theme.colorScheme.primary
                          : const Color(0xFF2563EB),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.liveLoading.value) {
              return Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fetching live prices...',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              );
            }

            if (controller.liveGold.value == null ||
                controller.liveSilver.value == null) {
              return Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Could not fetch live market prices. Validation skipped.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark
                          ? theme.colorScheme.onSurface
                          : const Color(0xFF1E40AF),
                    ),
                  ),
                ],
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                return Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  children: [
                    Expanded(
                      flex: isDesktop ? 1 : 0,
                      child: _buildLivePriceCard(
                        context,
                        'Gold',
                        controller.liveGold.value!,
                        isAmber: true,
                      ),
                    ),
                    SizedBox(
                      width: isDesktop ? 12 : 0,
                      height: isDesktop ? 0 : 8,
                    ),
                    Expanded(
                      flex: isDesktop ? 1 : 0,
                      child: _buildLivePriceCard(
                        context,
                        'Silver',
                        controller.liveSilver.value!,
                        isAmber: false,
                      ),
                    ),
                  ],
                );
              },
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Platform rates cannot be set below these market prices.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivePriceCard(
    BuildContext context,
    String metal,
    LiveRate rate, {
    required bool isAmber,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.5)
        : (isAmber
              ? const Color(0xFFFEF3C7).withValues(alpha: 0.6)
              : theme.colorScheme.surfaceContainer.withValues(alpha: 0.6));
    final textColor = isDark
        ? theme.colorScheme.onSurface
        : (isAmber ? const Color(0xFF92400E) : const Color(0xFF334155));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metal,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Buy ₹${NumberFormat('#,##,###.##').format(rate.buyRate)}  ·  Sell ₹${NumberFormat('#,##,###.##').format(rate.sellRate)}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Text(
                  'per gram',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformPrices(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform Prices',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Set the buy and sell rates shown to users on the platform.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 600;
              return Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: _buildMetalCard(
                      context,
                      'Gold',
                      isAmber: true,
                      badge: '24K · 999',
                      buyController: controller.goldBuyController,
                      sellController: controller.goldSellController,
                      liveRate: controller.liveGold.value,
                    ),
                  ),
                  SizedBox(
                    width: isDesktop ? 16 : 0,
                    height: isDesktop ? 0 : 16,
                  ),
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: _buildMetalCard(
                      context,
                      'Silver',
                      isAmber: false,
                      badge: '999 Fine',
                      buyController: controller.silverBuyController,
                      sellController: controller.silverSellController,
                      liveRate: controller.liveSilver.value,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => controller.editing.value
                  ? _buildEditActions(context)
                  : _buildEditButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: controller.startEditing,
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: const Text('Edit Prices'),
      style: theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary),
        foregroundColor: WidgetStateProperty.all(theme.colorScheme.onPrimary),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        minimumSize: WidgetStateProperty.all(Size.zero),
      ),
    );
  }

  Widget _buildEditActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: controller.loading.value ? null : controller.handleSave,
          icon: controller.loading.value
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_outlined, size: 16),
          label: Text(controller.loading.value ? 'Saving...' : 'Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: Size.zero,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: controller.cancelEditing,
          icon: const Icon(Icons.close, size: 16),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).disabledColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildMetalCard(
    BuildContext context,
    String metal, {
    required bool isAmber,
    required String badge,
    required TextEditingController buyController,
    required TextEditingController sellController,
    required LiveRate? liveRate,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? theme.colorScheme.surfaceContainer.withValues(alpha: 0.3)
        : (isAmber
              ? const Color(0xFFFFFBEB)
              : theme.colorScheme.surfaceContainer);
    final borderColor = isDark
        ? theme.dividerColor
        : (isAmber
              ? const Color(0xFFFEF3C7)
              : theme.colorScheme.outline.withValues(alpha: 0.1));
    final labelColor = isDark
        ? theme.colorScheme.onSurface
        : (isAmber ? const Color(0xFF92400E) : const Color(0xFF475569));
    final valueColor = isDark
        ? theme.colorScheme.primary
        : (isAmber ? const Color(0xFF78350F) : const Color(0xFF1E293B));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metal,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : (isAmber
                                ? const Color(0xFFFEF3C7)
                                : theme.colorScheme.surfaceContainer)
                            .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: labelColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRateInput(
            context,
            'BUY RATE (₹/G)',
            buyController,
            isAmber: isAmber,
            labelColor: labelColor,
            valueColor: valueColor,
            isBuy: true,
            liveFloor: liveRate?.buyRate,
          ),
          const SizedBox(height: 16),
          _buildRateInput(
            context,
            'SELL RATE (₹/G)',
            sellController,
            isAmber: isAmber,
            labelColor: labelColor,
            valueColor: valueColor,
            isBuy: false,
            liveFloor: liveRate?.sellRate,
          ),
          Obx(() {
            if (controller.editing.value) return const SizedBox.shrink();
            final buy = double.tryParse(buyController.text) ?? 0.0;
            final sell = double.tryParse(sellController.text) ?? 0.0;
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Spread: ₹${NumberFormat('#,##,###.##').format(buy - sell)}/g',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: labelColor.withValues(alpha: 0.6),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRateInput(
    BuildContext context,
    String label,
    TextEditingController textController, {
    required bool isAmber,
    required Color labelColor,
    required Color valueColor,
    required bool isBuy,
    required double? liveFloor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: labelColor.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ),
            Obx(() {
              if (controller.editing.value &&
                  liveFloor != null &&
                  liveFloor > 0) {
                final val = double.tryParse(textController.text) ?? 0.0;
                final isBelow = val < liveFloor;
                return Text(
                  'Floor ₹${NumberFormat('#,##,###').format(liveFloor)}',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isBelow ? AppColors.error : theme.disabledColor,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 6),
        Obx(() {
          if (!controller.editing.value) {
            final val = double.tryParse(textController.text) ?? 0.0;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  isBuy ? Icons.trending_up : Icons.trending_down,
                  size: 18,
                  color: isDark
                      ? theme.colorScheme.primary
                      : (isAmber
                            ? Colors.amber.shade700
                            : const Color(0xFF64748B)),
                ),
                const SizedBox(width: 4),
                Text(
                  '₹${NumberFormat('#,##,###.##').format(val)}',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: valueColor,
                  ),
                ),
              ],
            );
          }

          final val = double.tryParse(textController.text) ?? 0.0;
          final isBelow = liveFloor != null && liveFloor > 0 && val < liveFloor;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                onChanged: (_) =>
                    controller.update(), // Trigger Obx for floor check
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? theme.colorScheme.surface : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isBelow ? AppColors.error : theme.dividerColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isBelow ? AppColors.error : theme.dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isBelow
                          ? AppColors.error
                          : theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (isBelow)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Below live market price',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildRateHistory(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate History',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              return Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: _buildHistoryTable(
                      context,
                      'Gold',
                      controller.goldHistory,
                      isAmber: true,
                    ),
                  ),
                  SizedBox(
                    width: isDesktop ? 24 : 0,
                    height: isDesktop ? 0 : 24,
                  ),
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: _buildHistoryTable(
                      context,
                      'Silver',
                      controller.silverHistory,
                      isAmber: false,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable(
    BuildContext context,
    String metal,
    RxList<RateHistory> records, {
    required bool isAmber,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark
        ? theme.colorScheme.primary
        : (isAmber ? const Color(0xFFB45309) : const Color(0xFF475569));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$metal History',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 350),
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 48,
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                ),
                columnSpacing: 12,
                horizontalMargin: 12,
                columns: [
                  _buildHeaderCell(context, 'Date'),
                  _buildHeaderCell(context, 'Buy', alignRight: true),
                  _buildHeaderCell(context, 'Sell', alignRight: true),
                  _buildHeaderCell(context, 'Status', alignCenter: true),
                ],
                rows: records.isEmpty
                    ? [
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                'No history found.',
                                style: GoogleFonts.poppins(
                                  color: theme.disabledColor,
                                ),
                              ),
                            ),
                            const DataCell(SizedBox()),
                            const DataCell(SizedBox()),
                            const DataCell(SizedBox()),
                          ],
                        ),
                      ]
                    : records
                          .map(
                            (r) =>
                                _buildHistoryRow(context, r, isAmber: isAmber),
                          )
                          .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataColumn _buildHeaderCell(
    BuildContext context,
    String label, {
    bool alignRight = false,
    bool alignCenter = false,
  }) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label.toUpperCase(),
          textAlign: alignRight
              ? TextAlign.right
              : (alignCenter ? TextAlign.center : TextAlign.left),
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodySmall?.color,
            letterSpacing: 0.5,
          ),
        ),
      ),
      numeric: alignRight,
    );
  }

  DataRow _buildHistoryRow(
    BuildContext context,
    RateHistory r, {
    required bool isAmber,
  }) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(
          Text(
            DateFormat('dd MMM, hh:mm a').format(r.createdAt),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '₹${NumberFormat('#,##,###').format(r.buyRate)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '₹${NumberFormat('#,##,###').format(r.sellRate)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
        DataCell(Center(child: _buildStatusBadge(context, r.isActive))),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7).withValues(alpha: isDark ? 0.2 : 1.0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'LIVE',
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'OLD',
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ShimmerWrapper(
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
