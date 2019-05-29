import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zigma2/src/image_handler.dart' as Ih;

import '../DataProvider.dart';

class MultipleImagePicker extends StatefulWidget {
  final List<String> images;
  final bool edit;
  final int id;

  MultipleImagePicker({this.images, this.edit, this.id});

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  List<int> _selectedItemsIndex = [];
  List<Image> _compressedImageList = [];
  List<String> _encodedImageList = [];
  int _originalListLength;
  Image placeholderImage = Image.asset('images/placeholderBook.png');

  @override
  void initState() {
    for (String item in widget.images) {
      _compressedImageList.add(Image.network(item));
      _encodedImageList.add("placeholder");
    }
    _compressedImageList.add(placeholderImage);
    _originalListLength = _compressedImageList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 150.0,
          color: Colors.transparent,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _compressedImageList.length,
            itemBuilder: buildGallery,
          ),
        ),
        _selectedItemsIndex.length > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      width: 300,
                      child: _compressedImageList.length == 1
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
              )
            : Container(),
        _originalListLength != _compressedImageList.length
            ? Container(
                width: 300,
                child: RaisedButton(
                  color: Colors.lightBlue[400],
                  onPressed: () {},
                  child: Text("Ändra bilder!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildGallery(BuildContext context, int index) {
    Image _galleryImage = _compressedImageList[index];
    return GestureDetector(
      onTap: () async {
        _compressedImageList[index] == placeholderImage
            ? _insert(await Ih.showImageAlertDialog(context))
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
    if (_nextItem != null) {
      _compressedImageList.insert(
          _compressedImageList.length - 1, Image.file(_nextItem));
//      DataProvider.of(context).user.editAdvert(
//          'new_images', [Ih.imageFileToString(_nextItem)], widget.id);
      setState(() {});
    }
  }

  Future<void> editImages() async {


  }

// Remove the selected items from the lists
  void _remove() {
    print(_selectedItemsIndex.toString());
    print(_compressedImageList.toString());
    print(_encodedImageList.toString());
    if (_selectedItemsIndex.length != 0) {
      for (int i = 0; i >= _selectedItemsIndex.length; i++) {
          _compressedImageList.removeAt(_selectedItemsIndex[i]);
          _encodedImageList.removeAt(_selectedItemsIndex[i]);
      }
      _selectedItemsIndex = [];
      setState(() {});
    }
  }
}
