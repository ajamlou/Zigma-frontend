import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zigma2/src/landing_page.dart';
import 'DataProvider.dart';

File _image;

class AdvertCreation extends StatefulWidget {
  State createState() => AdvertCreationState();
}

class AdvertCreationState extends State<AdvertCreation> {
  //Image selector


  final GlobalKey<FormState> _advertKey = GlobalKey<FormState>();
  String _title; //Sent
  int _price; //Sent
  String _author; //Sent
  String _isbn; //Sent
  String _contactInfo;
  int randomInt = 42;
  FocusNode myFocusNode;
  bool isLoading = false;







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
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xff96070a)),
                ),
              )
            : Container(
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
                              ? Text('')
                              : Container(
                                  child: Image.file(_image),
                                  width: 150,
                                  height: 150,
                                ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            showImageAlertDialog();
                            },
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
                              // maxLength: 4,
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: MaterialButton(
                        color: Color(0xFF008000),
                        onPressed: () async {
                          int stsCode;
                          if (_advertKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _advertKey.currentState.save();
                            int temp = await DataProvider.of(context)
                                .advertList
                                .uploadNewAdvert(_title, _price, _author, _isbn,
                                    _contactInfo, context);
                            setState(() {
                              stsCode = temp;
                            });
                          }
                          if (stsCode == 201) {
                            routeLandingPage();
                          } else if (stsCode == 400) {
                            setState(() {
                              isLoading = false;
                            });
                            showAdvertCreationAlertDialog(stsCode);
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

  void showAdvertCreationAlertDialog(int value) {
    String message;
    if (value == 400) {
      message = "Priset är för högt, maxpris är 9999kr per bok";
    } else if (value == 500) {
      message = "Server Error, testa igen";
    }
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showImageAlertDialog() {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      title: Text(
        "Kamera eller Galleri?",
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
      content: ButtonBar(
        children: <Widget>[
          RaisedButton(
            color: Color(0xff96070a),
            child: Icon(Icons.image),
            onPressed: () {
               getImageGallery();
            },
          ),
          RaisedButton(
            color: Color(0xff96070a),
            child:Icon(Icons.camera_alt),
            onPressed: () {
               getImageCamera();
            },
          ),
        ],
      )
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);

  }


  void routeLandingPage() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LandingPage()));
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    Navigator.of(context, rootNavigator: true).pop(null);
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    Navigator.of(context, rootNavigator: true).pop(null);
  }


}
