import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        color: Colors.yellow,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(
              child: IconButton(
                color: Color(0xff96070a),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            iconTheme: IconThemeData(color: Color(0xff96070a)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(

          ),
        ),
      ),
    );
  }
}
