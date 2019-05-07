import 'dart:io';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'package:flutter/material.dart';
import 'package:zigma2/src/user.dart';
import 'package:zigma2/src/DataProvider.dart';

class RegisterPage extends StatefulWidget {
  State createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  List _success;
  String _userEmail;
  String _password;
  Color same;
  String _userName;
  Map parsed;
  User user;
  bool isLoading = false;
  bool validatedPwd = false;
  TextEditingController validatePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  File _image;

  void showImageAlertDialog() async {
    File tempImage;
    AlertDialog dialog = AlertDialog(
        backgroundColor: Color(0xFFECE9DF),
        title: Text(
          "Kamera eller Galleri?",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff96070a),
          ),
          textAlign: TextAlign.center,
        ),
        content: ButtonBar(
          children: <Widget>[
            RaisedButton(
              color: Color(0xff96070a),
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
              onPressed: () async {
                tempImage = await Ih.getImage("gallery");
                setState(() {
                  _image = tempImage;
                });
                Navigator.of(context, rootNavigator: true).pop(null);
              },
            ),
            RaisedButton(
              color: Color(0xff96070a),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: () async {
                tempImage = await Ih.getImage("camera");
                setState(() {
                  _image = tempImage;
                });
                Navigator.of(context, rootNavigator: true).pop(null);
              },
            ),
          ],
        ));
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_usernameListenerMethod);
    emailController.addListener(_emailListener);
    validatePasswordController.addListener(_listenerMethod);
    passwordController.addListener(_listenerMethod);
    same = Colors.grey;
  }

  @override
  void dispose() {
    passwordController.dispose();
    validatePasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _usernameListenerMethod() {
    setState(() {});
  }

  bool _emailListener() {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    setState(() {});
    return regExp.hasMatch(emailController.text);
  }

  void _listenerMethod() {
    same = passwordChecker();
    setState(() {});
  }

  Color passwordChecker() {
    if (validatePasswordController.text == "") {
      return Colors.grey;
    }
    if (passwordController.text.compareTo(validatePasswordController.text) ==
        0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _showRegisterPage());
  }

  Widget _showRegisterPage() {
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
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 100.0),
                child: Image.asset('images/logo_frontpage.png'),
              ),
              Text(
                'Skapa konto',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Color(0xff96070a)),
                textAlign: TextAlign.center,
              ),
              Form(
                key: _userKey,
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 50.0, right: 40.0, left: 40.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: _image == null
                            ? Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                    image: AssetImage('images/profile_pic.png'),
                                  ),
                                ),
                                child: MaterialButton(
                                  onPressed: showImageAlertDialog,
                                ),
                              )
                            : Container(
                                height: 200,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 150,
                                      height: 150,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text("Ta en ny bild"),
                                      onPressed: () {
                                        showImageAlertDialog();
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: usernameController,
                        autofocus: false,
                        cursorColor: Color(0xff96070a),
                        decoration: InputDecoration(
                          hintText: 'Användarnamn',
                          icon: Icon(
                            Icons.person_add,
                            color: Colors.grey,
                          ),
                          suffixIcon: usernameController.text == ""
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xff96070a))
                              : Icon(Icons.check, color: Colors.green),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _userName = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        cursorColor: Color(0xff96070a),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          suffixIcon: !_emailListener()
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xff96070a))
                              : Icon(Icons.check, color: Colors.green),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _userEmail = value,
                      ),
                      emailController.text.length == 0
                          ? SizedBox(
                              width: 0,
                              height: 0,
                            )
                          : _emailListener()
                              ? Text(
                                  "Mejladressen är giltig!",
                                  style: TextStyle(color: Colors.lightGreen),
                                )
                              : Text("Det måste vara en giltig mejladress",
                                  style: TextStyle(color: Colors.redAccent)),
                      TextFormField(
                        maxLines: 1,
                        controller: passwordController,
                        obscureText: true,
                        autofocus: false,
                        cursorColor: Color(0xff96070a),
                        decoration: InputDecoration(
                          hintText: 'Lösenord',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          suffixIcon: passwordController.text.length < 8
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xff96070a))
                              : Icon(Icons.check, color: Colors.green),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _password = value,
                      ),
                      //color: same,
                      TextFormField(
                          maxLines: 1,
                          controller: validatePasswordController,
                          obscureText: true,
                          autofocus: false,
                          cursorColor: Color(0xff96070a),
                          decoration: InputDecoration(
                            hintText: 'Repetera lösenord',
                            icon: Icon(
                              Icons.lock,
                              color: same,
                            ),
                            suffixIcon: passwordController.text == "" ||
                                    validatePasswordController.text !=
                                        passwordController.text
                                ? Icon(Icons.star,
                                    size: 10, color: Color(0xff96070a))
                                : Icon(Icons.check, color: Colors.green),
                          ),
                          validator: (value) => value.isEmpty
                              ? 'Detta fält kan inte vara tomt'
                              : null),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, right: 55.0, left: 55.0),
                child: MaterialButton(
                  color: Color(0xFF6C6CDF),
                  child: Text('Skapa nytt konto',
                      style: TextStyle(color: Color(0xFFFFFFFF))),
                  onPressed: () async {
                    if (_userKey.currentState.validate()) {
                      showLoadingAlertDialog();
                      _userKey.currentState.save();
                      _success = await DataProvider.of(context).user.register(
                          _userEmail,
                          _userName,
                          _password,
                          Ih.imageFileToString(_image));
                      Navigator.of(context, rootNavigator: true).pop(null);
                      showRegisterAlertDialog(_success);
                    }
                  },
                ),
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

  void showRegisterAlertDialog(List value) {
    String message = "";
    if (value[0] == 400) {
      if (value[1].username != null) {
        message = message + value[1].username + "\n";
      }
      if (value[1].password != null) {
        message = message + value[1].password + "\n";
      }
      if (value[1].email != null) {
        message = message + value[1].email;
      }
    } else if (value[0] == 500) {
      message = "Serverfel, testa igen";
    } else if (value[0] == 201) {
      message = "Du är nu registerad!";
    }
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      title: Text(
        message,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
      content: value[0] == 201
          ? RaisedButton(
              child: Text("Gå vidare"),
              onPressed: () {
                DataProvider.of(context)
                    .routing
                    .routeLandingPage(context, true);
              },
            )
          : RaisedButton(
              child: Text("Tillbaka"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(null);
              }),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
