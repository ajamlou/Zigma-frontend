import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'dart:io';
import 'package:image/image.dart' as Im;

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
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(DataProvider.of(context).user.user.email),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Edit extends StatefulWidget {
  final String title;
  final String edit;
  final RegExp regExp;

  Edit({this.edit, this.title, this.regExp});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController controller;
  final GlobalKey<FormState> _editKey = GlobalKey<FormState>();

  bool _emailListener() {
    setState(() {});
    return widget.regExp.hasMatch(controller.text);
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.edit);
    controller.addListener(_emailListener);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 3),
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    if (_editKey.currentState.validate()) {
                      Navigator.pop(context, controller.text);
                    }
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_left),
                        controller.text == widget.edit ? Text("Tillbaka"): Text("Ändra!")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              widget.title,
              style: TextStyle(fontSize: 25),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Form(
                key: _editKey,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(),
                  validator: (value) {
                    if (!_emailListener()) {
                      return 'Måste vara en godkänd mejladress';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
