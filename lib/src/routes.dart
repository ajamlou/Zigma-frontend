import 'package:flutter/material.dart';
import 'package:zigma2/src/pages/RegisterPage.dart';
import 'package:zigma2/src/pages/advert_creation.dart';
import 'package:zigma2/src/pages/advert_page.dart';
import 'package:zigma2/src/pages/chat_page.dart';
import 'package:zigma2/src/pages/landing_page.dart';
import 'package:zigma2/src/pages/login_page.dart';
import 'package:zigma2/src/pages/profile_page.dart';

class Routing {
  void routeChatPage(context, bool replace) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => FriendlyChatApp()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => FriendlyChatApp()));
    }
  }

  void routeLandingPage(context, bool replace) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => LandingPage()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => LandingPage()));
    }
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

  void routeAdvertPage(context, data, bool replace) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => AdvertPage(data: data)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvertPage(data: data),
        ),
      );
    }
  }

  void routeProfilePage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
