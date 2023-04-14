// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future initialize() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await _notificationsPlugin.initialize(initializationSettings);
//   }

//   static Future displayNotification({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await _notificationsPlugin.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'your_payload',
//     );
//   }
// }

import 'dart:async';
import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static HttpService httpService = HttpService();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    tz.initializeTimeZones();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);

    // Schedule notifications if the budget is not set
    bool? budgetSet = await httpService.isButgetSetted(1000);
    if (budgetSet != null) {
      if (!budgetSet) {
        _scheduleNotifications();
      }
    }
  }

  static Future _scheduleNotifications() async {
    var now = DateTime.now();
    var notification1Time = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, 10, 0, 0); // 10:00 AM
    var notification2Time = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, 18, 0, 0); // 6:00 PM

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'budget_notifications',
      'Budget Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the first notification
    await _notificationsPlugin.zonedSchedule(
        0,
        'Set Your Budget',
        'Please set your budget for the month.',
        notification1Time,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    // Schedule the second notification
    await _notificationsPlugin.zonedSchedule(
        1,
        'Set Your Budget',
        'Please set your budget for the day.',
        notification2Time,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future displayNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: "You Not yet setted budget for this month",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'your_payload',
    );
  }
}
