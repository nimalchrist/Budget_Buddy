import 'package:budget_buddy/services/NotificationService.dart';
import 'package:flutter/material.dart';
import './pages/RootApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget buddy',
      home: RootApp(),
    );
  }
}
