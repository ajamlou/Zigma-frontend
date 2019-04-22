import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'advert.dart';
import 'DataProvider.dart';
File _image;
Animation<double> _animation;

class AdvertCreation extends StatefulWidget {
  State createState() => new AdvertCreationState();
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext contet) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: _animation.value,
        maxWidth: _animation.value,
        minWidth: _animation.value,
        minHeight: _animation.value,
      ),
      child: Image.file(_image),
    );
  }
}

class AdvertCreationState extends State<AdvertCreation>
    with TickerProviderStateMixin {
  //Image selector

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
  String _isbn; //Sent
  String _contactInfo;
  int randomInt = 42;
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _animation = Tween<double>(begin: 0, end: 150).animate(_controller)
      ..addStatusListener((status) {
      })
      ..addStatusListener((state) => print('$state'));
    _controller.forward();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFECE9DF),
      child: new Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Color(0xff96070a)),
            elevation: 0.0,
            backgroundColor: Color(0xff96070a),
            title: Text('Lägg till en ny annons',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                )),
            centerTitle: true,
            leading: new Container(
              child: IconButton(
                color: Color(0xFFFFFFFF),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            actions: <Widget>[],
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    child: _image == null
                        ? Text('No image Selected')
                        : AnimatedLogo(
                            animation: _animation,
                          ),
                  ),
                  FloatingActionButton(
                    onPressed: getImageCamera,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
                child: Form(
                  key: _advertKey,
                  child: new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFFFFFFFF),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(20.0, 20.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          focusNode: myFocusNode,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          decoration: new InputDecoration(
                            hintText: 'Titel',
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
                          validator: (value) => value.isEmpty
                              ? 'Författare can\'t be empty'
                              : null,
                          onSaved: (value) => _author = value,
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
                            hintText: 'Kontaktinformation',
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Taggar can\'t be empty' : null,
                          onSaved: (value) => _contactInfo = value,
                        ),
                      ],
                    ),
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
                  child: Text("Ladda upp",
                      style: TextStyle(color: Color(0xFFFFFFFF))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  Future<String> _uploadNewAdvert() async {
    Advert _newAd = new Advert(_title, _price, _author, _isbn, _contactInfo);
    var data = json.encode(_newAd);
    print(data);
    String postURL = "https://2e2bedf4.ngrok.io/adverts/adverts/?format=json";
    return await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token "+ DataProvider.of(context).user.getToken()
    }).then((dynamic res) {
      final String resBody = res.body;
      print(json.decode(resBody));
    });
  }
}
