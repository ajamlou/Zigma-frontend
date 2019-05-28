import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/components/edit.dart';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'dart:io';

class UserEditPage extends StatefulWidget {
  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final RegExp username = RegExp(r'^.{0,12}$');

  //File image;
  final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  Widget build(BuildContext context) {
    var user = DataProvider.of(context).user.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Redigera profil",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF373F51),
            )),
        backgroundColor: Color(0xFFAEDBD3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              File image = await Ih.showImageAlertDialog(context);
              if (image != null) {
                user.hasPicture = true;
                user.profilePic = Image.file(image);
                String base64 = Ih.imageFileToString(image);
                DataProvider.of(context)
                    .user
                    .editUser("profile_picture", base64);
                setState(() {});
              }
            },
            child: Container(
              width: 200,
              height: 200,
              child: !user.hasPicture
                  ? FittedBox(
                      child: Icon(Icons.person),
                      fit: BoxFit.cover,
                    )
                  : user.profilePic,
            ),
          ),
          Text(
            user.username,
            style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color(0xFFECA72C)),
          ),
          MaterialButton(
            child: Text("Ändra användarnamn",
                style: TextStyle(
                  color: Color(0xFF373F51),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            onPressed: () async {
              String newUsername = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit(
                      regExp: username,
                      title: "Användarnamn",
                      edit: user.username),
                ),
              );
              if (newUsername != user.username) {
                DataProvider.of(context).user.editUser("username", newUsername);
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              "Privat information",
            ),
          ),
          Card(
            color: Colors.grey[100],
            child: ListTile(
              onTap: () async {
                String newEmail = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Edit(
                        regExp: email, title: "Email-adress", edit: user.email),
                  ),
                );
                if (newEmail != user.email) {
                  DataProvider.of(context).user.editUser('email', newEmail);
                }
              },
              leading: Text("Email"),
              trailing: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(user.email),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
