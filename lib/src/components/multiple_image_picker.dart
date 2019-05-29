import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zigma2/src/image_handler.dart' as Ih;

import '../DataProvider.dart';

class ImageItem {
  final Image compressedImage;
  final String encodedImage;
  final int id;
  bool selected;
  final bool isFirst;
  final bool isNew;

  ImageItem(
      {this.id,
      this.compressedImage,
      this.encodedImage,
      this.isFirst = false,
      this.selected = false,
      this.isNew = false});

  @override
  String toString() {
    String s = compressedImage.toString() +
        encodedImage.toString() +
        id.toString() +
        selected.toString() +
        isFirst.toString() +
        isNew.toString();
    super.toString();
    return s;
  }
}

class MultipleImagePicker extends StatefulWidget {
  final List<String> images;
  final int id;

  MultipleImagePicker({this.images, this.id});

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  Image placeholderImage = Image.asset('images/placeholderBook.png');
  List<ImageItem> _images = [];
  List<ImageItem> _stateHolder;
  List<int> _imgToRemove = [];

  @override
  void initState() {
    //extract id:s from the list of images
    for (String image in widget.images) {
      List l = image.split("/");
      _images.add(
        ImageItem(
          id: int.parse(
            l[l.length - 2],
          ),
          compressedImage: Image.network(image),
        ),
      );
    }
    //Add the placeholder image that you click on to add more images
    _images.add(
      ImageItem(
        compressedImage: placeholderImage,
        isFirst: true,
      ),
    );
    _stateHolder = List<ImageItem>.from(_images);
    super.initState();
  }

  //checks if any picture is selected
  bool anySelected() {
    for (ImageItem item in _images) {
      if (item.selected) {
        return true;
      }
    }
    return false;
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
            itemCount: _images.length,
            itemBuilder: buildGallery,
          ),
        ),
        anySelected() //if any is selected, show row
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      width: 300,
                      child: RaisedButton(
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
            : Container(), // show nothing
        !listIdentical()
            ? Container(
                width: 300,
                child: RaisedButton(
                  color: Colors.lightBlue[400],
                  onPressed: () {
                    editImages();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Spara bildförändringar!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  bool listIdentical() {
    if (_stateHolder.toString().compareTo(_images.toString()) == 0)
      return true;
    else
      return false;
  }

  Widget buildGallery(BuildContext context, int index) {
    Image _galleryImage = _images[index].compressedImage;
    return GestureDetector(
      onTap: () async {
        _images[index].isFirst
            ? _insert(await Ih.showImageAlertDialog(context))
            : setState(() {
                _images[index].selected = !_images[index].selected;
              });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _images[index].selected
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
      _images.insert(
        _images.length - 1,
        ImageItem(
            compressedImage: Image.file(_nextItem),
            encodedImage: Ih.imageFileToString(_nextItem),
            isNew: true),
      );
      setState(() {});
    }
  }

  //sends the images that has been changed to the http:request methods
  void editImages() {
    if (_imgToRemove.length != 0) {
      DataProvider.of(context)
          .advertList
          .editAdvert('delete_images', _imgToRemove, widget.id, context);
    }
    List _imagesToUpload = imagesToUpload();
    if (_imagesToUpload.length != 0) {
      DataProvider.of(context)
          .advertList
          .editAdvert('new_images', _imagesToUpload, widget.id, context);
    }
  }

  //checks which images to upload and sorts their base64 strings into a List
  List<String> imagesToUpload() {
    List<String> imagesToUpload = [];
    for (ImageItem item in _images) {
      if (item.isNew) {
        imagesToUpload.add(item.encodedImage);
      }
    }
    return imagesToUpload;
  }

  //checks if item was from previous advert and puts them in the remove list
  void checkItem(ImageItem item) {
    if (item.selected && !item.isNew) {
      _imgToRemove.add(item.id);
    }
  }

// Remove the selected items from the lists
  void _remove() {
    setState(() {
      _images.forEach((item) => checkItem(item));
      _images.removeWhere((item) => item.selected);
    });
    setState(() {});
  }
}
