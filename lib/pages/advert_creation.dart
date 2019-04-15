import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class advertCreation extends StatefulWidget {
  State createState() => new advertCreationState();
}

class advertCreationState extends State<advertCreation>
    with TickerProviderStateMixin {
  //Image selector
  File _image;

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  final GlobalKey<FormState> _advertKey = GlobalKey<FormState>();
  String _title; //Sent
  String _price; //Sent
  String _author; //Sent
  String _yearPublished;
  String _edition;
  String _isbn; //Sent
  String _contactInfo;
  String _subject;

  AnimationController _animation;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFECE9DF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 50.0),
                child: Text('Lägg till en ny annons'),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment(0.0, 0.0),
                child: _image == null
                    ? Text('No image Selected')
                    : Container(
                        constraints: BoxConstraints(
                          maxHeight: 150.0,
                          maxWidth: 150.0,
                          minWidth: 150.0,
                          minHeight: 150.0,
                        ),
                        child: Image.file(_image),
                      ),
              ),
              FloatingActionButton(
                onPressed: getImageCamera,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
            ],
          ),
          Form(
            key: _advertKey,
            child: new Container(
              decoration: new BoxDecoration(
                color: Color(0xFFFFFFFF),
                gradient: new LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFECE9DF)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0)),
              ),
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
                    onSaved: (value) => _price = value,
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
                    onSaved: (value) => _author = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Utgivningsår',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Utgivningsår can\'t be empty' : null,
                    onSaved: (value) => _yearPublished = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Upplaga',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Upplaga can\'t be empty' : null,
                    onSaved: (value) => _edition = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'ISBN',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'ISBN can\'t be empty' : null,
                    onSaved: (value) => _isbn = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Contact info',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Taggar can\'t be empty' : null,
                    onSaved: (value) => _contactInfo = value,
                  ),
                  new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Ämne',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Ämne can\'t be empty' : null,
                    onSaved: (value) => _subject = value,
                  ),
                ],
              ),
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


  Future<String> _uploadNewAdvert() async {
    Advert _newAd = new Advert(_title, _price, _author, _isbn, _contactInfo);
    print(_newAd);
    var data = json.encode(_newAd);
    String postURL = "https://5f1a5767.ngrok.io/api/adverts/?format=json";
      var resp = await http
          .post(Uri.encodeFull(postURL), body: data);
      print("ack recieved");
      return "success";
  }
}

class Advert {
  String title; //Skickas
  String price; //Skickas som int
  String authors; //Skickas
  String ISBN; //Skickas
  String state = "A";
  String transaction_type = "S";
  String contactInfo;

  Advert(
    this.title,
    this.price,
    this.authors,
    this.ISBN,
    this.contactInfo
  );

  Map<String, dynamic> toJson() =>
  {'title': title,
  'price': price,
  'authors': authors,
  'ISBN': ISBN,
  'contact_info': contactInfo};

  String toString() {
    String adToString = ("title: " +
        this.title +
        ",\nprice: " +
        this.price +
        ",\nauthors: " +
        this.authors +
        ",\nISBN: " +
        this.ISBN +
        ",\ncontactInfo: " +
        this.contactInfo +
        ",\nstate: " +
        this.state +
        ",\ntransaction_type: " +
        this.transaction_type);
    return adToString;
  }
}
