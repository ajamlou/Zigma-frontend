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
              margin: const EdgeInsets.only(top: 50.0,right: 40.0, left: 40.0),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Användarnamn'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Lösenord'),
                )
              ],),
            ),
            Container(
              width: 150,
              child: MaterialButton(
                color: Color(0xFF008000),
                child: Text('Logga in', style: TextStyle(color: Color(0xFFFFFFFF))),
                onPressed:(){},
              ),
            ),
            Container(
              height: 15,
              child: MaterialButton(
                child: Text('Glömt ditt lösenord?'),
                onPressed:(){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: MaterialButton(
                color: Color(0xFF6C6CDF),
                child: Text('Skapa nytt konto', style: TextStyle(color: Color(0xFFFFFFFF))),
                onPressed:(){},
              ),
            )
          ],
        ),
      ),
    );
  }
}