import 'package:flutter/material.dart';
import 'package:zigma2/src/pages/RegisterPage.dart';
import 'package:zigma2/src/pages/advert_creation.dart';
import 'package:zigma2/src/pages/advert_page.dart';
import 'package:zigma2/src/pages/chat_page.dart';
import 'package:zigma2/src/pages/landing_page.dart';
import 'package:zigma2/src/pages/login_page.dart';
import 'package:zigma2/src/pages/profile_page.dart';

class Routing {
  void routeChatPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => FriendlyChatApp()));
  }

  void routeLandingPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LandingPage()));
  }

  void routeRegisterPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => RegisterPage()));
  }

  void routeLoginPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LoginPage()));
  }

  void routeCreationPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => AdvertCreation()));
  }

  void routeAdvertPage(context, index, data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertPage(data: data[index]),
      ),
    );
  }

  void routeProfilePage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
