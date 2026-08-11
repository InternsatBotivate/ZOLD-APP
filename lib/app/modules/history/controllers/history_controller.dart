import 'package:get/get.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/models/wallet_models.dart';
import '../../../core/utils/snackbar_utils.dart';

class HistoryController extends GetxController {
  final WalletRepository _walletRepository;
  HistoryController({required WalletRepository walletRepository})
    : _walletRepository = walletRepository;

  final isLoading = false.obs;
  final transactions = <Transaction>[].obs;
  final filteredTransactions = <Transaction>[].obs;

  final searchQuery = ''.obs;
  final typeFilter = 'all'.obs; // all, BUY, SELL, COIN
  final metalFilter = 'all'.obs; // all, GOLD, SILVER
  final dateFilter = 'all'.obs; // all, today, week, month

  late Worker _filterWorker;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();

    _filterWorker = everAll([
      searchQuery,
      typeFilter,
      metalFilter,
      dateFilter,
    ], (_) => applyFilters());
  }

  @override
  void onClose() {
    _filterWorker.dispose();
    super.onClose();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final response = await _walletRepository.getTransactions();
      transactions.value = response.data ?? [];
      applyFilters();
    } catch (e) {
      SnackbarUtils.showError('Failed to fetch transactions');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var filtered = transactions.toList();

    if (typeFilter.value != 'all') {
      if (typeFilter.value == 'COIN') {
        filtered = filtered.where((t) => t.kind == 'COIN').toList();
      } else if (typeFilter.value == 'GIFT') {
        filtered = filtered
            .where(
              (t) =>
                  t.type == 'GIFT' ||
                  t.type == 'GIFT_SENT' ||
                  t.type == 'GIFT_RECEIVED',
            )
            .toList();
      } else {
        filtered = filtered
            .where((t) => t.type == typeFilter.value && t.kind == 'METAL')
            .toList();
      }
    }

    if (metalFilter.value != 'all') {
      if (metalFilter.value == 'COIN') {
        filtered = filtered.where((t) => t.kind == 'COIN').toList();
      } else {
        filtered = filtered.where((t) => t.metal == metalFilter.value).toList();
      }
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((t) {
        final title = getTransactionTitle(t).toLowerCase();
        return title.contains(query);
      }).toList();
    }

    if (dateFilter.value != 'all') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      filtered = filtered.where((t) {
        final txDate = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
        
        if (dateFilter.value == 'today') {
          return txDate.isAtSameMomentAs(today);
        }
        if (dateFilter.value == 'week') {
          final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final monday = DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
          return txDate.isAfter(monday.subtract(const Duration(seconds: 1)));
        }
        if (dateFilter.value == 'month') {
          final firstDayOfMonth = DateTime(now.year, now.month, 1);
          return txDate.isAfter(firstDayOfMonth.subtract(const Duration(seconds: 1)));
        }
        return true;
      }).toList();
    }

    filteredTransactions.value = filtered;
  }

  String getTransactionTitle(Transaction tx) {
    final m = tx.metal == 'SILVER' ? 'Silver' : 'Gold';
    if (tx.type == 'GIFT' ||
        tx.type == 'GIFT_SENT' ||
        tx.type == 'GIFT_RECEIVED') {
      return 'Gifted $m';
    }
    if (tx.kind == 'COIN') return '${tx.quantity}× ${tx.coinGrams}g $m Coin';
    if (tx.type == 'BUY' || tx.type == 'BUY_WITH_RUPEES') return 'Bought $m';
    return 'Sold $m';
  }

  void clearFilters() {
    searchQuery.value = '';
    typeFilter.value = 'all';
    metalFilter.value = 'all';
    dateFilter.value = 'all';
  }
}
