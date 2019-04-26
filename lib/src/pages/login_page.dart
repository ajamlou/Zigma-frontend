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
    return  Scaffold(
      body: Container(
        color: Color(0xFFECE9DF),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25.0),
                  child: IconButton(
                    color: Color(0xFF96070a),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 100.0, right: 100.0, left: 100.0),
              child: Image.asset('images/logo_frontpage.png'),
            ),
            Text('Logga In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Form(
              key: _userKey,
              child: Container(
                margin:
                    const EdgeInsets.only(top: 50.0, right: 40.0, left: 40.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        icon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Username can\'t be empty' : null,
                      onSaved: (value) => _userName = value,
                    ),
                    TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 150,
              child: MaterialButton(
                color: Color(0xFF008000),
                onPressed: () async {
                  if (_userKey.currentState.validate()) {
                    showLoadingAlertDialog();
                    _userKey.currentState.save();
                    _success = await DataProvider.of(context)
                        .user
                        .signIn(_userName, _password);
                  }
                  Navigator.of(context, rootNavigator: true).pop(null);
                  if(_success == 200) {
                    DataProvider.of(context).routing.routeLandingPage(context);
                  }
                  else{
                   showLoginAlertDialog(_success);
                  }
                },
                child: Text('Logga in',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
              ),
            ),
            Container(
              height: 15,
              child: MaterialButton(
                child: Text('Glömt ditt lösenord?'),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: MaterialButton(
                color: Color(0xFF6C6CDF),
                child: Text('Skapa nytt konto',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                onPressed: () async =>
                    DataProvider.of(context).routing.routeRegisterPage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showLoadingAlertDialog() {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      title: Text(
        "Laddar...",
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
      content: DataProvider.of(context).loadingScreen,
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showLoginAlertDialog(int value) {
    String message;
    if (value == 400) {
      message = "Fel lösenord eller användarnamn";
    } else if (value == 500) {
      message = "Serverfel, testa igen";
    }
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
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
