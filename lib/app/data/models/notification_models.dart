import '../../core/utils/app_date_utils.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String type;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.type,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: AppDateUtils.parse(json['createdAt'] ?? json['created_at']),
      type: json['type'] ?? 'info',
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
    );
  }
}

class NotificationResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationResponse({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notifications: (json['notifications'] as List? ?? [])
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

class NotificationSettings {
  final bool priceAlerts;
  final bool transactionAlerts;
  final bool offersRewards;
  final bool newsUpdates;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool whatsappEnabled;

  NotificationSettings({
    this.priceAlerts = true,
    this.transactionAlerts = true,
    this.offersRewards = false,
    this.newsUpdates = false,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.whatsappEnabled = false,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      priceAlerts: json['price_alerts'] ?? true,
      transactionAlerts: json['transaction_alerts'] ?? true,
      offersRewards: json['offers_rewards'] ?? false,
      newsUpdates: json['news_updates'] ?? false,
      pushEnabled: json['push_enabled'] ?? true,
      emailEnabled: json['email_enabled'] ?? true,
      whatsappEnabled: json['whatsapp_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'price_alerts': priceAlerts,
    'transaction_alerts': transactionAlerts,
    'offers_rewards': offersRewards,
    'news_updates': newsUpdates,
    'push_enabled': pushEnabled,
    'email_enabled': emailEnabled,
    'whatsapp_enabled': whatsappEnabled,
  };

  NotificationSettings copyWith({
    bool? priceAlerts,
    bool? transactionAlerts,
    bool? offersRewards,
    bool? newsUpdates,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? whatsappEnabled,
  }) {
    return NotificationSettings(
      priceAlerts: priceAlerts ?? this.priceAlerts,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
      offersRewards: offersRewards ?? this.offersRewards,
      newsUpdates: newsUpdates ?? this.newsUpdates,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
    );
  }
}
