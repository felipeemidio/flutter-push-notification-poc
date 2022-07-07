import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notification_poc/models/notification_data.dart';
import 'package:flutter_notification_poc/models/push_notification.dart';
import 'package:flutter_notification_poc/services/local_push_notification_service.dart';

class PushNotificationService {
  final LocalPushNotificationService localPushNotificationService;

  const PushNotificationService({required this.localPushNotificationService});

  Future<void> initialize() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    await _getDeviceToken();
    _listenMessages();
  }

  //esRKEPcQRe2bamtRZtFuUw:APA91bH5U4Iw0mChNosqe1m1KNC4oOuvYUkEsdDY_sX_FKSWYaD-1xtL2XWVwYPrYirPa8-P42C4yR5YKwtY-noJs05ovcDXZENb-6QC9ffQAdbBLr36jBM68v5E23dSWH1Bp50jk9Th
  Future<String> _getDeviceToken() async {
    final String? token = await FirebaseMessaging.instance.getToken();

    print('=============================');
    print('TOKEN: $token');
    print('=============================');

    return token ?? '';
  }

  _listenMessages() {
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePayload);
  }

  Future<void> _onMessage(RemoteMessage remoteMessage) async {
    final RemoteNotification? notification = remoteMessage.notification;
    final AndroidNotification? androidNotification = notification?.android;

    if(androidNotification != null) {
      final pushNotification = PushNotification(
        id: androidNotification.hashCode,
        title: notification!.title,
        description: notification.body,
        payload: remoteMessage.data,
      );
      await localPushNotificationService.showMessage(pushNotification);
    }
  }

  _handlePayload(RemoteMessage remoteMessage) async {
    final data = NotificationData.fromMap(remoteMessage.data);
    localPushNotificationService.handleNotificationData(data);
  }
}