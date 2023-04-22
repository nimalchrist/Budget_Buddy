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
  final int userId;
  static HttpService httpService = HttpService();

  NotificationService({required this.userId});
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    print("Method called");
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);

    // Schedule notifications if the budget is not set
    bool? budgetSet = await httpService.isButgetSetted(userId);
    if (budgetSet != null) {
      if (!budgetSet) {
        print("Method called for send notifications");
        _scheduleNotifications();
      }
    }
  }

  Future _scheduleNotifications() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'budget01',
      'Budget Remainder',
      channelDescription: "Hey, set the budget for this month :)",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.periodicallyShow(
      0,
      "Set your Budget",
      "Please set your budget for this month",
      RepeatInterval.daily,
      platformChannelSpecifics,
    );
  }

  Future displayNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Budget02',
      'Manual Notification',
      channelDescription: "You don't setted budget for this month",
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'your_payload',
    );
  }
}

    // var now = DateTime.now();

    // var notification1Time = tz.TZDateTime(
    //     tz.local, now.year, now.month, now.day, 16, 30, 0); // 10:00 AM

    // var notification2Time = tz.TZDateTime(
    //     tz.local, now.year, now.month, now.day, 18, 0, 0); // 6:00 PM

    // Schedule the first notification
    // await _notificationsPlugin.zonedSchedule(
    //   0,
    //   'Set Your Budget',
    //   'Please set your budget for the month.',
    //   notification1Time,
    //   platformChannelSpecifics,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );

    // // Schedule the second notification
    // await _notificationsPlugin.zonedSchedule(
    //   1,
    //   'Set Your Budget',
    //   'Please set your budget for the month',
    //   notification2Time,
    //   platformChannelSpecifics,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );