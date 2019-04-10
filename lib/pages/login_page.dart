import 'package:flutter/material.dart';
import './landing_page.dart';


class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
        leading: MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)
        )
      ),
      body: Container(
          color: Color(0xFFECE9DF),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0,right: 100.0, left: 100.0),
              child: Image.asset('images/logo_frontpage.png'),
            ),
            Text('Logga In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 100.0,right: 40.0, left: 40.0),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Användarnamn'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Lösenord'),
                )
              ],),
            ),
            MaterialButton(
              color: Color(0xFF008000),
              child: Text('Log in', style: TextStyle(color: Color(0xFFFFFFFF))),
              onPressed: null,
            ),
            MaterialButton(
              child: Text('Forgot my password'),
              onPressed: null,
            )
          ],
        ),
      ),
    );
  }
}