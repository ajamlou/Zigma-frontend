import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

enum ImageSource {
  photos,
  camera
}

class advertCreation extends StatefulWidget {
  State createState() => new advertCreationState();
}

class advertCreationState extends State<advertCreation>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _advertKey = GlobalKey<FormState>();
  String _title;

  AnimationController _animation;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFECE9DF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25.0),
                child: IconButton(
                  color: Color(0xFF96070a),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              )
            ],
          ),
          Form(
            key: _advertKey,
            child: Column(
              children: <Widget>[
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Title',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Title can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Pris',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Pris can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Författare',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Utgivningsår',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Upplaga',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'ISBN',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Taggar',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
                new TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: 'Ämne',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Författare can\'t be empty' : null,
                  onSaved: (value) => _title = value,
                ),
              ],
            ),
          ),
          Container(
            width: 150,
            child: MaterialButton(
              color: Color(0xFF008000),
              onPressed: () async {
                if (_advertKey.currentState.validate()) {
                  _advertKey.currentState.save();
                  _uploadNewAdvert();
                }
              },
              child:
                  Text("Ladda upp", style: TextStyle(color: Color(0xFFFFFFFF))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 500),
    );
  }

  void _uploadNewAdvert() {}
}
