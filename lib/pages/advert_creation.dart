import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zigma2/pages/landing_page.dart';
import 'DataProvider.dart';

File _image;
Animation<double> _animation;

class AdvertCreation extends StatefulWidget {
  State createState() => AdvertCreationState();
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
  int _price; //Sent
  String _author; //Sent
  String _isbn; //Sent
  String _contactInfo;
  int randomInt = 42;
  FocusNode myFocusNode;
  AnimationController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _animation = Tween<double>(begin: 0, end: 150).animate(_controller)
      ..addStatusListener((status) {})
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

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFECE9DF),
      child: Scaffold(
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
            leading: Container(
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
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
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xFFFFFFFF),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(20.0, 20.0)),
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                focusNode: myFocusNode,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Titel',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? 'Obligatoriskt Fält' : null,
                                onSaved: (value) => _title = value,
                              ),
                              TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Pris',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? 'Obligatoriskt Fält' : null,
                                onSaved: (value) => _price = stringToInt(value),
                              ),
                              TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Författare',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? 'Obligatoriskt Fält' : null,
                                onSaved: (value) => _author = value,
                              ),
                              TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'ISBN',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? 'Obligatoriskt Fält' : null,
                                onSaved: (value) => _isbn = value,
                              ),
                              TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Kontaktinformation',
                                ),
                                validator: (value) =>
                                    value.isEmpty ? 'Obligatoriskt Fält' : null,
                                onSaved: (value) => _contactInfo = value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      child: MaterialButton(
                        color: Color(0xFF008000),
                        onPressed: () async {
                          int stsCode;
                          if (_advertKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _advertKey.currentState.save();
                              stsCode = await DataProvider
                                  .of(context)
                                  .advertList
                                  .uploadNewAdvert(
                                  _title, _price, _author, _isbn,
                                  _contactInfo, context);
                          }
                          if(stsCode == 201){
                          routeLandingPage();
                          }
                          else if(stsCode == 400 || stsCode == 500){
                            setState(() {
                              isLoading = false;
                            });
                            createAlertDialog();
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

  createAlertDialog(){

  }

  void routeLandingPage() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LandingPage()));
  }
}
