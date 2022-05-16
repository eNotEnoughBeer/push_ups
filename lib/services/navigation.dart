import 'package:flutter/material.dart';
import 'package:push_ups/widgets/auth_screen.dart';
import 'package:push_ups/widgets/main_screen.dart';
import 'package:push_ups/widgets/splash_screen.dart';

abstract class NavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = 'main';
  static const launchScreen = 'splash';
}

class Navigation {
  static String initialRoute() => NavigationRouteNames.launchScreen;

  final routes = <String, Widget Function(BuildContext context)>{
    NavigationRouteNames.launchScreen: (context) => SplashScreen.withProvider(),
    NavigationRouteNames.mainScreen: (context) => MainScreen.withProvider(),
    NavigationRouteNames.auth: (context) => AuthScreen.withProvider(),
  };

  static void showMainScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        NavigationRouteNames.mainScreen, (route) => false);
  }

  static void showAuthScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(NavigationRouteNames.auth, (route) => false);
  }
}
