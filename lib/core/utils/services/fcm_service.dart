import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
      // you should inialize Firebase in main before using FcmService 
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 */

class FcmService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    //set the Notifications permission requests
    await _initNotificationsPermission();

    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
    }

    //get UserToken
    await _getToken();

    //onTokenRefresh
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _handleForegroundMessages();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<String?> _getToken() async {
    final String? fcmToken = await FirebaseMessaging.instance.getToken(
      vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu",
    );
    log('token : $fcmToken');
    return fcmToken;
  }

  static Future<void> _initNotificationsPermission() async {
    //set the Notifications permission requests
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
  }

//ForegroundMessages

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('notification title : ${message.notification?.title}');
        log('notification body : ${message.notification?.body}');
        flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'ic_launcher',
                // other properties...
              ),
            ));
      }
    });
  }
}

// this function  must be a top-level function (e.g. not a class method which requires initialization).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  log("Handling a background message: ${message.messageType}");
  log("Handling a background message: ${message.sentTime}");
}
