import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      DataProvider
          .of(context)
          .routing
          .routeLandingPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataProvider.of(context).loadingScreen;
  }
}