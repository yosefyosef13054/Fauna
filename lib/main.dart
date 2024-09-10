import 'package:fauna/home/base_class.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/onboarding/forgot.dart';
import 'package:fauna/onboarding/login.dart';
import 'package:fauna/onboarding/otp_verify.dart';
import 'package:fauna/onboarding/splash.dart';
import 'package:fauna/supportingClass/classBuilder.dart';
import 'package:fauna/supportingClass/notificatonManager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'onboarding/register.dart';

// Import the plugin

final GlobalKey<NavigatorState> globalNavigationKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await PusherBeams.start(PUSHER_INSTANCE_ID);
  ClassBuilder.registerClasses();
  runApp(
    MaterialApp(
      navigatorKey: globalNavigationKey,
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginCLass.routeName: (context) => LoginCLass(),
        RegisterCLass.routeName: (context) => RegisterCLass(),
        ForgotClass.routeName: (context) => ForgotClass(),
        OTPClass.routeName: (context) => OTPClass(),
        BaseClass.routeName: (context) => BaseClass(),
        PetDetailClass.routeName: (context) => PetDetailClass(),
      },
    ),
  );
  PushNotificationsManager().initialise();
}
