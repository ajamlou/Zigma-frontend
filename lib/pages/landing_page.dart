import 'package:flutter/material.dart';
import './login_page.dart';
import './search_page.dart';


class LandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
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
                    padding: const EdgeInsets.only(top: 100.0, left: 50, right: 50, bottom: 100),
                    child: Image.asset('images/logo_frontpage.png')
                ),
                SearchFieldLandingPage()
              ],
            )
        )
    );
  }
}

class SearchFieldLandingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: MaterialButton(
          onPressed: null,
          child: TextField(
            decoration: InputDecoration(
                fillColor: Color(0xFFFFFFFF),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                hintText: 'Sök efter en bok'
            ),
            autocorrect: false,
          )
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () async => routeLoginPage(context),
        //crossAxisAlignment: CrossAxisAlignment.end,
        child: Column(
          children: <Widget>[
            Icon(Icons.contacts),
            Text('Logga In'),
          ],
        ));
  }

  void routeLoginPage(context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LoginPage())
    );
  }
}