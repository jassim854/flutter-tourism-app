import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<bool?> requestNotificationPermission(context) async {
    const permission = Permission.notification;
    if (await permission.isGranted) return true;

    if (await permission.isPermanentlyDenied) {
      // await _handleOpenSettings(permission);

      return false;
    }

 
    final granted = await permission.request().isGranted;
    if (granted) {
      return true;
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
    return null;

    // PermissionStatus permissionStatus = await Permission.notification.status;
    // if (permissionStatus.isDenied) {
    //   await Permission.notification.request().then((value) {
    //     if (value.isDenied) {
    //       return false;
    //     }else{
    //        return true;
    //     }
    //   });
    // } else {
    //   return true;
    // }

    // NotificationSettings settings = await messaging.requestPermission(
    //     alert: true,
    //     carPlay: true,
    //     criticalAlert: true,
    //     provisional: true,
    //     badge: true,
    //     announcement: true,
    //     sound: true);

    // if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //   AppSettings.openAppSettings(type: AppSettingsType.notification);
    //   return false;
    // } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    //   NotificationSettings settings1 = await messaging.requestPermission(
    //       alert: true,
    //       carPlay: true,
    //       criticalAlert: true,
    //       provisional: true,
    //       badge: true,
    //       announcement: true,
    //       sound: true);

    //   if (settings1.authorizationStatus == AuthorizationStatus.denied) {
    //     AppSettings.openAppSettings(type: AppSettingsType.notification);
    //     return false;
    //   }
    //   return true;
    // }
    // return true;
  }

  static void initLocalNotification(context, RemoteMessage message) async {
    const androidInitializationSettings =
        AndroidInitializationSettings("box_icon");
    final iosInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBanner: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestCriticalPermission: true,
      requestProvisionalPermission: true,
      defaultPresentList: true,
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          handleMessage(context, message),
    );
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          handleMessage(context, message),
    );
  }

  static void firebaseInIt(context) async {
    if (Platform.isIOS) {
      foregroundMessaging();
    }
    FirebaseMessaging.onMessage.listen((message) async {
      initLocalNotification(context, message);
      showNotification(message);
    });
  }

//  static   final String filePath = '';
//    static final BigPictureStyleInformation bigPictureStyleInformation =
//         BigPictureStyleInformation(FilePathAndroidBitmap(filePath),
//             largeIcon: FilePathAndroidBitmap(filePath));
  // final http.Response response = await http.get(Uri.parse(URL));
  // BigPictureStyleInformation bigPictureStyleInformation =
  //     BigPictureStyleInformation(
  //   ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
  //   largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
  // );
  static Future<void> showNotification(RemoteMessage message) async {
    List<ActiveNotification> activeNotification =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .getActiveNotifications();
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (activeNotification.isEmpty || activeNotification.length == 1) {
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              channel.id.toString(), channel.name.toString(),
              channelDescription: "high_importance_channel",
              importance: Importance.high,
              priority: Priority.high,
              // color: Colors.transparent,
              ticker: "ticker");
      DarwinNotificationDetails darwinNotificationDetails =
          const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      Future.delayed(
          Duration.zero,
          () => flutterLocalNotificationsPlugin.show(
              0,
              message.notification?.title.toString(),
              message.notification?.body.toString(),
              notificationDetails));
    }

    if (activeNotification.length > 1) {
      List<String> lines =
          activeNotification.map((e) => e.title.toString()).toList();
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
          contentTitle: "${activeNotification.length - 1} messages",
          summaryText: "${activeNotification.length - 1} messages");
      AndroidNotificationDetails groupAndroidNotificationDetails =
          AndroidNotificationDetails(
              channel.id.toString(), channel.name.toString(),
              channelDescription: "high_importance_channel",
              groupKey: '0',
              setAsGroupSummary: true,
              importance: Importance.high,
              priority: Priority.high,
              // color: Colors.transparent,
              styleInformation: inboxStyleInformation,
              ticker: "ticker");

      NotificationDetails groupNotificationDetails = NotificationDetails(
        android: groupAndroidNotificationDetails,
      );

      Future.delayed(
          Duration.zero,
          () => flutterLocalNotificationsPlugin.show(
              0,
              message.notification?.title.toString(),
              message.notification?.body.toString(),
              groupNotificationDetails));
    }
  }

  static Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  // static refreshDeviceToken() {
  //   return messaging.onTokenRefresh.listen((event) async {
  //     return await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser?.email)
  //         .update({"device_token": event});
  //   });
  // }

  // static Future<void> createNotificationChannel(
  //     String id, String name, String description) async {
  //   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   var androidNotificationChannel =
  //       AndroidNotificationChannel(id, name, description: description);
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(androidNotificationChannel);
  // }

  static Future<void> setupInteractMessage(context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  static Future foregroundMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  static handleMessage(context, RemoteMessage message) async {}
}
