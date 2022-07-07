import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_poc/models/notification_data.dart';
import 'package:flutter_notification_poc/models/push_notification.dart';

class LocalPushNotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late AndroidNotificationDetails androidDetails;

  LocalPushNotificationService() {
    _initializeNotifications();
  }

  _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: androidSettings,
      ),
      onSelectNotification: _onSelectNotification,
    );
  }

  _onSelectNotification(String? payload) async {
    if(payload == null || payload.isEmpty) {
      return;
    }

    try {
      final notificationData = NotificationData.fromJson(payload);

      await handleNotificationData(notificationData);
    } catch(e) {
      debugPrint('=============================');
      debugPrint("Can't read payload $payload");
      debugPrint(e.toString());
      debugPrint('=============================');
    }
  }

  Future<void> handleNotificationData(NotificationData data) async {
    debugPrint('Received: $data');
  }

  Future<void> showMessage(PushNotification notification) async {
    androidDetails = const AndroidNotificationDetails(
      'android_notification_id_1',
      'Push notification',
      channelDescription: 'channel for tests',
      importance: Importance.high,
      priority: Priority.max,
      enableVibration: true,
    );
    
    await _localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.description,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: null,
    );
  }

  Future<void> checkForNotification() async {
    final NotificationAppLaunchDetails? details =
        await _localNotificationsPlugin.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }
  }
}