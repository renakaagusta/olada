import 'package:olada/constants/app_theme.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/ui/splash/splash.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      routes: Routes.routes,
      home: SplashScreen(),
    );}}