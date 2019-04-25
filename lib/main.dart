import 'package:flutter/material.dart';
import 'package:zigma2/src/routes.dart';
import 'package:zigma2/src/pages/landing_page.dart';
import './src/DataProvider.dart';
import './src/advert.dart';
import './src/user.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdvertList advertList = AdvertList();
  UserMethodBody user = UserMethodBody(null);
  Routing routing = Routing();
  @override
  Widget build(BuildContext context) {
    return DataProvider(
      advertList: advertList,
      user: user,
      routing: routing,
      child: MaterialApp(
        title: 'Zigma App',
        home: LandingPage(),
        color: Color(0xFFECE9DF),
      ),
    );
  }

  void initState() {
    super.initState();
    print("im in initState in the main MyApp");
    //advertList.loadAdvertList();
    advertList.loadAdvertList();
  }
}


//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return
//  }
//



//class _MyAppState extends State<MyApp> {
//  final String url = "http://3ff52c0d.ngrok.io/api/adverts/";
//  List data;
//
//  Future<String> getData() async {
//    var res = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//    setState(() {
//      data = json.decode(utf8.decode(res.bodyBytes));
//
//    });
//    print("Data was successfully retrived");
//    return "Success!";
//  }



//  @override
//  void initState() {
//    super.initState();
//    this.getData();
//  }



class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Center(
          child: CircularProgressIndicator()
        );
  }
}

//class User {
//  String email;
//  int id;
//  String username;
//  String token;
//
//  User(this.email, this.id, this.token, this.username);
//
//  User.fromJson(Map<String, dynamic> json)
//      : email = json['email'],
//        username = json['username'],
//        id = json['id'],
//        token = json['token'];
//}
//


