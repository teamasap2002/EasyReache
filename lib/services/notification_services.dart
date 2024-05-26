import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    } else{
      print("User denied Permission");
    }
  }
  void initLocalNotification(BuildContext context, RemoteMessage message) async{
    var androidInitializationSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){

      }
    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if(Platform.isAndroid){
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }


  Future<void> showNotification(RemoteMessage message) async{
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: "Your Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, (){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<String> getDeviceToken()async{
    String? token = await messaging.getToken();
    return token!;
  }
  void isTokenRefresh() async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }
}