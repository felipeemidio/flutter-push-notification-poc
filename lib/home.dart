import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _debugLabelString = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    // final accepted = await OneSignal.shared.userProvidedPrivacyConsent();
    // if(!accepted) {
    //   bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    //   OneSignal.shared.setRequiresUserPrivacyConsent(requiresConsent);
    //   print('available: $requiresConsent');
    // }
    //
    //
    // //Remove this method to stop OneSignal Debugging
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    //
    // OneSignal.shared.setAppId("1a23a100-adec-4257-8af6-b62cc1ae3d96");
    _firebaseMessaging.getToken().then((token) => print('current token: $token'));
    _handlePermission();
    OneSignal.shared.setRequiresUserPrivacyConsent(true);
    OneSignal.shared.setAppId("1a23a100-adec-4257-8af6-b62cc1ae3d96");
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.disablePush(false);

    bool userProvidedPrivacyConsent = await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
    OneSignal.shared.consentGranted(true);

  }

  Future<bool> _handlePermission() async {
    const permissions = [Permission.notification, Permission.accessNotificationPolicy];

    for(Permission p in permissions) {
      PermissionStatus status = await p.status;
      if(status.isDenied) {
        status = await p.request();
      }

      if(!status.isGranted) {

        print('Permission $p is $status');
        return false;
      }
    }
    return true;
  }

  Future<void> _onClick() async {
    try {
      if(await _handlePermission()) {
        var imgUrlString =
            "https://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

        var deviceState = await OneSignal.shared.getDeviceState();
        var notification = OSCreateNotification(
            playerIds: [deviceState!.userId!],
            content: "this is a test from OneSignal's Flutter SDK",
            heading: "Test Notification",
            iosAttachments: {"id1": imgUrlString},
            bigPicture: imgUrlString,
            buttons: [
              OSActionButton(text: "test1", id: "id1"),
              OSActionButton(text: "test2", id: "id2")
            ]);
        final json = await OneSignal.shared.postNotification(notification);
        print('json: $json');
      } else {
        print('User has no permission!');
      }
    } catch (e) {
      print('Error exception!');
    }

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
