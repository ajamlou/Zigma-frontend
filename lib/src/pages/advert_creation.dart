import 'package:flutter/material.dart';
import 'dart:io';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Im;

class AdvertCreation extends StatefulWidget {
  State createState() => AdvertCreationState();
}

class AdvertCreationState extends State<AdvertCreation> {
  //Image selector
  List<int> _selectedItemsIndex = [];

  //List for response
  List<dynamic> responseList;
  final GlobalKey<FormState> _advertKey = GlobalKey<FormState>();
  String _title; //Sent
  int _price; //Sent
  String _author; //Sent
  String _isbn; //Sent
  String _contactInfo;
  String edition;
  String transaction_type;
  String condition;
  List<Image> compressedImageList = [];
  List<String> encodedImageList = [];
  Image placeholderImage = Image.asset('images/placeholderBook.png');

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  @override
  void initState() {
    super.initState();
    compressedImageList.add(placeholderImage);
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
        body: transaction_type == null
            ? Center(
                child: Container(
                    child: Column(
                children: <Widget>[
                  Text('Vill du köpa eller sälja en bok?', style: TextStyle()),
                  Divider(),
                  Container(
                    child: MaterialButton(
                      color: Color(0xff96070a),
                      onPressed: () {
                        setState(() {
                          transaction_type = 'S';
                        });
                      },
                      child: Text('Sälja bror',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: MaterialButton(
                      color: Color(0xff96070a),
                      onPressed: () {
                        setState(() {
                          transaction_type = 'B';
                        });
                      },
                      child: Text('Köpa fam',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )))
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: compressedImageList.length,
                            itemBuilder: buildGallery,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: compressedImageList.length == 1
                                    ? Text('')
                                    : RaisedButton(
                                        color: Colors.red,
                                        child: const Text(
                                          'Ta bort markerade bilder',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: _remove,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 10.0),
                      child: Form(
                        key: _advertKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
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
                            Container(
                                width: 300,
                                child: Row(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Skick: '),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: dropdownMenu(),
                                  ),
                                ]))
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
                            showLoadingAlertDialog();
                            _advertKey.currentState.save();
                            responseList = await DataProvider.of(context)
                                .advertList
                                .uploadNewAdvert(_title, _price, _author, _isbn,
                                    _contactInfo, encodedImageList, context);
                            setState(() {
                              stsCode = responseList[0];
                            });
                          }
                          if (stsCode == 201) {
                            var a = await DataProvider.of(context)
                                .advertList
                                .getAdvertById(responseList[1]);
                            Navigator.of(context, rootNavigator: true)
                                .pop(null);
                            DataProvider.of(context)
                                .routing
                                .routeAdvertPage(context, a, true);
                          } else {
                            Navigator.of(context, rootNavigator: true)
                                .pop(null);
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

  void showLoadingAlertDialog() {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      title: Text(
        "Laddar...",
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
      content: DataProvider.of(context).loadingScreen,
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showAdvertCreationAlertDialog(int value) {
    String message = "";
    if (value == 400) {
      message = "Bad Request";
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
                getImage("gallery");
              },
            ),
            RaisedButton(
              color: Color(0xff96070a),
              child: Icon(Icons.camera_alt),
              onPressed: () {
                getImage("camera");
              },
            ),
          ],
        ));
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Widget buildGallery(BuildContext context, int index) {
    Image _galleryImage = compressedImageList[index];
    return GestureDetector(
      onTap: () {
        compressedImageList[index] == placeholderImage
            ? showImageAlertDialog()
            : setState(() {
                print('im in setState of gesturedetector');
                _selectedItemsIndex.contains(index)
                    ? _selectedItemsIndex.remove(index)
                    : _selectedItemsIndex.add(index);
                print(index);
                print(_selectedItemsIndex);
              });
      },
      child: _selectedItemsIndex.contains(index)
          ? Container(
              height: 250,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF008000),
                  width: 5,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 2.5),
              child: FittedBox(
                fit: BoxFit.cover,
                child: _galleryImage,
              ))
          : Container(
              height: 250,
              width: 150,
              margin: EdgeInsets.symmetric(horizontal: 2.5),
              child: FittedBox(
                fit: BoxFit.cover,
                child: _galleryImage,
              )),
    );
  }

  // Insert the new item to the lists
  void _insert(File _nextItem) {
    compressedImageList.add(Image.file(_nextItem));
    encodedImageList.add(Ih.imageFileToString(_nextItem));
    setState(() {});
  }

// Remove the selected items from the lists
  void _remove() {
    if (_selectedItemsIndex.length != 0) {
      for (int index = compressedImageList.length; index >= 0; index--) {
        if (_selectedItemsIndex.contains(index)) {
          compressedImageList.removeAt(index);
          encodedImageList.removeAt(index-1);
        }
        print(compressedImageList);
        print(encodedImageList);
      }
      setState(() {
        _selectedItemsIndex = [];
      });
    }
  }

  Future getImage(String inputSource) async {
    var image = inputSource == "camera"
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    var compressedImage = await compressImageFile(image);
    setState(() {
      _insert(compressedImage);
      print(encodedImageList.toString());
    });
    Navigator.of(context, rootNavigator: true).pop(null);
  }

  Future<File> compressImageFile(File _uploadedImage) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final int rand = new Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(_uploadedImage.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, 400);
    File compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(
        smallerImage,
        quality: 90,
      ));
    return compressedImage;
  }

  Widget dropdownMenu() {
    return Center(
      child: DropdownButton<String>(
        value: condition,
        onChanged: (String newValue) {
          setState(() {
            condition = newValue;
          });
        },
        items: <String>[
          'Nyskick',
          'Mycket gott skick',
          'Gott skick',
          'Hyggligt skick',
          'Dåligt skick'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
