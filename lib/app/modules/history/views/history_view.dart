import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_date_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../controllers/history_controller.dart';
import '../../../data/models/wallet_models.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'All your gold, silver and coin purchases',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.transactions.isEmpty) {
          return _buildSkeletonLoader(context);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchTransactions,
          color: AppColors.primaryGold,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildFilters(context),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return SliverToBoxAdapter(
                    child: _buildSkeletonLoaderContent(context),
                  );
                }
                if (controller.filteredTransactions.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTransactionItem(
                            context,
                            controller.filteredTransactions[index],
                          ),
                        );
                      },
                      childCount: controller.filteredTransactions.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => controller.searchQuery.value = val,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDropdown<String>(
                context,
                value: controller.typeFilter,
                options: {
                  'all': 'All Type',
                  'BUY': 'Buy',
                  'SELL': 'Sell',
                  'COIN': 'Coin',
                  'GIFT': 'Gift',
                  'TRANSFER': 'Transfer',
                  'REWARD': 'Reward',
                },
              ),
              const SizedBox(width: 8),
              _buildDropdown<String>(
                context,
                value: controller.metalFilter,
                options: {
                  'all': 'All Metal',
                  'GOLD': 'Gold',
                  'SILVER': 'Silver',
                  'COIN': 'Coin',
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeFilters(context),
        ],
      ),
    );
  }

  Widget _buildTimeFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            _buildTimeChip(context, 'All', 'all'),
            const SizedBox(width: 8),
            _buildTimeChip(context, 'Today', 'today'),
            const SizedBox(width: 8),
            _buildTimeChip(context, 'This Week', 'week'),
            const SizedBox(width: 8),
            _buildTimeChip(context, 'This Month', 'month'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(BuildContext context, String label, String value) {
    final isSelected = controller.dateFilter.value == value;
    return GestureDetector(
      onTap: () => controller.dateFilter.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Theme.of(context).dividerColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context, {
    required Rx<T> value,
    required Map<T, String> options,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value.value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              items: options.entries.map((entry) {
                return DropdownMenuItem<T>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  value.value = newValue;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction tx) {
    final isBuy = tx.type == 'BUY' || tx.type == 'BUY_WITH_RUPEES';
    final isCoin = tx.kind == 'COIN';
    final isGold = tx.metal == 'GOLD';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCoin
                  ? Colors.amber.withValues(alpha: 0.1)
                  : isBuy
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCoin
                  ? Icons.stars
                  : isBuy
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: isCoin
                  ? Colors.amber[700]
                  : isBuy
                  ? Colors.green[700]
                  : Colors.red[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.getTransactionTitle(tx),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isGold ? Colors.amber : Colors.blueGrey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  AppDateUtils.formatDateTime(tx.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isBuy ? '+' : '-'}${tx.grams.toStringAsFixed(3)}g',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isBuy ? Colors.green[700] : Colors.red[700],
                ),
              ),
              Text(
                '₹${NumberFormat('#,##,##0.00').format(tx.finalAmount)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusBadge(context, tx.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color;
    Color bgColor;

    switch (status) {
      case 'COMPLETED':
        color = Colors.green[700]!;
        bgColor = Colors.green.withValues(alpha: 0.1);
        break;
      case 'PENDING':
        color = Colors.orange[700]!;
        bgColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case 'REJECTED':
        color = Colors.red[700]!;
        bgColor = Colors.red.withValues(alpha: 0.1);
        break;
      default:
        color = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
        bgColor = Theme.of(context).dividerColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          if (controller.typeFilter.value != 'all' ||
              controller.metalFilter.value != 'all' ||
              controller.searchQuery.value.isNotEmpty)
            TextButton(
              onPressed: controller.clearFilters,
              child: const Text(
                'Clear Filters',
                style: TextStyle(color: AppColors.primaryGold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return SingleChildScrollView(
      child: _buildSkeletonLoaderContent(context),
    );
  }

  Widget _buildSkeletonLoaderContent(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSkeletonItem(context),
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 14, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 10, color: Colors.white),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 60, height: 14, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 40, height: 10, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
