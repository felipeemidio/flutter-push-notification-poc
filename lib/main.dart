import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_poc/main_widget.dart';
import 'package:flutter_notification_poc/services/local_push_notification_service.dart';
import 'package:flutter_notification_poc/services/push_notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<LocalPushNotificationService>(
          create: (_) => LocalPushNotificationService(),
        ),
        Provider<PushNotificationService>(
          create: (context) => PushNotificationService(
            localPushNotificationService: context.read<LocalPushNotificationService>(),
          ),
        ),
      ],
      child: const MainWidget(),
    ),
  );
}

