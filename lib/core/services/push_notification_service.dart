import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    /// 1️⃣ Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined permission');
    }

    /// مهم لظهور الاشعارات في foreground على iOS
    await _fcm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    /// 2️⃣ Local Notifications initialization
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,

      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification clicked payload: ${response.payload}");
        _handleNotificationClick(response.payload);
      },
    );

    /// Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.max,
    );

    if (Platform.isAndroid) {
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    /// 3️⃣ Get FCM Token
    try {
      String? token = await _fcm.getToken();

      print("======= FCM TOKEN =======");
      print(token);
      print("=========================");

      /// TODO
      /// send token to backend
    } catch (e) {
      print("Error getting token $e");
    }

    /// Token refresh
    _fcm.onTokenRefresh.listen((token) {
      print("Token refreshed: $token");

      /// TODO
      /// update token in backend
    });

    /// 4️⃣ Configure listeners
    _configureListeners(channel);

    _isInitialized = true;
  }

  void _configureListeners(AndroidNotificationChannel channel) {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received");
      print(message.data);

      if (message.notification != null) {
        _showForegroundNotification(message, channel);
      }
    });

    /// App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification");
      _handleNotificationClick(jsonEncode(message.data));
    });

    /// App opened from terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("App opened from terminated state");
        _handleNotificationClick(jsonEncode(message.data));
      }
    });
  }

  Future<void> _showForegroundNotification(
    RemoteMessage message,
    AndroidNotificationChannel channel,
  ) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleNotificationClick(String? payload) {
    if (payload == null) return;

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      print("Notification data: $data");

      /// handle navigation based on notification_type
      final String? type = data['notification_type']?.toString();

      if (type == '1') {
        // Example: Navigate to a specific screen
        // navigatorKey.currentState?.pushNamed(RoutesName.home);
      }
    } catch (e) {
      print("Error handling notification click: $e");
    }
  }
}
