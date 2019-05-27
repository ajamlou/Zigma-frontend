import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Du behöver ett konto för att fortsätta",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Color(0xFF373F51)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 300,
            child: RaisedButton(
              color: Color(0xFF3FBE7E),
              child: Text("Logga in",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () async =>
                  DataProvider.of(context).routing.routeLoginPage(context),
            ),
          ),
          Text("eller"),
          Container(
            width: 300,
            child: RaisedButton(
              color: Color(0xFFECA72C),
              child: Text("Skapa ett Zigma konto",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () async =>
                  DataProvider.of(context).routing.routeRegisterPage(context),
            ),
          ),
        ],
      ),
    );
  }

  void show(context) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        height: 200,
        child: LoginPrompt(),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
