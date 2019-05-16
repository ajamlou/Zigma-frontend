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
              child: DataProvider.of(context).user.user.hasPicture
                  ? FittedBox(
                      child: Icon(Icons.person),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      DataProvider.of(context)
                          .user
                          .picUrl(DataProvider.of(context).user.user.profile),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Text(
            DataProvider.of(context).user.user.username,
            style: TextStyle(fontSize: 45),
          ),
          MaterialButton(
            child: Text("Ändra Användarnamn"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit(
                      title: "Användarnamn",
                      edit: DataProvider.of(context).user.user.username),
                ),
              );
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
                        title: "MejlAdress",
                        edit: DataProvider.of(context).user.user.email),
                  ),
                );
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

class Edit extends StatelessWidget {
  final String title;
  final String edit;

  Edit({this.edit, this.title});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: edit);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/3),
        child: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Row(
            children: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Container(
                  child: Row(
                    children: <Widget>[Icon(Icons.arrow_left), Text("Ändra!")],
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
            title,
            style: TextStyle(fontSize: 25),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}
