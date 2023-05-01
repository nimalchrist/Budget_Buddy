import 'dart:async';

import 'package:budget_buddy/SplashScreenPage.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true;
  Future<int?> get checkLogined async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");
    if (userId == null) {
      return 0;
    }
    return userId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _showSplashScreen = false;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget buddy',
      home: _showSplashScreen
          ? const SplashPage()
          : FutureBuilder(
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
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
