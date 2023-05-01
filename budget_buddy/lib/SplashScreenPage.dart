import 'package:budget_buddy/theme/Colors.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                'assets/images/splash_bg.png',
                width: 370,
                height: 390,
              ),
              const SizedBox(
                height: 160,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                decoration: const BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Text(
                  "Budget Buddy",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
