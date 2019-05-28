import 'package:flutter/material.dart';
import 'package:zigma2/src/components/loading_screen.dart';
import 'package:zigma2/src/pages/splashscreen.dart';
import 'package:zigma2/src/routes.dart';
import './src/DataProvider.dart';
import './src/advert.dart';
import './src/user.dart';
import './src/chat.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

Color zigmaBlue = Color(0xFFAEDBD3);
Color marigoldYellow = Color(0xFFECA72C);
Color lunarRed = Color(0xFFDE5D5D);
Color charcoalBlue = Color(0xFF373F51);
Color swedishGreen = Color(0xFF3FBE7E);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdvertList advertList = AdvertList();
  UserMethodBody user = UserMethodBody();
  Routing routing = Routing();
  LoadingDialog loadingScreen = LoadingDialog();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return DataProvider(
      advertList: advertList,
      user: user,
      routing: routing,
      loadingScreen: loadingScreen,
      child: MaterialApp(
        title: 'Zigma App',
        theme: ThemeData(
          fontFamily: 'GlacialIndifference',
          scaffoldBackgroundColor: Colors.white,
          cursorColor: Color(0xFFDE5D5D),
          dialogBackgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xFF373F51),
          ),
          primaryIconTheme: IconThemeData(
            color: Color(0xFF373F51),
          ),
          accentIconTheme: IconThemeData(
            color: Color(0xFF373F51),
          )
        ),
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
