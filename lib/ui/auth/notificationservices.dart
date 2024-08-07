// ignore_for_file: unused_import
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:routepayapp/ui/auth/sinup_screen.dart';

class notificationservices {
  FirebaseMessaging firebasemessage = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestnotificationpermission() async {
    NotificationSettings settings = await firebasemessage.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user grant permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user grant provisional permission');
    } else {
      AppSettings.openAppSettings();
      print('user denied permissions');
    }
  }

  Future<String> getToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    return deviceToken!;
  }

  void isTokenrefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void Firebaseinit() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print('messege is');
      print(message);
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher.png');
    var iosInitializationSetting = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handlemessage(context, message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
    );

// AndroidNotificationChannel

    AndroidNotificationDetails androidNotificationletails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notify = NotificationDetails(
      android: androidNotificationletails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      //     FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notify,
      );
    });
  }

  Future<void> setupinterectmsg(BuildContext context) async {
    RemoteMessage? initialmsg =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialmsg != null) {
      handlemessage(context, initialmsg);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handlemessage(context, event);
    });
  }

  void handlemessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'abc') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
  }
}
