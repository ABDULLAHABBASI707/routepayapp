// ignore: unused_import
import 'dart:ffi';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:routepayapp/ui/auth/notificationservices.dart';
import 'package:routepayapp/ui/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_backgroundmsg);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _backgroundmsg(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  notificationservices notifiser = notificationservices();

  @override
  void initState() {
    super.initState();
    notifiser.requestnotificationpermission();
    getUserCurrentLocation();

    // Add FirebaseMessaging.onMessage listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming message while the app is in the foreground
      // You can trigger the display of a local notification here
      _handleForegroundMessage(message);
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Implement logic to handle incoming message while the app is in the foreground
    print('Foreground Notification Received:');
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');

    // Trigger the display of a local notification
    notifiser.showNotification(message);

    // You can also perform additional actions based on the message content
    // For example, navigate to a specific screen based on the message payload
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'];
      if (screen == 'home') {
        // Navigate to the home screen
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => MyStatefulWidget()),
        // );
      } else if (screen == 'profile') {
        // Navigate to the profile screen
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => ()),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
