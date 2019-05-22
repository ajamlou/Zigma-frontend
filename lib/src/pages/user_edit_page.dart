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
  final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  Widget build(BuildContext context) {
    File image;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ändra Profildata"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              image = await Ih.showImageAlertDialog(context);
              print(image.toString());
              if(image != null){
              DataProvider.of(context).user.user.hasPicture = true;}
              setState(() {

              });
            },
            child: Container(
              width: 200,
              height: 200,
              child: !DataProvider.of(context).user.user.hasPicture
                  ? FittedBox(
                      child: Icon(Icons.person),
                      fit: BoxFit.cover,
                    )
                  : (image == null
                      ? Image.network(
                          DataProvider.of(context).user.picUrl(
                              DataProvider.of(context).user.user.profile),
                          fit: BoxFit.cover,
                        )
                      : Image.file(image)),
            ),
          ),
          Text(
            DataProvider.of(context).user.user.username,
            style: TextStyle(fontSize: 45),
          ),
          MaterialButton(
            child: Text("Ändra Användarnamn"),
            onPressed: () async {
              String newUsername = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit(
                      regExp: username,
                      title: "Användarnamn",
                      edit: DataProvider.of(context).user.user.username),
                ),
              );
              if (newUsername != DataProvider.of(context).user.user.username) {
                DataProvider.of(context).user.editUser("username", newUsername);
              }
            },
          ),
          Text(
            "Privat information",
          ),
          Card(
            color: Colors.grey[100],
            child: ListTile(
              onTap: () async {
                String newEmail = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Edit(
                        regExp: email,
                        title: "MejlAdress",
                        edit: DataProvider.of(context).user.user.email),
                  ),
                );
                if (newEmail != DataProvider.of(context).user.user.email) {
                  DataProvider.of(context).user.editUser('email', newEmail);
                }
              },
              leading: Text("Email"),
              trailing: Container(
                width: MediaQuery.of(context).size.width/2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(DataProvider.of(context).user.user.email),
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

