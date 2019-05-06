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
  Im.Image smallerImage = Im.copyResize(image, 400);
  File compressedImage = new File('$path/img_$rand.jpg')
    ..writeAsBytesSync(Im.encodeJpg(
      smallerImage,
      quality: 90,
    ));
  return compressedImage;
}

String imageFileToString(File _image) {
  String imageString = _image.toString();
  print(imageString);
  if (_image != null) {
    imageString = base64.encode(_image.readAsBytesSync());
    return "data:image/jpg;base64," + imageString;
  } else
    return null;
}
