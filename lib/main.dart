import 'package:flutter/material.dart';
import './pages/landing_page.dart';
import './pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext Context) {
    return MaterialApp(
        title: 'Zigma App',
        home: LandingPage(),
        color: Color(0xFFECE9DF)
    );
  }
}



