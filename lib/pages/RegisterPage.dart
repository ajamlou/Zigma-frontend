import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'user.dart';
import 'DataProvider.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  State createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  bool _success;
  String _userEmail;
  String _password;
  Color same;
  String _userName;
  Map parsed;
  User user;
  bool validatedPwd = false;
  TextEditingController validatePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File _image;


  Future getImageGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
    });
  }

  String imageFileToString() {
    String imageString = _image.toString();
    print(imageString);
    if (_image != null) {
      imageString = base64.encode(_image.readAsBytesSync());
      return "data:image/jpg;base64,"+imageString;
    }
    else
      return null;
  }

  @override
  void initState() {
    super.initState();
    validatePasswordController.addListener(_listenerMethod);
    passwordController.addListener(_listenerMethod);
    same = Colors.grey;
  }

  @override
  void dispose() {
    passwordController.dispose();
    validatePasswordController.dispose();
    super.dispose();
  }

  void _listenerMethod() {
    same = passwordChecker();
    print("im in listening right now");
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

  bool passwordValidator() {
    if (passwordController.text.compareTo(validatePasswordController.text) ==
        0) {
      return validatedPwd = true;
    } else {
      return validatedPwd = false;
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
            title: Text('Lägg till en ny annons',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff96070a),
                )),
            centerTitle: true,
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
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 100.0),
                child: Image.asset('images/logo_frontpage.png'),
              ),
              Text('Register',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Form(
                key: _userKey,
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 50.0, right: 40.0, left: 40.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment(0.0, 0.0),
                            child: _image == null
                                ? Text('No image Selected')
                                :
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: 150.0,
                                maxWidth: 150.0,
                                minWidth: 150.0,
                                minHeight: 150.0,
                              ),
                              child: Image.file(_image),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: getImageGallery,
                            tooltip: 'Pick Image',
                            child: Icon(Icons.add_a_photo),
                          ),
                        ],
                      ),
                      TextFormField(
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Användarnamn',
                          icon: Icon(
                            Icons.person_add,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _userName = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _userEmail = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: passwordController,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: 'Lösenord',
                            icon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )),
                        validator: (value) =>
                        value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _password = value,
                      ),
                      Container(
                        //color: same,
                        child: TextFormField(
                            maxLines: 1,
                            controller: validatePasswordController,
                            obscureText: true,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: 'Repetera Lösenord',
                                icon: Icon(
                                  Icons.lock,
                                  color: same,
                                )),
                            validator: (value) =>
                            value.isEmpty
                                ? 'Detta fält kan inte vara tomt'
                                : null),
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
                    ? _userName + " är nu registrerad"
                    : 'Registreringen misslyckades')),
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
                      _success = await DataProvider
                          .of(context)
                          .user
                          .register(_userEmail, _userName, _password,
                          imageFileToString());
                      setState(() {});
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
}
