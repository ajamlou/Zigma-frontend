import 'package:flutter/material.dart';
import './pages/landing_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String url = "http://5f1a5767.ngrok.io/api/adverts/";
  List data;

  Future<String> getData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = json.decode(utf8.decode(res.bodyBytes));

    });
    return "Success!";
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zigma App',
      home: LandingPage(data: data),
      color: Color(0xFFECE9DF),
    );
  }
  @override
  void initState() {
    super.initState();
    this.getData();
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Center(
          child: CircularProgressIndicator()
        );
  }
}


