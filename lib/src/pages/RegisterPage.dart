import 'dart:io';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class RegisterPage extends StatefulWidget {
  State createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  List _success;
  String _userEmail;
  String _password;
  String _userName;
  TextEditingController validatePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  RegExp passwordRegExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  Color registerColor = Color(0xFFDE5D5D);
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
    usernameController.addListener(_usernameListener);
    emailController.addListener(_emailListener);
    validatePasswordController.addListener(_passwordListener);
    passwordController.addListener(_passwordListener);
  }

  @override
  void dispose() {
    passwordController.dispose();
    validatePasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _usernameListener() {
    setState(() {});
  }

  bool _emailListener() {
    setState(() {});
    return emailRegExp.hasMatch(emailController.text);
  }

  bool _passwordListener() {
    setState(() {});
    return passwordRegExp.hasMatch(passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _showRegisterPage());
  }

  Widget _showRegisterPage() {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100.0, left: 100.0),
              child: Image.asset('images/logo_frontpage.png'),
            ),
            Text(
              'Skapa konto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Form(
              key: _userKey,
              child: Container(
                margin:
                    const EdgeInsets.only(top: 10.0, right: 40.0, left: 40.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: _image == null
                          ? Container(
                              height: 190,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                image: DecorationImage(
                                  image: AssetImage('images/profile_pic.png'),
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: showImageAlertDialog,
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    height: 190,
                                    width: 170,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
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
                      decoration: InputDecoration(
                        hintText: 'Användarnamn',
                        icon: Icon(
                          Icons.person_add,
                          color: registerColor,
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
                      decoration: InputDecoration(
                        hintText: 'Email',
                        icon: Icon(
                          Icons.mail,
                          color: registerColor,
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
                      decoration: InputDecoration(
                        hintText: 'Lösenord',
                        icon: Icon(
                          Icons.lock,
                          color: registerColor,
                        ),
                        suffixIcon: passwordController.text.length < 8 ||
                                validatePasswordController.text !=
                                    passwordController.text
                            ? Icon(Icons.star,
                                size: 10, color: Color(0xff96070a))
                            : Icon(Icons.check, color: Colors.green),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Obligatoriskt Fält';
                        } else if (!passwordRegExp
                            .hasMatch(passwordController.text)) {
                          return 'lösenordet måste vara minst 8 karaktärer\noch innehålla minst ett nummer';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => _password = value,
                    ),
                    //color: same,
                    TextFormField(
                      maxLines: 1,
                      controller: validatePasswordController,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Repetera lösenord',
                        icon: Icon(
                          Icons.lock,
                          color: registerColor,
                        ),
                        suffixIcon: passwordController.text == "" ||
                                validatePasswordController.text !=
                                    passwordController.text
                            ? Icon(Icons.star,
                                size: 10, color: Color(0xff96070a))
                            : Icon(Icons.check, color: Colors.green),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Obligatoriskt Fält';
                        } else if (validatePasswordController.text !=
                            passwordController.text) {
                          return 'lösenorden måste vara likadana';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 10.0, right: 55.0, left: 55.0),
              child: MaterialButton(
                color: Color(0xFFECA72C),
                child: Text('Skapa nytt konto',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                onPressed: () async {
                  if (_userKey.currentState.validate() &&
                      passwordController.text ==
                          validatePasswordController.text) {
                    DataProvider.of(context)
                        .loadingScreen
                        .showLoadingDialog(context);
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
    );
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
