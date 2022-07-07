import 'package:flutter/material.dart';
import 'package:flutter_notification_poc/home.dart';
import 'package:flutter_notification_poc/services/local_push_notification_service.dart';
import 'package:flutter_notification_poc/services/push_notification_service.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {

  @override
  void initState() {
    super.initState();
    _initializePushNotifications();
  }

  _initializePushNotifications() async {
    await Provider.of<PushNotificationService>(context, listen: false).initialize();
    await Provider.of<LocalPushNotificationService>(context, listen: false).checkForNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App with Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
