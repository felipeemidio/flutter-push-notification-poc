import 'dart:convert';

class NotificationData {
  String? route;
  String? token;

  NotificationData({
    this.route,
    this.token,
  });

  factory NotificationData.fromMap(Map map) {
    return NotificationData(
      route: map['route'],
      token: map['token'],
    );
  }

  factory NotificationData.fromJson(String json) =>
      NotificationData.fromMap(jsonDecode(json));

  @override
  String toString() {
    return 'NotificationData{route: $route, token: $token}';
  }
}