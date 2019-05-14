import 'package:flutter/material.dart';
import 'package:zigma2/src/components/loading_screen.dart';
import 'package:zigma2/src/pages/splashscreen.dart';
import 'package:zigma2/src/routes.dart';
import './src/DataProvider.dart';
import './src/advert.dart';
import './src/user.dart';

void main() => runApp(MyApp());

Color zigmaBlue = Color(0xFF93DED0);
Color marigoldYellow = Color(0xFFECA72C);
Color lunarRed = Color(0xFFDE5D5D);
Color charcoalBlue = Color(0xFF373F51);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdvertList advertList = AdvertList();
  UserMethodBody user = UserMethodBody(null);
  Routing routing = Routing();
  LoadingDialog loadingScreen = LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      advertList: advertList,
      user: user,
      routing: routing,
      loadingScreen: loadingScreen,
      child: MaterialApp(
        title: 'Zigma App',
        theme: ThemeData(fontFamily: 'GlacialIndifference', scaffoldBackgroundColor: Colors.white),
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
