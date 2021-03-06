import 'package:flutter/material.dart';
import 'package:zigma2/src/pages/RegisterPage.dart';
import 'package:zigma2/src/pages/advert_creation.dart';
import 'package:zigma2/src/pages/advert_page.dart';
import 'package:zigma2/src/pages/chat_page.dart';
import 'package:zigma2/src/pages/landing_page.dart';
import 'package:zigma2/src/pages/login_page.dart';
import 'package:zigma2/src/pages/profile_page.dart';
import 'package:zigma2/src/pages/user_advert_page.dart';
import 'package:zigma2/src/pages/user_edit_page.dart';

class Routing {
  void routeChatPage(context, bool replace) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => ZigmaChat()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => ZigmaChat()));
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

  void routeAdvertPage(BuildContext context, data, bool replace,) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AdvertPage(advert: data)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvertPage(advert: data),
        ),
      );
    }
  }

  void routeUserAdvertPage(context, advert, List userSellingAdverts,
      List userBuyingAdverts, bool replace) {
    if (replace) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          builder: (_) => UserAdvertPage(advert: advert)));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAdvertPage(
                advert: advert,
                sellingAdverts: userSellingAdverts,
                buyingAdverts: userBuyingAdverts,
              ),
        ),
      );
    }
  }

  void routeSpecificChat(context, chat, String token) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(thisChat: chat, token: token)));
  }

  void routeProfilePage(context, user) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: user)));
  }

  void routeUserEditPage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserEditPage()));
  }
}
