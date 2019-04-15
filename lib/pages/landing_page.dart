import 'package:flutter/material.dart';
import './login_page.dart';
import './search_page.dart';
import './searchbar.dart';
import './advert_creation.dart';

class LandingPage extends StatelessWidget {
  final List data;
  LandingPage({this.data});
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
        Container(
          height: 50,
          decoration: new BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: new BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: MaterialButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage(data: data),
              );
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(Icons.search),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text('Sök efter din litteratur...'),
                  ),
                ],
              ),
            ),
          ),
        ),
            RaisedButton(
              child: Text("Advert Creation"),
              onPressed: () async => routeCreationPage(context),
            ),
          ],
        ),
      ),
    );
  }

  void routeCreationPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => advertCreation()));
  }

}

  void routeSearchPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => Searchbar()));
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
