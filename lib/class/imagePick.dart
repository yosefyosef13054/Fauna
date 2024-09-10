import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File> imagePick(context, type) async {
  File image;
  final picker = ImagePicker();
  var pickedFile;
  if (type == "Camera") {
    pickedFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 55,
        maxHeight: 480,
        maxWidth: 640);
  } else {
    pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 55,
        maxHeight: 480,
        maxWidth: 640);
  }
  if (pickedFile != null) {
    image = File(pickedFile.path);
    String fileName = image.path.split('.').last;
    print(fileName);

    return image;
  } else {
    print('No image selected.');
    return image;
  }
}
