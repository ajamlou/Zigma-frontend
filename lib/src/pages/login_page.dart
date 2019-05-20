import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/user.dart';

class LoginPage extends StatefulWidget {
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  int _success;
  String _password;
  String _userName;
  Map parsed;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAEDBD3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
                child: Text(
              'ZIGMA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60.0,
                color: Colors.white,
              ),
            )),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Logga In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Color(0xFF373F51)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                margin: const EdgeInsets.only(
                    top: 40.0, right: 40.0, left: 40.0, bottom: 20),
                child: Form(
                  key: _userKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Användarnamn',
                          icon: Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF373F51),
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Användarnamn kan ej vara tomt' : null,
                        onSaved: (value) => _userName = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'Lösenord',
                            icon: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.lock,
                                color: Color(0xFF373F51),
                              ),
                            )),
                        validator: (value) =>
                            value.isEmpty ? 'Lösenord kan ej vara tomt' : null,
                        onSaved: (value) => _password = value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 35.0, left: 35.0),
                  child: MaterialButton(
                    color: Color(0xFF3FBE7E),
                    onPressed: () async {
                      if (_userKey.currentState.validate()) {
                        DataProvider.of(context)
                            .loadingScreen
                            .showLoadingDialog(context);
                        _userKey.currentState.save();
                        _success = await DataProvider.of(context)
                            .user
                            .signIn(_userName, _password);
                        Navigator.of(context, rootNavigator: true).pop(null);
                        if (_success == 200) {
                          DataProvider.of(context)
                              .routing
                              .routeLandingPage(context, true);
                        } else {
                          showLoginAlertDialog(_success);
                        }
                      }
                    },
                    child: Text('Logga in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                            fontSize: 16)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:5),
                  height: 25,
                  child: MaterialButton(
                    child: Text('Glömt ditt lösenord?'),
                    onPressed: () {print("hej");},
                  ),
                ),
                Container(
                  width: 300,
                  padding: EdgeInsets.only(top: 40),
                  child: MaterialButton(
                    color: Color(0xFFECA72C),
                    child: Text('Skapa nytt konto',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                            fontSize: 16)),
                    onPressed: () async => DataProvider.of(context)
                        .routing
                        .routeRegisterPage(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showLoginAlertDialog(int value) {
    String message;
    if (value == 400) {
      message = "Fel lösenord eller användarnamn";
    } else if (value == 500) {
      message = "Serverfel, testa igen";
    }
    AlertDialog dialog = AlertDialog(
      backgroundColor: Colors.white,
      content: Text(
        message,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
