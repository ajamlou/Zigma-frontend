import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zigma2/src/image_handler.dart' as Ih;

class MultipleImagePicker extends StatefulWidget {
  final List<String> images;
  final bool edit;

  MultipleImagePicker({this.images, this.edit});

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  List<int> _selectedItemsIndex = [];
  List<Image> compressedImageList = [];
  List<String> encodedImageList = [];
  Image placeholderImage = Image.asset('images/placeholderBook.png');

  @override
  void initState() {
    for (String item in widget.images) {
      compressedImageList.add(Image.network(item));
      encodedImageList.add("Placeholder");
    }
    compressedImageList.add(placeholderImage);
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
      ],
    );
  }

  Widget buildGallery(BuildContext context, int index) {
    Image _galleryImage = compressedImageList[index];
    return GestureDetector(
      onTap: () async {
        compressedImageList[index] == placeholderImage
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
      compressedImageList.insert(
          compressedImageList.length - 1, Image.file(_nextItem));
      encodedImageList.add(Ih.imageFileToString(_nextItem));
      setState(() {});
    }
  }

// Remove the selected items from the lists
  void _remove() {
    if (_selectedItemsIndex.length != 0) {
      for (int index = compressedImageList.length; index >= 0; index--) {
        if (_selectedItemsIndex.contains(index)) {
          compressedImageList.removeAt(index);
          encodedImageList.removeAt(index);
        }
      }
      setState(() {
        _selectedItemsIndex = [];
      });
    }
  }
}
