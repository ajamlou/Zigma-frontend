import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Color(0xFFECE9DF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Du behöver ett konto för att fortsätta",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Color(0xff96070a)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          RaisedButton(
            color: Colors.greenAccent,
            child: Text("Logga in", style: TextStyle(color: Colors.white)),
            onPressed: () async =>
                DataProvider.of(context).routing.routeLoginPage(context),
          ),
          Text("eller"),
          RaisedButton(
            color: Colors.lightBlueAccent,
            child: Text("Skapa ett Zigma konto",
                style: TextStyle(color: Colors.white)),
            onPressed: () async =>
                DataProvider.of(context).routing.routeRegisterPage(context),
          ),
        ],
      ),
    );
  }
}
