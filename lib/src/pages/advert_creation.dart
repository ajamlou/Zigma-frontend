import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Im;
import 'package:flutter/foundation.dart';

class AdvertCreation extends StatefulWidget {
  State createState() => AdvertCreationState();
}

class AdvertCreationState extends State<AdvertCreation> {
  //Image selector
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  File _selectedItem;
  int _nextItem;
  final GlobalKey<FormState> _advertKey = GlobalKey<FormState>();
  String _title; //Sent
  int _price; //Sent
  String _author; //Sent
  String _isbn; //Sent
  String _contactInfo;
  bool isLoading = false;
  ListModel<File> compressedImageList;
  List<String> encodedImageList = [];

  String imageFileToString(File _image) {
    String imageString = _image.toString();
    print(imageString);
    if (_image != null) {
      imageString = base64.encode(_image.readAsBytesSync());
      return "data:image/jpg;base64," + imageString;
    } else
      return null;
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
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xff96070a)),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15.0),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        compressedImageList.length == 0
                            ? Text('')
                            : Expanded(
                                child: AnimatedList(

                                  shrinkWrap: true,
                                  key: _listKey,
                                  initialItemCount: compressedImageList.length,
                                  itemBuilder: buildGallery,
                                ),
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FloatingActionButton(
                              onPressed: () {
                                showImageAlertDialog();
                              },
                              tooltip: 'Pick Image',
                              child: Icon(Icons.add_a_photo),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: _remove,
                              tooltip: 'remove the selected item',
                            ),
                          ],
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
                                    _contactInfo, encodedImageList, context);
                            setState(() {
                              stsCode = temp;
                            });
                          }
                          if (stsCode == 201) {
                            DataProvider.of(context)
                                .routing
                                .routeLandingPage(context);
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

  @override
  void initState() {
    super.initState();
    compressedImageList = ListModel<File>(
      listKey: _listKey,
      initialItems: <File>[],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  Widget buildGallery(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: Image.file(
        compressedImageList[index],
        width: 100.0,
        height: 50.0,
      ),
      selected: _selectedItem == compressedImageList[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == compressedImageList[index]
              ? null
              : compressedImageList[index];
        });
      },
    );
  }

  Widget _buildRemovedItem(
      int index, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: Image.file(
        compressedImageList[index],
        width: 100.0,
        height: 100.0,
      ),
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  void _insert(File _nextItem) {
    final int index = _selectedItem == null
        ? compressedImageList.length
        : compressedImageList.indexOf(_selectedItem);
    compressedImageList.insert(index, _nextItem);
    encodedImageList.add(imageFileToString(_nextItem));
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      compressedImageList.removeAt(compressedImageList.indexOf(_selectedItem));
   //   encodedImageList.remove(_selectedItem);
      setState(() {
        _selectedItem = null;
      });
    }
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
    Im.Image smallerImage = Im.copyResize(image, 300);
    File compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(
        smallerImage,
        quality: 85,
      ));
    return compressedImage;
  }
}

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    List<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = initialItems;

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList?.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected: false})
      : assert(animation != null),
        assert(item != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final Image item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 128.0,
              child: Center(
                child: item,
              ),
            ),
          ),
        ),
    );
  }
}
