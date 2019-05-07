import 'package:flutter/material.dart';
import 'package:zigma2/src/pages/loading_screen.dart';
import 'package:zigma2/src/pages/splashscreen.dart';
import 'package:zigma2/src/routes.dart';
import './src/DataProvider.dart';
import './src/advert.dart';
import './src/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdvertList advertList = AdvertList();
  UserMethodBody user = UserMethodBody(null);
  Routing routing = Routing();
  LoadingScreen loadingScreen = LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      advertList: advertList,
      user: user,
      routing: routing,
      loadingScreen: loadingScreen,
      child: MaterialApp(
        title: 'Zigma App',
        home: SplashScreen(),
        color: Color(0xFFECE9DF),
      ),
    );
  }

  void initState() {
    super.initState();
    print("im in initState in the main MyApp");
    advertList.loadAdvertList();
    user.automaticLogin();
  }
}
