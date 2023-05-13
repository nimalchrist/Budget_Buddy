import 'dart:async';
import 'dart:math';
import 'package:budget_buddy/http_Operations/httpServices.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final int userId;
  static HttpService httpService = HttpService();
  List<String> randomBodies = [
    "Hey? set your budget",
    "Neenga inum budget set panala?",
    "Budget set pana...Itha click panunga",
    "Budget set panunga Bro/Sis"
  ];

  NotificationService({required this.userId});
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    print("Notification service initialized");
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    // Request notification permissions
    await _requestNotificationPermissions();

    // Schedule notifications if the budget is not set
    bool? budgetSet = await httpService.isButgetSetted(userId);
    if (budgetSet != null) {
      if (!budgetSet) {
        print("Notifications are scheduled");
        _showFirstScheduledNotification(
          payload: "Budget_Buddy",
        );
        _showSecondScheduledNotification(
          payload: "Budget_buddy",
        );
      } else {
        await _notificationsPlugin.cancelAll();
      }
    }
  }

  Future _requestNotificationPermissions() async {
    var status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Notification permissions not granted');
    }
  }

  Future _showFirstScheduledNotification({
    int id = 0,
    String? payload,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Budget02',
      'Manual Notification',
      channelDescription: "You don't set budget for this month",
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    Random random = Random();
    var body = randomBodies[random.nextInt(randomBodies.length)];

    await _notificationsPlugin.zonedSchedule(
      id,
      "Set BUDGET Now",
      body,
      _scheduleDaily(
        const Time(9, 30),
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future _showSecondScheduledNotification({
    int id = 1,
    String? payload,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Budget03',
      'Manual Notification',
      channelDescription: "You don't set budget for this month",
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    Random random = Random();
    var body = randomBodies[random.nextInt(randomBodies.length)];

    await _notificationsPlugin.zonedSchedule(
      id,
      "Set BUDGET Now",
      body,
      _scheduleDaily(
        const Time(18, 30),
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(
            const Duration(days: 1),
          )
        : scheduleDate;
  }
}
