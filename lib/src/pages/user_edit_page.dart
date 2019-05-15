import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class UserEditPage extends StatefulWidget {
  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ändra Profildata"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {},
            child: Container(
              width: 200,
              height: 200,
              child: DataProvider.of(context).user.user.image == null
                  ? FittedBox(child: Icon(Icons.person), fit: BoxFit.cover)
                  : Image.network(
                      DataProvider.of(context).user.user.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Text(DataProvider.of(context).user.user.username),
          MaterialButton(
            child: Text("Ändra Användarnamn"),
            onPressed: () {},
          ),
          Text("Privat information"),
          Card(
            color: Colors.grey[100],
            child: ListTile(
              onTap: () {},
              leading: Text("Email"),
              trailing: Text(DataProvider.of(context).user.user.email),
            ),
          ),
        ],
      ),
    );
  }
}
