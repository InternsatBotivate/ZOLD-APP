import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../data/models/notification_models.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/services/socket_service.dart';
import '../../../routes/app_routes.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _notificationRepository;

  NotificationsController(this._notificationRepository);

  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;
  final unreadCount = 0.obs;
  final filter = 'all'.obs;

  final _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _initSocketListener();
  }

  Function(dynamic)? _notificationListener;

  void _initSocketListener() {
    _notificationListener = (data) {
      if (data != null) {
        final n = NotificationModel.fromJson(data);
        notifications.insert(0, n);
        unreadCount.value++;
      }
    };
    SocketService.to.on('notification', _notificationListener!);
  }

  @override
  void onClose() {
    if (_notificationListener != null) {
      SocketService.to.off('notification', _notificationListener);
    }
    super.onClose();
  }

  Future<void> fetchNotifications() async {
    if (notifications.isEmpty) isLoading.value = true;
    try {
      final response = await _notificationRepository.getNotifications();
      if (response.success && response.data != null) {
        notifications.assignAll(response.data!.notifications);
        unreadCount.value = response.data!.unreadCount;
      }
    } catch (e) {
      _logger.e('Error fetching notifications: $e');
      SnackbarUtils.showError('Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  List<NotificationModel> get filteredNotifications {
    final currentFilter = filter.value.toLowerCase();
    if (currentFilter == 'all') return notifications;
    if (currentFilter == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }

    return notifications.where((n) {
      final type = n.type.toLowerCase();
      if (currentFilter == 'transaction') {
        return type == 'transaction' ||
            type == 'gift_received' ||
            type == 'metal_purchase' ||
            type == 'sip_investment';
      }
      return type == currentFilter;
    }).toList();
  }

  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  void onNotificationTap(NotificationModel n) {
    if (!n.isRead) markAsRead(n.id);

    // Handle navigation based on type or data
    if (n.type.toLowerCase() == 'gift_received' && n.data?['giftId'] != null) {
      // Navigate to gift detail if route exists
      // Get.toNamed(Routes.giftDetail, arguments: n.data?['giftId']);
    } else if (n.type.toLowerCase() == 'transaction') {
      Get.toNamed(Routes.history);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final response = await _notificationRepository.markAsRead(id);
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
          _updateUnreadCount();
        }
      }
    } catch (e) {
      _logger.e('Error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationRepository.markAllRead();
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
        _updateUnreadCount();
      }
    } catch (e) {
      _logger.e('Error marking all as read: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      final response = await _notificationRepository.clearAll();
      if (response.success) {
        notifications.clear();
        _updateUnreadCount();
      }
    } catch (e) {
      _logger.e('Error clearing all: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    // Note: Backend might not have a delete one endpoint yet
    // For now, we only remove from local list to keep UI responsive
    notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
  }
}
