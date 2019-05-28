import 'package:flutter/material.dart';
import 'package:zigma2/src/components/dialog_content.dart';
import 'dart:io';
import 'package:zigma2/src/image_handler.dart' as Ih;
import 'package:flutter/services.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:barcode_scan/barcode_scan.dart';

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
  String transactionType;
  String condition;
  bool isSelected;
  List<Image> compressedImageList = [];
  List<String> encodedImageList = [];
  Image placeholderImage = Image.asset('images/placeholderBook.png');

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController contactInfoController;
  TextEditingController editionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    authorController.dispose();
    priceController.dispose();
    contactInfoController.dispose();
  }

  @override
  void initState() {
    super.initState();
    compressedImageList.add(placeholderImage);
    titleController.addListener(_listener);
    authorController.addListener(_listener);
    priceController.addListener(_listener);
    //delays the appearance of whatever is in this method by one frame
    //so that the build method has time to build before it is called
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isSelected = await DataProvider.of(context).user.getTutorialPrefs();
    });
  }

  void showScannerInfoDialog() {
    AnimatedPadding dialog = AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.only(
              top: 50.0,
              bottom: MediaQuery.of(context).size.height - 450.0,
              left: MediaQuery.of(context).size.width - 200.0),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: DialogContent(isSelected: isSelected,),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }


  @override
  Widget build(BuildContext context) {
    contactInfoController =
        TextEditingController(text: DataProvider.of(context).user.user.email);
    contactInfoController.addListener(_listener);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Color(0xFFAEDBD3),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text('Lägg till en ny annons',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF373F51),
                fontSize: 20,
              )),
          centerTitle: true,
          leading: Container(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          actions: <Widget>[
            transactionType == null
                ? SizedBox()
                : IconButton(
                    icon: Icon(
                      Icons.linked_camera,
                      size: 30,
                    ),
                    onPressed: () async {
                      String s = await _scanQR();
                      print(s);
                    },
                  ),
          ],
        ),
      ),
      body: AnimatedCrossFade(
        firstCurve: Curves.easeOutCubic,
        secondCurve: Curves.easeInCubic,
        duration: Duration(milliseconds: 200),
        firstChild: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 100.0, left: 20, right: 20, bottom: 50),
              child: Text(
                'Söker du efter en bok eller vill du sälja en bok?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 50,
              width: 300,
              child: RaisedButton(
                elevation: 5,
                color: Color(0xFFECA72C),
                onPressed: () {
                  setState(() {
                    transactionType = 'S';
                  });
                  if(!isSelected){showScannerInfoDialog();}
                },
                child: Text('Sälja',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              height: 50,
              width: 300,
              child: RaisedButton(
                elevation: 5,
                color: Color(0xFFECA72C),
                onPressed: () {
                  setState(() {
                    transactionType = 'B';
                  });
                  if(!isSelected){showScannerInfoDialog();}
                },
                child: Text('Söker',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )),
        secondChild: Container(
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
                    color: Colors.transparent,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: compressedImageList.length,
                      itemBuilder: buildGallery,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          width: 300,
                          child: compressedImageList.length == 1
                              ? Text('')
                              : RaisedButton(
                                  color: Color(0xFFDE5D5D),
                                  child: const Text(
                                    'Ta bort markerade bilder',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: _remove,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    transactionType == "S" ? "Säljesannons" : "Sökessannons",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                child: Form(
                  key: _advertKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        maxLines: 1,
                        controller: titleController,
                        cursorColor: Color(0xFF373F51),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Titel',
                          suffixIcon: titleController.text == ""
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xFF373F51))
                              : Icon(Icons.check, color: Color(0xFF3FBE7E)),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Obligatoriskt Fält' : null,
                        onSaved: (value) => _title = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: priceController,
                        cursorColor: Color(0xFFDE5D5D),
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        // maxLength: 4,
                        decoration: InputDecoration(
                          hintText: 'Pris',
                          suffixIcon: priceController.text.length > 4 ||
                                  priceController.text == ""
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xFF373F51))
                              : Icon(Icons.check, color: Color(0xFF3FBE7E)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Obligatoriskt Fält';
                          } else if (value.length > 4) {
                            return 'Priset får inte överstiga 9999kr';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _price = stringToInt(value),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: authorController,
                        cursorColor: Color(0xFFDE5D5D),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Författare',
                          suffixIcon: authorController.text.length < 5 ||
                                  !authorController.text.contains(" ")
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xFF373F51))
                              : Icon(Icons.check, color: Color(0xFF3FBE7E)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Obligatoriskt Fält';
                          } else if (!value.contains(" ")) {
                            return 'Författaren måste ha både förnamn och efternamn';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _author = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        cursorColor: Color(0xFFDE5D5D),
                        keyboardType: TextInputType.text,
                        controller: isbnController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'ISBN',
                        ),
                        onSaved: (value) => _isbn = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: contactInfoController,
                        cursorColor: Color(0xFFDE5D5D),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Kontaktinformation',
                          suffixIcon: contactInfoController.text == ""
                              ? Icon(Icons.star,
                                  size: 10, color: Color(0xFF373F51))
                              : Icon(Icons.check, color: Color(0xFF3FBE7E)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Obligatoriskt Fält';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _contactInfo = value,
                      ),
                      TextFormField(
                        maxLines: 1,
                        cursorColor: Color(0xFFDE5D5D),
                        controller: editionController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Upplaga',
                        ),
                        onSaved: (value) => edition = value,
                      ),
                      Container(
                          width: 600,
                          child: Row(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Text('Skick: ',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: dropdownMenu(),
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  padding: EdgeInsets.only(top: 35),
                  width: 300,
                  child: MaterialButton(
                    color: Color(0xFF3FBE7E),
                    onPressed: () async {
                      int stsCode;
                      if (_advertKey.currentState.validate()) {
                        DataProvider.of(context).loadingScreen.show(context);
                        _advertKey.currentState.save();
                        responseList = await DataProvider.of(context)
                            .advertList
                            .uploadNewAdvert(
                                _title,
                                _price,
                                _author,
                                _isbn,
                                _contactInfo,
                                encodedImageList,
                                condition,
                                transactionType,
                                edition,
                                context,
                                compressedImageList);
                        setState(() {
                          stsCode = responseList[0];
                        });
                        if (stsCode == 201) {
                          //Confirmed response
                          Navigator.of(context, rootNavigator: true).pop(null);
                          DataProvider.of(context)
                              .routing
                              .routeAdvertPage(context, responseList[1], true);
                        } else {
                          //Unsuccessful response
                          Navigator.of(context, rootNavigator: true).pop(null);
                          showAdvertCreationAlertDialog(stsCode);
                        }
                      }
                    },
                    child: Text("Ladda upp",
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
        crossFadeState: transactionType == null
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }

  void couldNotFindBook() {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      content: Text(
        "Boken du försökte lägga upp fanns inte i vår databas. Men lägg gärna in den manuellt",
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFFDE5D5D),
        ),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Future<String> _scanQR() async {
    String qRResult = await BarcodeScanner.scan();
    DataProvider.of(context).loadingScreen.show(context);
    List l = await DataProvider.of(context).advertList.searchAdverts(qRResult);
    Navigator.of(context, rootNavigator: true).pop(null);
    if (l.length == 0) {
      couldNotFindBook();
      setState(() {
        isbnController.text = qRResult;
      });
      return qRResult;
    }
    var a = l[0];
    setState(() {
      editionController.text = a.edition;
      authorController.text = a.authors;
      titleController.text = a.bookTitle;
      isbnController.text = a.isbn;
    });
    return qRResult;
  }

  void _listener() {
    setState(() {});
  }

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  Widget stateButtons(String text, String index) {
    return Container(
      alignment: Alignment(0, 0),
      width: MediaQuery.of(context).size.width / 3.3,
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFFECA72C)),
          color: index == transactionType ? Color(0xFFECA72C) : Colors.white),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            index != transactionType
                ? transactionType = index
                : transactionType = transactionType;
          });
        },
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  index == transactionType ? Colors.white : Color(0xFFECA72C)),
        ),
      ),
    );
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
          color: Color(0xFFDE5D5D),
        ),
        textAlign: TextAlign.center,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showImageAlertDialog() {
    File tempImage;
    AlertDialog dialog = AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Välj från galleri eller fota med kameran.",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF373F51),
          ),
          textAlign: TextAlign.center,
        ),
        content: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          child: ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Color(0xFFECA72C),
                child: Icon(Icons.image, color: Colors.white),
                onPressed: () async {
                  tempImage = await Ih.getImage("gallery");
                  _insert(tempImage);
                  Navigator.pop(context, true);
                },
              ),
              RaisedButton(
                color: Color(0xFFECA72C),
                child: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () async {
                  tempImage = await Ih.getImage("camera");
                  _insert(tempImage);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
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
                _selectedItemsIndex.contains(index)
                    ? _selectedItemsIndex.remove(index)
                    : _selectedItemsIndex.add(index);
              });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _selectedItemsIndex.contains(index)
            ? Container(
                height: 250,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF3FBE7E),
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
      ),
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
          encodedImageList.removeAt(index - 1);
        }
      }
      setState(() {
        _selectedItemsIndex = [];
      });
    }
  }

  Widget dropdownMenu() {
    return Center(
      child: Container(
        width: 215,
        child: DropdownButton<String>(
          isExpanded: true,
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
      ),
    );
  }
}
