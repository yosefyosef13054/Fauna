import 'dart:async';
import 'dart:developer' as developer;

import 'package:fauna/home/base_class.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/main.dart';
import 'package:fauna/onboarding/login.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var authToken;

  @override
  void initState() {
    super.initState();
    // _initializeFirebase();
    getUser();
    Timer(new Duration(seconds: 5), () {
      if (authToken != null) {
        getUserAuth();
      } else {
        Navigator.pushNamed(context, LoginCLass.routeName);
      }
    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString(AUTHTOKEN);
    });
  }

  void getUserAuth() async {
    Map<String, String> headers = {
      "Authorization": "Bearer " + authToken,
      "secretKey": "sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518",
    };
    final response = await http.get(
        Uri.parse('https://fauna.live/adminportal/api/v1/checkLogin'),
        headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pushNamed(context, BaseClass.routeName);
    } else {
      Navigator.pushNamed(context, LoginCLass.routeName);
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/splash.webp",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/logo.webp",
                  width: MediaQuery.of(context).size.width - 60,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initializeFirebase() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message.data['type'] == '3') {
        developer.log('inside if block', name: "fcm");
        developer.log(message.toString(), name: 'fcm');
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
        developer.log('inside if block', name: "fcm");
        developer.log(message.toString(), name: 'fcm');
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
        developer.log('inside if block', name: "fcm");
        developer.log(message.toString(), name: 'fcm');
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
  }
}
