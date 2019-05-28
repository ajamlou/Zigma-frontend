import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'dart:io';



Future<File> getImage(String inputSource) async {
  var image = inputSource == "camera"
      ? await ImagePicker.pickImage(source: ImageSource.camera)
      : await ImagePicker.pickImage(source: ImageSource.gallery);
  var compressedImage = await compressImageFile(image);
  return compressedImage;
}

Future<File> compressImageFile(File _uploadedImage) async {
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  final int rand = new Math.Random().nextInt(10000);

  Im.Image image = Im.decodeImage(_uploadedImage.readAsBytesSync());
  Im.Image smallerImage = Im.copyResize(image, width: 400);
  File compressedImage = new File('$path/img_$rand.jpg')
    ..writeAsBytesSync(Im.encodeJpg(
      smallerImage,
      quality: 90,
    ));
  return compressedImage;
}

//Future<File> showImageAlertDialog(context) async {
//  File tempImage;
//  AlertDialog dialog = AlertDialog(
//      backgroundColor: Colors.white,
//      title: Text(
//        "Välj från galleri eller fota med kameran.",
//        style: TextStyle(
//          fontSize: 20,
//          color: Color(0xFF373F51),
//        ),
//        textAlign: TextAlign.center,
//      ),
//      content: Container(
//        margin: EdgeInsets.only(left: 25, right: 25),
//        child: ButtonBar(
//          children: <Widget>[
//            RaisedButton(
//              color: Color(0xFFECA72C),
//              child: Icon(Icons.image, color: Colors.white),
//              onPressed: () async {
//                 tempImage = await getImage("gallery");
//              },
//            ),
//            RaisedButton(
//              color: Color(0xFFECA72C),
//              child: Icon(Icons.camera_alt, color: Colors.white),
//              onPressed: () async {
//               tempImage = await getImage("camera");
//              },
//            ),
//          ],
//        ),
//      ));
//  showDialog(context: context, builder: (BuildContext context) => dialog);
//  print("IM TRYING TO RETURN AN IMAGE");
//
//}

String imageFileToString(File _image) {
  String imageString = _image.toString();
  print(imageString);
  if (_image != null) {
    imageString = base64.encode(_image.readAsBytesSync());
    return "data:image/jpg;base64," + imageString;
  } else
    return null;
}
