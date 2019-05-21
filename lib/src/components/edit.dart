import 'package:flutter/material.dart';


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
          Size.fromHeight(MediaQuery
              .of(context)
              .size
              .height / 3),
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
                        controller.text == widget.edit
                            ? Text("Tillbaka")
                            : Text("Ändra!")
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