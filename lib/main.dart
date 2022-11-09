import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notificationexample/CloudNotificationExample.dart';
import 'package:notificationexample/GoogleAdvertisementExample.dart';
import 'package:notificationexample/NotificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      'resource://drawable/notification1',
      [
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High
        ),
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'badge_channel',
            channelName: 'Badge indicator notifications',
            channelDescription: 'Notification channel to activate badge indicator',
            channelShowBadge: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.yellow),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
      ],
      debug: true
  );
  FirebaseMessaging.instance.getToken().then((token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 123,
        title: notification.title,
        channelKey:  "basic_channel",
        body: notification.body,
      ),
    );


  });
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:  NotificationPage(),
    );
  }
}

