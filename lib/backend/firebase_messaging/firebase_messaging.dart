import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/auth/firebase_auth/auth_util.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> displayLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // replace with your channel ID
      'your_channel_name', // replace with your channel name
      channelDescription: 'your_channel_description', // replace with your channel description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000), // notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // optional, use it to identify the notification or handle it when the user taps on it
    );
  }

  static Future init() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for push notifications');

      // Generate FCM token
      final token = await _firebaseMessaging.getToken();
      print('FCM Token : ${token}');
      print('user : ' + currentUserUid.isEmpty.toString());
      if(currentUserUid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
        'fcmToken': token,
      });
      }

      // Initialize FlutterLocalNotificationsPlugin
      final InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } else {
      print('User declined or has not granted permission for push notifications');
    }

    
  }
}
