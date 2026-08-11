import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../../../../data/models/admin_models.dart';
import '../controllers/sell_requests_controller.dart';

class SellRequestsView extends GetView<SellRequestsController> {
  const SellRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToggleTabs(context),
              const SizedBox(height: 16),
              Expanded(child: _buildTableContainer(context)),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sell Requests',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            'Review and manage pending sell requests from users',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      shape: Border(
        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
    );
  }

  Widget _buildToggleTabs(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabButton(
              context,
              'Pending',
              controller.sellFilter.value == 'PENDING',
            ),
            _buildTabButton(
              context,
              'History',
              controller.sellFilter.value == 'HISTORY',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => controller.sellFilter.value = label.toUpperCase(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? theme.colorScheme.primary : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: (isActive && !isDark)
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive
                ? (isDark ? Colors.black : theme.colorScheme.onSurface)
                : theme.textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final isLoading =
            controller.isLoading.value && controller.sellRequests.isEmpty;
        final requests = controller.filteredSellRequests;

        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32,
                ),
                child: Theme(
                  data: theme.copyWith(
                    dividerColor: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                  child: DataTable(
                    headingRowHeight: 52,
                    dataRowMaxHeight: 72,
                    headingRowColor: WidgetStateProperty.all(
                      theme.colorScheme.surfaceContainer,
                    ),
                    columnSpacing: 24,
                    horizontalMargin: 24,
                    columns: _buildColumns(context),
                    rows: isLoading
                        ? List.generate(8, (_) => _buildSkeletonRow(context))
                        : (requests.isEmpty
                              ? [_buildEmptyRow(context)]
                              : requests
                                    .map((req) => _buildRow(context, req))
                                    .toList()),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  DataRow _buildSkeletonRow(BuildContext context) {
    return DataRow(
      cells: List.generate(8, (index) {
        return DataCell(
          _BlinkingSkeleton(
            width: double.infinity,
            height: 20,
            theme: Theme.of(context),
          ),
        );
      }),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    final headerStyle = GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodySmall?.color,
      letterSpacing: 0.5,
    );
    return [
      DataColumn(label: Text('USER', style: headerStyle)),
      DataColumn(label: Text('METAL', style: headerStyle)),
      DataColumn(label: Text('QUANTITY', style: headerStyle)),
      DataColumn(label: Text('AMOUNT', style: headerStyle)),
      DataColumn(label: Text('PAYMENT MODE', style: headerStyle)),
      DataColumn(label: Text('STATUS', style: headerStyle)),
      DataColumn(label: Text('DATE', style: headerStyle)),
      DataColumn(label: Text('ACTIONS', style: headerStyle), numeric: true),
    ];
  }

  DataRow _buildEmptyRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Text(
              controller.sellFilter.value == 'PENDING'
                  ? 'No pending sell requests.'
                  : 'No processed sell requests yet.',
              style: GoogleFonts.poppins(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ),
        ...List.generate(7, (_) => const DataCell(SizedBox())),
      ],
    );
  }

  DataRow _buildRow(BuildContext context, SellRequest req) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                req.userName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                req.userEmail,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        DataCell(_buildMetalBadge(context, req.metal)),
        DataCell(
          Text(
            req.quantity,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        DataCell(
          Text(
            '₹${NumberFormat('#,###').format(req.amount)}',
            style: GoogleFonts.poppins(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Text(
            req.paymentMode,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
        DataCell(_buildStatusBadge(context, req.status)),

        DataCell(
          Text(
            DateFormat('MMM d, yyyy HH:mm').format(req.date),
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showManageDialog(context, req),
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Manage',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetalBadge(BuildContext context, String metal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGold = metal.toUpperCase().contains('GOLD');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isGold
            ? (isDark
                  ? Colors.amber.withValues(alpha: 0.2)
                  : const Color(0xFFFEF9C3))
            : (isDark
                  ? Colors.grey.withValues(alpha: 0.2)
                  : theme.colorScheme.surfaceContainer),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        metal,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isGold
              ? (isDark ? Colors.amberAccent : const Color(0xFFA16207))
              : (isDark ? Colors.grey : const Color(0xFF4B5563)),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color bg;
    Color text;
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        bg = isDark
            ? Colors.green.withValues(alpha: 0.2)
            : const Color(0xFFDCFCE7);
        text = isDark ? Colors.greenAccent : const Color(0xFF15803D);
        break;
      case 'PENDING':
        bg = isDark
            ? Colors.amber.withValues(alpha: 0.2)
            : const Color(0xFFFEF9C3);
        text = isDark ? Colors.amberAccent : const Color(0xFFA16207);
        break;
      case 'REJECTED':
      case 'FAILED':
        bg = isDark
            ? Colors.red.withValues(alpha: 0.2)
            : const Color(0xFFFEE2E2);
        text = isDark ? Colors.redAccent : const Color(0xFFB91C1C);
        break;
      default:
        bg = isDark
            ? Colors.grey.withValues(alpha: 0.2)
            : theme.colorScheme.surfaceContainer;
        text = isDark ? Colors.grey : const Color(0xFF6B7280);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  void _showManageDialog(BuildContext context, SellRequest req) {
    final remarkController = TextEditingController();
    final showRejectForm = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req.userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                req.userEmail,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SELL REQUEST DETAILS',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailGrid(context, req),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (req.status == 'PENDING' && req.type == 'METAL') ...[
                          if (showRejectForm.value) ...[
                            _buildRejectForm(
                              context,
                              req,
                              remarkController,
                              showRejectForm,
                            ),
                          ] else ...[
                            _buildActionButtons(context, showRejectForm, req),
                          ],
                        ] else ...[
                          _buildCloseButton(context),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(BuildContext context, SellRequest req) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildDetailBox(
                context,
                'Metal',
                _buildMetalBadge(context, req.metal),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildDetailBox(
                context,
                'Quantity',
                Text(
                  req.quantity,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildDetailBox(
                context,
                'Amount',
                Text(
                  '₹${NumberFormat('#,###').format(req.amount)}',
                  style: GoogleFonts.poppins(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildDetailBox(
                context,
                'Status',
                _buildStatusBadge(context, req.status),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailBox(BuildContext context, String label, Widget content) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: theme.textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          content,
        ],
      ),
    );
  }

  Widget _buildRejectForm(
    BuildContext context,
    SellRequest req,
    TextEditingController remarkController,
    RxBool showRejectForm,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rejection Reason *',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: remarkController,
          maxLines: 3,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Explain why this sell request is being rejected...',
            hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => showRejectForm.value = false,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: theme.dividerColor),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.actionLoading.value
                    ? null
                    : () => controller.rejectSellRequest(
                        req.id,
                        remarkController.text,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.actionLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Confirm Reject',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    RxBool showRejectForm,
    SellRequest req,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => showRejectForm.value = true,
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(
                color: theme.colorScheme.error.withValues(alpha: 0.2),
              ),
              backgroundColor: theme.colorScheme.error.withValues(alpha: 0.05),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.actionLoading.value
                ? null
                : () => controller.approveSellRequest(req.id),
            icon: const Icon(Icons.check_rounded, size: 16),
            label: const Text('Approve'),
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
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Close',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
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
