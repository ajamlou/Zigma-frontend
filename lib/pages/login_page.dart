import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './DataProvider.dart';
import './user.dart';

class LoginPage extends StatefulWidget {
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  bool _success;
  String _password;
  String _userName;
  Map parsed;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _showLoginPage());
  }
  void _routeRegisterPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Widget _showLoginPage() {
    return Container(
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
              margin: const EdgeInsets.only(top: 50.0, right: 40.0, left: 40.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      icon: new Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Username can\'t be empty' : null,
                    onSaved: (value) => _userName = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        icon: new Icon(
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
            alignment: Alignment.center,
            child: Text(_success == null
                ? ''
                : (_success
                    ? 'Successfully logged in ' + _userName
                    : 'Login failed')),
          ),
          Container(
            width: 150,
            child: MaterialButton(
              color: Color(0xFF008000),
              onPressed: () async {
                if (_userKey.currentState.validate()) {
                  _userKey.currentState.save();
                  DataProvider.of(context)
                      .user
                      .signIn(_userName, _password);
                }
              },
              child:
                  Text('Logga in', style: TextStyle(color: Color(0xFFFFFFFF))),
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
                  _routeRegisterPage(context, RegisterPage()),
            ),
          )
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  State createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  bool _success;
  String _userEmail;
  String _password;
  String _userName;
  Map parsed;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _showRegisterPage());
  }

  Widget _showRegisterPage() {
    return Container(
      color: Color(0xFFECE9DF),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text('Register',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          Form(
            key: _userKey,
            child: Container(
              margin: const EdgeInsets.only(top: 50.0, right: 40.0, left: 40.0),
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Email',
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _userEmail = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                        value.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Username',
                      icon: new Icon(
                        Icons.person_add,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Username can\'t be empty' : null,
                    onSaved: (value) => _userName = value,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(_success == null
                ? ''
                : (_success
                    ? 'Successfully registered ' + _userName
                    : 'Register failed')),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MaterialButton(
              color: Color(0xFF6C6CDF),
              child: Text('Skapa nytt konto',
                  style: TextStyle(color: Color(0xFFFFFFFF))),
              onPressed: () async {
                if (_userKey.currentState.validate()) {
                  _userKey.currentState.save();
                  DataProvider.of(context)
                      .user
                      .register(_userEmail,_userName, _password);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
