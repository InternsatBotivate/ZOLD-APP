import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../../../../data/models/auth_models.dart';
import '../../../../data/models/admin_models.dart';
import '../controllers/user_management_controller.dart';

class UserManagementView extends GetView<UserManagementController> {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(context),
              const SizedBox(height: 16),
              Expanded(child: _buildUserTableContainer(context)),
            ],
          ),
        ),
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
            'User Management',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Manage system users and verify accounts',
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

  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: TextField(
                  onChanged: (value) => controller.searchTerm.value = value,
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              if (!isDesktop) const SizedBox(height: 12),
              if (isDesktop) const SizedBox(width: 12),
              Container(
                width: isDesktop ? 160 : double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.filterRole.value,
                      isExpanded: true,
                      dropdownColor: theme.colorScheme.surface,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                      items: ['ALL', 'ADMIN', 'USER'].map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role == 'ALL' ? 'All Roles' : role),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          controller.filterRole.value = value!,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserTableContainer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: isDark
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
      child: Obx(() {
        final isLoading =
            controller.isLoading.value && controller.users.isEmpty;
        final filteredUsers = controller.filteredUsers;

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
                child: DataTable(
                  headingRowHeight: 52,
                  dataRowMaxHeight: 72,
                  headingRowColor: WidgetStateProperty.all(
                    theme.colorScheme.surfaceContainer,
                  ),
                  columnSpacing: 24,
                  horizontalMargin: 24,
                  columns: [
                    _buildHeaderCell(context, 'User'),
                    _buildHeaderCell(context, 'Phone'),
                    _buildHeaderCell(context, 'Gold (g)'),
                    _buildHeaderCell(context, 'Silver (g)'),
                    _buildHeaderCell(context, 'Role'),
                    _buildHeaderCell(context, 'Status'),
                    _buildHeaderCell(context, 'Actions', alignRight: true),
                  ],
                  rows: isLoading
                      ? List.generate(8, (_) => _buildSkeletonRow(context))
                      : (filteredUsers.isEmpty
                            ? [
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 48,
                                        ),
                                        child: Text(
                                          'No users found.',
                                          style: GoogleFonts.poppins(
                                            color: theme.disabledColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...List.generate(
                                      6,
                                      (_) => const DataCell(SizedBox()),
                                    ),
                                  ],
                                ),
                              ]
                            : filteredUsers
                                  .map((user) => _buildUserRow(context, user))
                                  .toList()),
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
      cells: List.generate(7, (index) {
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

  DataColumn _buildHeaderCell(
    BuildContext context,
    String label, {
    bool alignRight = false,
  }) {
    return DataColumn(
      label: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodySmall?.color,
          letterSpacing: 0.5,
        ),
      ),
      numeric: alignRight,
    );
  }

  DataRow _buildUserRow(BuildContext context, User user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainer,
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    user.profilePictureUrl != null &&
                        user.profilePictureUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: user.profilePictureUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 18,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 18,
                        color: theme.textTheme.bodySmall?.color,
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            user.phone ?? '—',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
        DataCell(
          Text(
            (user.inventory?.goldBalance ?? 0.0).toStringAsFixed(3),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? theme.colorScheme.primary
                  : const Color(0xFFD97706),
            ),
          ),
        ),
        DataCell(
          Text(
            (user.inventory?.silverBalance ?? 0.0).toStringAsFixed(3),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
        DataCell(_buildRoleBadge(context, user.role)),
        DataCell(_buildStatusBadge(context, user.isVerified)),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showUserDetails(context, user),
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
                'View',
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

  Widget _buildRoleBadge(BuildContext context, String role) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin = role == 'ADMIN';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isAdmin
            ? (isDark
                  ? Colors.purple.withValues(alpha: 0.2)
                  : const Color(0xFFF3E8FF))
            : (isDark
                  ? Colors.blue.withValues(alpha: 0.2)
                  : const Color(0xFFDBEAFE)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isAdmin
              ? (isDark ? Colors.purpleAccent : const Color(0xFF7E22CE))
              : (isDark ? Colors.blueAccent : const Color(0xFF1D4ED8)),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isVerified) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isVerified
            ? (isDark
                  ? Colors.green.withValues(alpha: 0.2)
                  : const Color(0xFFDCFCE7))
            : (isDark
                  ? Colors.amber.withValues(alpha: 0.2)
                  : const Color(0xFFFEF9C3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isVerified ? 'Verified' : 'Pending',
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isVerified
              ? (isDark ? Colors.greenAccent : const Color(0xFF15803D))
              : (isDark ? Colors.amberAccent : const Color(0xFFA16207)),
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    controller.selectUser(user);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: UserDetailDialogContent(user: user),
        ),
      ),
    );
  }
}

class UserDetailDialogContent extends GetView<UserManagementController> {
  final User user;
  const UserDetailDialogContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildTabs(context),
        Expanded(
          child: Obx(() {
            if (controller.loadingTransactions.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            return _buildTabContent(context);
          }),
        ),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            _buildTabItem(
              context,
              'Metals',
              controller.modalTab.value == 'metals',
            ),
            _buildTabItem(
              context,
              'Coins',
              controller.modalTab.value == 'coins',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String label, bool isActive) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () => controller.modalTab.value = label.toLowerCase(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            '$label Transactions',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final history = controller.transactionHistory.value;
    if (history == null) return const SizedBox();

    if (controller.modalTab.value == 'metals') {
      return _buildMetalTransactions(context, history.metalTransactions);
    } else {
      return _buildCoinTransactions(context, history.coinTransactions);
    }
  }

  Widget _buildMetalTransactions(
    BuildContext context,
    List<MetalTransaction> transactions,
  ) {
    if (transactions.isEmpty) return _buildEmptyTransactions();
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        return _buildTransactionCard(
          context,
          type: t.transactionType,
          date: t.createdAt,
          title: '${t.metalType} • ${t.metalGrams}g',
          amount: t.finalAmount,
          status: t.status,
          subtitle:
              'Rate: ₹${NumberFormat('#,##,###').format(t.ratePerGram)}/g',
        );
      },
    );
  }

  Widget _buildCoinTransactions(
    BuildContext context,
    List<CoinTransaction> transactions,
  ) {
    if (transactions.isEmpty) return _buildEmptyTransactions();
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        return _buildTransactionCard(
          context,
          type: 'COIN BUY',
          date: t.createdAt,
          title: '${t.metal} • ${t.weight}g (${t.quantity}pc)',
          amount: t.finalAmount,
          status: t.status,
          subtitle: t.paymentMode,
        );
      },
    );
  }

  Widget _buildTransactionCard(
    BuildContext context, {
    required String type,
    required DateTime date,
    required String title,
    required double amount,
    required String status,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isBuy = type == 'BUY' || type == 'COIN BUY';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isBuy
                      ? (isDark
                            ? Colors.green.withValues(alpha: 0.2)
                            : const Color(0xFFDCFCE7))
                      : (isDark
                            ? Colors.orange.withValues(alpha: 0.2)
                            : const Color(0xFFFFEDD5)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isBuy
                        ? (isDark
                              ? Colors.greenAccent
                              : const Color(0xFF15803D))
                        : (isDark
                              ? Colors.orangeAccent
                              : const Color(0xFFC2410C)),
                  ),
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₹${NumberFormat('#,##,###').format(amount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(context, status),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return isDark ? Colors.greenAccent : AppColors.success;
      case 'FAILED':
        return isDark ? Colors.redAccent : AppColors.error;
      case 'PENDING':
        return isDark ? Colors.amberAccent : AppColors.warning;
      default:
        return Theme.of(context).disabledColor;
    }
  }

  Widget _buildEmptyTransactions() {
    return Center(
      child: Text(
        'No transactions found.',
        style: GoogleFonts.poppins(color: Colors.grey),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Get.back(),
          style: theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary),
            foregroundColor: WidgetStateProperty.all(
              theme.colorScheme.onPrimary,
            ),
          ),
          child: Text(
            'Close',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
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
