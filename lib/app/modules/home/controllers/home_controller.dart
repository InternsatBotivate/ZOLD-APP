import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/socket_service.dart';
import '../../../data/models/rate_models.dart';
import '../../../data/models/coin_models.dart';
import '../../../data/models/notification_models.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/base_response.dart';
import '../../../data/models/wallet_models.dart';
import '../../../core/utils/app_logger.dart';
import 'package:intl/intl.dart';
import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/india.dart';

class HomeController extends GetxController {
  final RateRepository rateRepository;
  final WalletRepository walletRepository;
  final CoinRepository coinRepository;
  final NotificationRepository notificationRepository;
  final AuthRepository authRepository;

  HomeController({
    required this.rateRepository,
    required this.walletRepository,
    required this.coinRepository,
    required this.notificationRepository,
    required this.authRepository,
  });

  // State Variables
  final isLoading = true.obs;
  final goldBuyPrice = 0.0.obs;
  final goldSellPrice = 0.0.obs;
  final silverBuyPrice = 0.0.obs;
  final silverSellPrice = 0.0.obs;
  final priceChange = 0.0.obs;

  final userGoldGrams = 0.0.obs;
  final userSilverGrams = 0.0.obs;
  final goldPortfolioValue = 0.0.obs;
  final silverPortfolioValue = 0.0.obs;
  final profitLoss = 0.0.obs;

  final coinInventory = <CoinInventory>[].obs;
  final notifications = <NotificationModel>[].obs;
  final unreadNotificationsCount = 0.obs;

  // Auspicious Days
  final nextAuspiciousDayName = 'Loading...'.obs;
  final nextAuspiciousDayDate = ''.obs;

  final chartTimeframe = '1D'.obs;
  final priceHistory = <RateHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController Initialized');
    refreshData();
    _initSocketListeners();
  }

  @override
  void onClose() {
    SocketService.to.off('goldPriceUpdate');
    SocketService.to.off('silverPriceUpdate');
    SocketService.to.off('notification');
    super.onClose();
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchRates(),
        fetchWalletData(),
        fetchCoinInventory(),
        fetchNotifications(),
        fetchPriceHistory(),
        calculateNextAuspiciousDay(),
      ]).timeout(const Duration(seconds: 20));
    } catch (e) {
      AppLogger.e('HomeController.refreshData failure', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRates() async {
    try {
      final response = await rateRepository.getCurrentRates().timeout(const Duration(seconds: 5));
      if (response.success && response.data != null) {
        goldBuyPrice.value = response.data!.gold.buyRate;
        goldSellPrice.value = response.data!.gold.sellRate;
        silverBuyPrice.value = response.data!.silver.buyRate;
        silverSellPrice.value = response.data!.silver.sellRate;
      }
    } catch (e) {
      AppLogger.e('Error fetching rates', e);
    }
  }

  Future<void> fetchWalletData() async {
    try {
      final results = await Future.wait([
        walletRepository.getBalance(),
        walletRepository.getStats(),
      ]).timeout(const Duration(seconds: 10));

      final balanceResponse = results[0] as BaseResponse<WalletBalance>;
      if (balanceResponse.success && balanceResponse.data != null) {
        final d = balanceResponse.data!;
        userGoldGrams.value = d.goldGrams;
        userSilverGrams.value = d.silverGrams;
        goldPortfolioValue.value = d.goldValuation + d.goldCoinValuation;
        silverPortfolioValue.value = d.silverValuation + d.silverCoinValuation;
      }

      final statsResponse = results[1] as BaseResponse<WalletStats>;
      if (statsResponse.success && statsResponse.data != null) {
        profitLoss.value = statsResponse.data!.profitLoss;
      }
    } catch (e) {
      AppLogger.e('Error fetching wallet data', e);
    }
  }

  Future<void> fetchCoinInventory() async {
    try {
      final response = await coinRepository.getUserInventory().timeout(const Duration(seconds: 10));
      if (response.success && response.data != null) {
        coinInventory.value = response.data!
            .where((c) => c.quantity > 0)
            .toList();
      }
    } catch (e) {
      AppLogger.e('Error fetching coin inventory', e);
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await notificationRepository.getNotifications().timeout(const Duration(seconds: 10));
      if (response.success && response.data != null) {
        notifications.assignAll(response.data!.notifications);
        unreadNotificationsCount.value = response.data!.unreadCount;
      }
    } catch (e) {
      AppLogger.e('Error fetching notifications', e);
    }
  }

  Future<void> fetchPriceHistory() async {
    try {
      int limit;
      switch (chartTimeframe.value) {
        case '1D':
          limit = 24;
          break;
        case '1W':
          limit = 100;
          break;
        case '1M':
          limit = 300;
          break;
        case '1Y':
          limit = 1000;
          break;
        default:
          limit = 20;
      }

      final response = await rateRepository.getRateHistory(
        'GOLD',
        limit: limit,
      ).timeout(const Duration(seconds: 10));
      
      if (response.success &&
          response.data != null &&
          response.data!.isNotEmpty) {
        priceHistory.value = response.data!.reversed.toList();

        if (priceHistory.length >= 2) {
          final current = priceHistory.last.buyRate;
          final previous = priceHistory[priceHistory.length - 2].buyRate;
          if (previous > 0) {
            priceChange.value = double.parse(
              ((current - previous) / previous * 100).toStringAsFixed(2),
            );
          }
        }
      } else {
        priceHistory.clear();
      }
    } catch (e) {
      AppLogger.e('Error fetching price history', e);
    }
  }

  void _initSocketListeners() {
    SocketService.to.on('goldPriceUpdate', (data) {
      if (data != null && data is Map) {
        final buy = data['buyRate'];
        final sell = data['sellRate'];
        if (buy is num) goldBuyPrice.value = buy.toDouble();
        if (sell is num) goldSellPrice.value = sell.toDouble();
      }
    });

    SocketService.to.on('silverPriceUpdate', (data) {
      if (data != null && data is Map) {
        final buy = data['buyRate'];
        final sell = data['sellRate'];
        if (buy is num) silverBuyPrice.value = buy.toDouble();
        if (sell is num) silverSellPrice.value = sell.toDouble();
      }
    });

    SocketService.to.on('notification', (data) {
      if (data != null && data is Map<String, dynamic>) {
        try {
          final n = NotificationModel.fromJson(data);
          notifications.insert(0, n);
          unreadNotificationsCount.value++;
        } catch (e) {
          AppLogger.e('Error parsing socket notification', e);
        }
      }
    });
  }

  void setChartTimeframe(String timeframe) {
    chartTimeframe.value = timeframe;
    fetchPriceHistory();
  }

  Future<void> markAllNotificationsRead() async {
    try {
      final response = await notificationRepository.markAllRead();
      if (response.success) {
        notifications.assignAll(
          notifications
              .map(
                (n) => NotificationModel(
                  id: n.id,
                  title: n.title,
                  body: n.body,
                  isRead: true,
                  createdAt: n.createdAt,
                  type: n.type,
                  data: n.data,
                ),
              )
              .toList(),
        );
        unreadNotificationsCount.value = 0;
      }
    } catch (e) {
      AppLogger.e('Error marking all read', e);
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      final response = await notificationRepository.markAsRead(id);
      if (response.success) {
        final index = notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          final n = notifications[index];
          notifications[index] = NotificationModel(
            id: n.id,
            title: n.title,
            body: n.body,
            isRead: true,
            createdAt: n.createdAt,
            type: n.type,
            data: n.data,
          );
          unreadNotificationsCount.value = notifications
              .where((n) => !n.isRead)
              .length;
        }
      }
    } catch (e) {
      AppLogger.e('Error marking read', e);
    }
  }

  void onBuyGold() => Get.toNamed(
    Routes.buySell,
    parameters: {'metal': 'gold', 'action': 'buy'},
  );
  void onSellGold() => Get.toNamed(
    Routes.buySell,
    parameters: {'metal': 'gold', 'action': 'sell'},
  );
  void onBuySilver() => Get.toNamed(
    Routes.buySell,
    parameters: {'metal': 'silver', 'action': 'buy'},
  );
  void onSellSilver() => Get.toNamed(
    Routes.buySell,
    parameters: {'metal': 'silver', 'action': 'sell'},
  );
  void onBuyCoins() => Get.toNamed(Routes.goldCoins);
  void onOpenSIP() => Get.toNamed(Routes.sip);
  void onOpenSIPCalculator() => Get.toNamed(Routes.sipCalculator);
  void onOpenGiftGold() => Get.toNamed(Routes.giftGold);
  void onOpenReferral() {
    // Disabled for now as per user request
    // Get.toNamed(Routes.referral);
  }
  void onOpenGoals() => Get.toNamed(Routes.goals);
  void onOpenWalletDetails() => Get.toNamed(Routes.walletDetails);
  void onOpenAuspiciousDays() => Get.toNamed(Routes.auspiciousDays);

  Future<void> calculateNextAuspiciousDay() async {
    try {
      final panchang = Panchang([registerIndia]);
      final now = DateTime.now();
      final city = City.mumbai;

      FestivalDef? nextDef;
      DateTime? nextDate;

      // Limit search to major festivals
      for (final def in festivals) {
        // Check current year
        final dates = panchang.recurringDates(def, now.year, city);
        for (final fDate in dates) {
          if (fDate.date.isAfter(now)) {
            final currentNext = nextDate;
            if (currentNext == null || fDate.date.isBefore(currentNext)) {
              nextDate = fDate.date;
              nextDef = def;
            }
          }
        }
      }

      // If none found in current year, check next year
      if (nextDate == null) {
        for (final def in festivals) {
          final dates = panchang.recurringDates(def, now.year + 1, city);
          for (final fDate in dates) {
            final currentNext = nextDate;
            if (currentNext == null || fDate.date.isBefore(currentNext)) {
              nextDate = fDate.date;
              nextDef = def;
            }
          }
        }
      }

      if (nextDef != null && nextDate != null) {
        nextAuspiciousDayName.value = nextDef.name;
        nextAuspiciousDayDate.value =
            '${nextDate.day} ${DateFormat('MMM').format(nextDate)}';
      } else {
        nextAuspiciousDayName.value = 'Next Muhurat';
        nextAuspiciousDayDate.value = 'Coming Soon';
      }
    } catch (e) {
      AppLogger.e('Error calculating auspicious day', e);
      nextAuspiciousDayName.value = 'Check Muhurat';
    }
  }

  List<CoinInventory> get goldCoins =>
      coinInventory.where((c) => c.metal == 'GOLD').toList();
  List<CoinInventory> get silverCoins =>
      coinInventory.where((c) => c.metal == 'SILVER').toList();
}
