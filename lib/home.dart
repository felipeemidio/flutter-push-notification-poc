import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    // _firebaseMessaging.getToken().then((token) => print('current token: $token'));
  }

  Future<bool> _handlePermission() async {
    const permissions = [Permission.notification, Permission.accessNotificationPolicy];

    for(Permission p in permissions) {
      PermissionStatus status = await p.status;
      if(status.isDenied) {
        status = await p.request();
      }

      if(!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<void> _onClick() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _onClick,
          child: const Text('Push Notification'),
        ),
      ),
    );
  }
}
