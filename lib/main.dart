import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp2/bottomNavBar.dart';
import 'package:fyp2/map.dart';
import 'package:fyp2/stats.dart';
import 'functions/auth.dart';
import 'home.dart';
import 'login.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Big message: ${message.messageId}');
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => Login(
            auth: Auth(),
          ),
      '/home': (context) => Home(),
      '/map': (context) => const MapSample(),
      '/stats': (context) => const Stats(),
      '/bottomNav': (context) => const BottomNavBar(),
      // '/first':(context)=>
    });
  }
}

enum FormType { login, register }
