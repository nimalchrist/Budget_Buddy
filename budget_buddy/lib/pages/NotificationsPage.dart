// import 'package:budget_buddy/pages/SetBudgetPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationsPage extends StatefulWidget {
//   int authorisedUser;
//   NotificationsPage({Key? key, required this.authorisedUser});

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState(userId: authorisedUser);
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   int userId;
//   _NotificationsPageState({required this.userId});
//   final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
//   List<PendingNotificationRequest>? notifications;

//   @override
//   void initState() {
//     super.initState();
//     _loadNotifications();
//   }

//   Future<void> _loadNotifications() async {
//     final List<PendingNotificationRequest> pendingNotifications =
//         await notificationsPlugin.pendingNotificationRequests();
//     setState(() {
//       notifications = pendingNotifications;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.1,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Notifications",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Center(
//         child: notifications == null
//             ? const CircularProgressIndicator()
//             : notifications!.isEmpty
//                 ? const Text(
//                     "No notifications scheduled",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black54,
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: notifications!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final PendingNotificationRequest notification = notifications![index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SetBudgetPage(authorisedUser: 1000),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: const Icon(
//                                 Icons.notifications,
//                                 size: 25,
//                                 color: Colors.pink,
//                               ),
//                               title: Text(notification.title ?? ""),
//                               subtitle: Text(notification.body ?? ""),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () async {
//                                   await notificationsPlugin.cancel(notification.id);
//                                   _loadNotifications();
//                                 },
//                               ),
//                             ),
//                             Center(
//                               child: Container(
//                                 width: double.infinity,
//                                 height: 1,
//                                 decoration: const BoxDecoration(color: Colors.black38),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }
// }

import 'package:budget_buddy/pages/SetBudgetPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationsPage extends StatefulWidget {
  int authorisedUser;
  NotificationsPage({Key? key, required this.authorisedUser}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState(userId: authorisedUser);
}

class _NotificationsPageState extends State<NotificationsPage> {
  int userId;
  _NotificationsPageState({required this.userId});
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<NotificationData>? _notifications = [];

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
    );

    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    List<ActiveNotification> deliveredNotifications =
        await _notificationsPlugin.getActiveNotifications();
    List<PendingNotificationRequest> pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    List<NotificationData>? notifications = [];

    for (var pending in pendingNotifications) {
      notifications.add(
        NotificationData(
            id: pending.id, title: pending.title, body: pending.body, payload: pending.payload),
      );
      print(notifications.length);
    }

    for (var delivered in deliveredNotifications) {
      notifications.add(
        NotificationData(
          id: delivered.id,
          title: delivered.title,
          body: delivered.body,
          payload: delivered.payload,
        ),
      );
      print(notifications.length);
    }

    setState(() {
      _notifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _notifications != null && _notifications!.isNotEmpty
          ? ListView.builder(
              itemCount: _notifications!.length,
              itemBuilder: (BuildContext context, int index) {
                var notification = _notifications![index];
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.pink,
                      ),
                      title: Text(notification.title!),
                      subtitle: Text(notification.body ?? ""),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetBudgetPage(authorisedUser: userId),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 1,
                        decoration: const BoxDecoration(color: Colors.black38),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Text(
                "No Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
    );
  }
}

class NotificationData {
  int id;
  String? title;
  String? body;
  String? payload;

  NotificationData({required this.id, this.title, this.body, this.payload});
}
