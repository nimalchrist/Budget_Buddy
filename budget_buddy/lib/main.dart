import 'package:budget_buddy/pages/LoginPage.dart';
import 'package:budget_buddy/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/RootApp.dart';

void main() async {
  runApp(const MyApp());
}

void setupApp(int userId) async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService(userId: userId)
      .initNotifications(); // or any other services that you need to initialize
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<int?> get checkLogined async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");
    if (userId == null) {
      return 0;
    }
    return userId;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget buddy',
      home: FutureBuilder(
        future: checkLogined,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != 0) {
              dynamic userId = snapshot.data;
              setupApp(userId);
              return RootApp(authorisedUser: userId);
            } else {
              return const LoginPage();
            }
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 31, 21, 87),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
