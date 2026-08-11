import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_date_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../controllers/gst_management_controller.dart';
import '../../../../data/models/admin_models.dart';

class GstManagementView extends GetView<GstManagementController> {
  const GstManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Obx(() {
          // Full screen loading state
          if (controller.isLoading.value && controller.gstHistory.isEmpty) {
            return _buildPageSkeleton(context);
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: theme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessages(context),
                    _buildGstConfigurationCard(context),
                    const SizedBox(height: 32),
                    _buildAuditLogCard(context),
                    // Responsive bottom spacing for keyboard
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 120
                          : 40,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
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
            'Admin Controls',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Manage system-wide GST configurations',
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

  Widget _buildMessages(BuildContext context) {
    return Column(
      children: [
        if (controller.success.isNotEmpty)
          _buildMessageBanner(
            context,
            controller.success.value,
            AppColors.success,
            AppColors.success.withValues(alpha: 0.1),
            Icons.check_circle_outline,
          ),
        if (controller.error.isNotEmpty)
          _buildMessageBanner(
            context,
            controller.error.value,
            AppColors.error,
            AppColors.error.withValues(alpha: 0.1),
            Icons.error_outline,
          ),
      ],
    );
  }

  Widget _buildMessageBanner(
    BuildContext context,
    String message,
    Color textColor,
    Color bgColor,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? textColor.withValues(alpha: 0.9) : textColor,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: isDark ? textColor.withValues(alpha: 0.9) : textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGstConfigurationCard(BuildContext context) {
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
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GST Configuration',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildRateDisplay(context),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (!controller.isEditing.value) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: controller.startEditing,
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Update GST'),
          style: theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF6366F1) : theme.colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.isSaving.value ? null : controller.updateGST,
            icon: controller.isSaving.value
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              controller.isSaving.value ? 'Saving...' : 'Save Changes',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.isSaving.value
                ? null
                : controller.cancelEditing,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.textTheme.bodyMedium?.color,
              side: BorderSide(color: theme.dividerColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRateDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                  const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                ]
              : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GLOBAL GST RATE',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          if (controller.isEditing.value)
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: controller.gstController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        hintText: '0.0',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '%',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text(
                  '${controller.currentGstRate.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '%',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text(
            'This rate applies to all metal and coin purchases across the platform.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark
                  ? const Color(0xFF60A5FA).withValues(alpha: 0.8)
                  : const Color(0xFF2563EB),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'GST Audit Log',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          _buildHistoryContent(context),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.gstHistory.isEmpty) {
      return _buildEmptyState(context);
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
          ),
          child: DataTable(
            headingRowHeight: 52,
            dataRowMaxHeight: 64,
            headingRowColor: WidgetStateProperty.all(
              theme.brightness == Brightness.dark
                  ? const Color(0xFF1F2937)
                  : theme.colorScheme.surfaceContainer,
            ),
            columnSpacing: 24,
            horizontalMargin: 24,
            columns: [
              _buildHeaderCell(context, 'Date & Time'),
              _buildHeaderCell(context, 'Rate', alignRight: true),
              _buildHeaderCell(context, 'Updated By'),
              _buildHeaderCell(context, 'Status', alignCenter: true),
            ],
            rows: controller.gstHistory.map((entry) {
              return _buildHistoryRow(context, entry);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No history records found.',
            style: GoogleFonts.poppins(
              color: Theme.of(context).disabledColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _buildHeaderCell(
    BuildContext context,
    String label, {
    bool alignRight = false,
    bool alignCenter = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return DataColumn(
      label: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark
              ? const Color(0xFF9CA3AF)
              : theme.textTheme.bodySmall?.color,
          letterSpacing: 0.5,
        ),
      ),
      numeric: alignRight,
    );
  }

  DataRow _buildHistoryRow(BuildContext context, GstConfig entry) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return DataRow(
      cells: [
        DataCell(
          Text(
            _formatDate(entry.createdAt),
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            '${entry.rate}%',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? const Color(0xFF60A5FA)
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                alignment: Alignment.center,
                child: Text(
                  (entry.adminName ?? 'A').isNotEmpty
                      ? (entry.adminName ?? 'A').substring(0, 1).toUpperCase()
                      : 'A',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.adminName ?? 'Admin',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        DataCell(Center(child: _buildStatusBadge(context, entry.isActive))),
      ],
    );
  }

  String _formatDate(dynamic createdAt) {
    return AppDateUtils.formatDateTime(AppDateUtils.parse(createdAt));
  }

  Widget _buildStatusBadge(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF34D399)
                    : const Color(0xFF16A34A),
              ),
            ),
            Text(
              'CURRENT',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFF34D399)
                    : const Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF374151)
            : theme.dividerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'PREVIOUS',
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark
              ? const Color(0xFF9CA3AF)
              : theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  // --- SKELETON UI ---

  Widget _buildPageSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGstConfigSkeleton(context),
          const SizedBox(height: 32),
          _buildAuditLogSkeleton(context),
        ],
      ),
    );
  }

  Widget _buildGstConfigSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BlinkingSkeleton(width: 150, height: 24, theme: theme),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BlinkingSkeleton(width: 100, height: 12, theme: theme),
                const SizedBox(height: 16),
                _BlinkingSkeleton(width: 80, height: 48, theme: theme),
                const SizedBox(height: 12),
                _BlinkingSkeleton(width: 250, height: 12, theme: theme),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _BlinkingSkeleton(width: double.infinity, height: 48, theme: theme),
        ],
      ),
    );
  }

  Widget _buildAuditLogSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: _BlinkingSkeleton(width: 120, height: 20, theme: theme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BlinkingSkeleton(width: 120, height: 16, theme: theme),
                      _BlinkingSkeleton(width: 40, height: 16, theme: theme),
                      _BlinkingSkeleton(width: 80, height: 16, theme: theme),
                      _BlinkingSkeleton(width: 60, height: 20, theme: theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final ThemeData theme;

  const _BlinkingSkeleton({
    required this.width,
    required this.height,
    required this.theme,
  });

  @override
  State<_BlinkingSkeleton> createState() => _BlinkingSkeletonState();
}

class _BlinkingSkeletonState extends State<_BlinkingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
