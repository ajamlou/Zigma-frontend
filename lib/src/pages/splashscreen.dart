import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'dart:async';

import 'package:zigma2/src/components/loading_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      DataProvider
          .of(context)
          .routing
          .routeLandingPage(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}