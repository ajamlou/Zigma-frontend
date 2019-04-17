import 'package:flutter/material.dart';
import './pages/landing_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  final Widget child;
  final List data;
  MyApp({this.child, this.data});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String url = "http://3ff52c0d.ngrok.io/api/adverts/";
  List data;

  Future<String> getData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = json.decode(utf8.decode(res.bodyBytes));

    });
    print("Data was successfully retrived");
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zigma App',
      home: LandingPage(
          refreshPage: getData,
      ),
      color: Color(0xFFECE9DF),
    );
  }
  @override
  void initState() {
    super.initState();
    this.getData();
  }
}

class InheritedAdvertsList extends InheritedWidget {
  final List data;
  InheritedAdvertsList({this.data, Widget MyApp()})
      : assert(MyApp != null),
        super(child: MyApp());

  static InheritedAdvertsList of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedAdvertsList) as InheritedAdvertsList;
  }

  @override
  bool updateShouldNotify(InheritedAdvertsList old) {
    return true;
  }
}

class User {
  String email;
  int id;
  String username;
  String token;

  User(this.email, this.id, this.token, this.username);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        id = json['id'],
        token = json['token'];
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Center(
          child: CircularProgressIndicator()
        );
  }
}


