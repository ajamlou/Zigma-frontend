import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/advertPageBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(
              child: IconButton(
                color: Color(0xFFFFFFFF),
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
          body: Column(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(
                        top: BorderSide(width: 3.0, color: Color(0xFF95453)),
                        left: BorderSide(width: 3.0, color: Color(0xFF95453)),
                        right: BorderSide(width: 3.0, color: Color(0xFF95453)),
                        bottom: BorderSide(width: 3.0, color: Color(0xFF95453)),
                      )),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      DataProvider.of(context).user.getImage(),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
