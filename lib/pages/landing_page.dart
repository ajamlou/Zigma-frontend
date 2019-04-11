import 'package:flutter/material.dart';
import './login_page.dart';
import './search_page.dart';
import './searchbar.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFECE9DF),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: LoginButton(),
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.only(
                    top: 100.0, left: 50, right: 50, bottom: 100),
                child: Image.asset('images/logo_frontpage.png')),
            SearchFieldLandingPage()
          ],
        ),
      ),
    );
  }
}

class SearchFieldLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: MaterialButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchPage(),
          );
        },
        child: Text('pressme'),
//          decoration: InputDecoration(
//              fillColor: Color(0xFFFFFFFF),
//              filled: true,
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
//              hintText: 'Sök efter en bok'),
//          autocorrect: false,
//        ),
      ),
    );
  }

  void routeSearchPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => Searchbar()));
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async => routeLoginPage(context),
      child: Column(
        children: <Widget>[
          Icon(Icons.contacts),
          Text('Logga In'),
        ],
      ),
    );
  }

  void routeLoginPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LoginPage()));
  }
}
