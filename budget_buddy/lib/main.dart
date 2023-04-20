import 'package:budget_buddy/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import './pages/RootApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for internet connectivity
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    await NotificationService().initNotifications();
  } else {
    // Show error message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  runApp(const MyApp());
}
// import 'package:budget_buddy/pages/RootApp.dart';
// import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// void main(List<String> args) {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget buddy',
      navigatorKey: navigatorKey,
      home: const RootApp(),
    );
  }
}

// class MyContainer extends StatefulWidget {
//   @override
//   _MyContainerState createState() => _MyContainerState();
// }

// class _MyContainerState extends State<MyContainer>
//     with SingleTickerProviderStateMixin {
//   bool _isOverlayVisible = false;
//   late AnimationController _animationController;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     _opacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleOverlayVisibility() {
//     setState(() {
//       _isOverlayVisible = !_isOverlayVisible;
//     });
//     if (_isOverlayVisible) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: GestureDetector(
//           onTap: _toggleOverlayVisibility,
//           child: Stack(
//             children: [
//               Container(
//                 width: 200,
//                 height: 200,
//                 color: Colors.blue,
//                 child: Center(
//                   child: Text(
//                     "Tap me",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _opacityAnimation,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _opacityAnimation.value,
//                     child: child,
//                   );
//                 },
//                 child: IgnorePointer(
//                   ignoring: !_isOverlayVisible,
//                   child: Container(
//                     width: 200,
//                     height: 200,
//                     color: Colors.black54,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                           icon: Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             print("Edit button pressed");
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             Icons.delete,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             print("Delete button pressed");
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
