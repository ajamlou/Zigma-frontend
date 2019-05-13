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
    return Container(
      color: Color(0xFFECE9DF),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Color(0xff96070a)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Container(
              child: IconButton(
                color: Color(0xff96070a),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            actions: <Widget>[],
          ),
        ),
        body: Container(
          color: Color(0xFFECE9DF),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 100.0),
                child: Image.asset('images/logo_frontpage.png'),
              ),
              Center(
                child: Text('Logga In',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _userKey,
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 40.0, right: 40.0, left: 40.0, bottom: 20),
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
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 109.9,
                    margin: const EdgeInsets.only(right: 35.0, left: 35.0),
                    child: MaterialButton(
                      color: Color(0xFF008000),
                      onPressed: () async {
                        if (_userKey.currentState.validate()) {
                          showLoadingAlertDialog();
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
                          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
                    ),
                  ),
                  Container(
                    height: 15,
                    child: MaterialButton(
                      child: Text('Glömt ditt lösenord?'),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30.0, right: 55.0, left: 55.0),
                    child: MaterialButton(
                      color: Color(0xFF6C6CDF),
                      child: Text('Skapa nytt konto',
                          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16)),
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
