import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:olada/ui/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification notification = message.notification;
  AndroidNotification android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: android?.smallIcon,
          color: AppColors.PrimaryColor,
          importance: Importance.max,
          playSound: true,
        ),
      ),
      payload: 'Default_Sound',
    );
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.',
  playSound: true,
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  List subscribed = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("user") != null) {
      dynamic userFromPeference = jsonDecode(prefs.getString("user"));

      if (userFromPeference != null) {
        firestore
            .collection('users')
            .doc(userFromPeference['id'])
            .get()
            .then((currentUser)async  {
                      dynamic merchant;
                      if (currentUser.data()['merchant'] != null) {
                        await firestore
                            .collection('merchants')
                            .doc(currentUser.data()['merchant'])
                            .get()
                            .then((document) {
                          merchant = document.data();
                          merchant['id'] = document.id;
                        });
                      }
          prefs.setString(
              "user",
              jsonEncode({
                'id': currentUser.id,
                'name': currentUser.data()['name'],
                'username': currentUser.data()['username'],
                'bio': currentUser.data()['bio'],
                'phone': currentUser.data()['phone'],
                'email': currentUser.data()['email'],
                'picture': currentUser.data()['picture'],
                            'merchant': merchant != null ? merchant : null,
                'followers': currentUser.data()['followers'],
                'following': currentUser.data()['following'],
                'posts': currentUser.data()['posts'],
                'fcmToken': currentUser.data()['fcmToken']
              }));
        });
      }
    }
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();

    requestPermission();

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@drawable/logo');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android?.smallIcon,
              color: AppColors.PrimaryColor,
              importance: Importance.max,
              playSound: true,
            ),
          ),
          payload: 'Default_Sound',
        );
      }
    });

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..userInteractions = false
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..dismissOnTap = false;
    return MaterialApp(
      home: FlutterEasyLoading(
      child: App()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.PrimaryColor),
    );
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = token;
      prefs.setString("token", token);
    });
  }

  getTopics() async {
    setState(() {
      subscribed = subscribed;
    });
  }
}
