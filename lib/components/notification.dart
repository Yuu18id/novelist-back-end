import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  final FlutterLocalNotificationsPlugin localNoti =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings =
        InitializationSettings(android: androSettings, iOS: iosSettings);

    await localNoti.initialize(initSettings);
  }

  void showLocalNoti(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download',
      'Notifikasi',
      channelDescription: 'Download Berhasil',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platDetails =
        NotificationDetails(android: androidDetails);

    await localNoti.show(10, title, body, platDetails, payload: 'Not present');
  }
}
