import 'dart:convert';
import 'dart:io';

import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/main.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationsManager {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String lastMessageId = "0";
  static final navKey = new GlobalKey<NavigatorState>();
  Future initialise() async {
    print("=============Notification===========");
    if (Platform.isIOS) iOSPermission();
    _fcm.getToken().then((token) {
      print('token : ' + token.toString());
      setToken(token);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message.data['type'] == '3') {
        // developer.log('inside if block', name: "fcm");
        // developer.log(message.toString(), name: 'fcm');
        //navigating to pet detail class on notification click
        globalNavigationKey.currentState.push(
          MaterialPageRoute(
            builder: (_) => PetDetailClass(
              id: message.data['reference_id'].toString(),
              fromBreeder: false,
              isPreview: false,
              post: null,
              images: null,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == '3') {
        // developer.log('inside if block', name: "fcm");
        // developer.log(message.toString(), name: 'fcm');
        //navigating to pet detail class on notification click
        globalNavigationKey.currentState.push(
          MaterialPageRoute(
            builder: (_) => PetDetailClass(
              id: message.data['reference_id'].toString(),
              fromBreeder: false,
              isPreview: false,
              post: null,
              images: null,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == '3') {
        // developer.log('inside if block', name: "fcm");
        // developer.log(message.toString(), name: 'fcm');
        //navigating to pet detail class on notification click
        globalNavigationKey.currentState.push(
          MaterialPageRoute(
            builder: (_) => PetDetailClass(
              id: message.data['reference_id'].toString(),
              fromBreeder: false,
              isPreview: false,
              post: null,
              images: null,
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) {
      if (message.data['type'] == '3') {
        // developer.log('inside if block', name: "fcm");
        // developer.log(message.toString(), name: 'fcm');
        //navigating to pet detail class on notification click
        globalNavigationKey.currentState.push(
          MaterialPageRoute(
            builder: (_) => PetDetailClass(
              id: message.data['reference_id'].toString(),
              fromBreeder: false,
              isPreview: false,
              post: null,
              images: null,
            ),
          ),
        );
      }
    });
    var initializationSettingsAndroid =
        AndroidInitializationSettings('applogo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(payload) async {
    Map valueMap = json.decode(payload);
    var type = valueMap["type"].toString();
    print("valueMap notification" + valueMap.toString());
    if (type == "null") {
      if (Platform.isAndroid) {
        type = valueMap["data"]['type'].toString();
      } else {}
    }
    if (type == "1") {
      StateProvider _stateProvider = StateProvider();
      _stateProvider.notify(ObserverState.NOTIFICATION, valueMap);
    }
    return null;
  }

  showNotification(Map<String, dynamic> message) async {
    String notificationTitle;
    String notificationMessage;

    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    print(message);
    if (Platform.isIOS) {
      var data = message['aps'] ?? message;
      var alert = data['alert'] ?? message;
      notificationTitle = alert[
          'title']; // here you need to replace YOUR_KEY with the actual key that you are sending in notification  **`"data"`** -field of the message.
      notificationMessage = alert['body'];
    } else {
      //{notification: {title: New follower, body: You have new follower}, data: {body: You have new follower, title: New follower}}
      print("androidNotification : " + message.toString());
      notificationTitle = message['notification'][
          'title']; // here you need to replace YOUR_KEY with the actual key that you are sending in notification  **`"data"`** -field of the message.
      notificationMessage = message['notification']['body'];
    }
    // here you need to replace YOUR_KEY with the actual key that you are sending in notification  **`"data"`** -field of the message.
    var str = json.encode(message);
    await flutterLocalNotificationsPlugin.show(
        0, notificationTitle, notificationMessage, platform,
        payload: str);
  }

  void iOSPermission() async {
    // _fcm.requestNotificationPermissions(IosNotificationSettings(
    //     sound: true, badge: true, alert: true, provisional: false));
    // _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }

  Future setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FCMTOKEN, token.toString());
    //  String deviceId = await _getId();
  }

// Future<String> _getId() async {
//   var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     // import 'dart:io'
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     return iosDeviceInfo.identifierForVendor; // unique ID  on iOS
//   } else {
//     var androidDeviceInfo = await deviceInfo.androidInfo;
//     return androidDeviceInfo.androidId; // unique ID on Android
//   }
// }
}
