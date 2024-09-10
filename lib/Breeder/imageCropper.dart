import 'dart:io';

import 'package:fauna/Breeder/terms.dart';
import 'package:fauna/class/imagePick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePicker extends StatefulWidget {
  ImagePicker(
      {Key key,
      this.imageFile,
      this.fullName,
      this.businessLicense,
      this.kennelLicense,
      this.id})
      : super(key: key);
  File imageFile;
  var fullName;
  var businessLicense;
  var kennelLicense;
  var id;
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImagePickerState extends State<ImagePicker> {
  AppState state;
  File croppedFile;
  File originalFile;
  File firstCropImage;
  File secondCropImage;
  var croppingSecond = false;

  @override
  void initState() {
    super.initState();
    state = AppState.picked;
    originalFile = widget.imageFile;
    croppingImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            croppingSecond ? Text("ID - Back Page") : Text("ID - Front Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            child: Center(
              child: widget.imageFile != null
                  ? Image.file(widget.imageFile, fit: BoxFit.fill)
                  : Container(),
            ),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            height: 5.0,
          ),
          state == AppState.cropped
              ? Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('Looks Good!'), flex: 1),
                      Expanded(
                        child: InkWell(
                          child: Text(
                            'Try Again',
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            setState(() {
                              widget.imageFile = originalFile;
                            });
                            _cropImage();
                          },
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: SizedBox(
          child: ElevatedButton(
            child: _buildButtonText(),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF9C27B0),
              onPrimary: Colors.white,
              shadowColor: Color(0xFF9C27B0),
              elevation: 5,
            ),
            onPressed: () {
              if (state == AppState.free) {
                pickImage(context);
              } else if (state == AppState.picked) {
                _cropImage();
              } else if (state == AppState.cropped) {
                if (croppingSecond) {
                  secondCropImage = croppedFile;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsClass(
                              frontImage: firstCropImage,
                              backImage: secondCropImage,
                              fullName: widget.fullName,
                              businessLicense: widget.businessLicense,
                              kennelLicense: widget.kennelLicense,
                              id: widget.id)));
                } else {
                  firstCropImage = croppedFile;

                  pickImage(context);
                }
              }
              // else if (state == AppState.cropped) _clearImage();
            },
          ),
          height: 50.0,
        ),
      ),
    );
  }

  Widget _buildButtonText() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Text("Image Crop");
    else if (state == AppState.cropped)
      return Text("Next");
    else
      return Container();
  }

  void pickImage(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text('Choose Action')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Text("Camera"),
                          onPressed: () async {
                            Navigator.pop(context);
                            File pickedImage =
                                await imagePick(context, "Camera");
                            print("image :- " + pickedImage.toString());
                            imagePickup(pickedImage);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.blue,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blue,
                        ),
                        FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Text("Gallery"),
                          onPressed: () async {
                            Navigator.pop(context);
                            File pickedImage =
                                await imagePick(context, "Gallery");
                            print("image :- " + pickedImage.toString());
                            imagePickup(pickedImage);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.blue,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blue,
                        )
                      ]),
                  new SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.blue),
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0))),
                  ),
                ],
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)));
        });
  }

/*  Future<File> pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
  }*/

  Future<Null> _cropImage() async {
    croppedFile = await ImageCropper.cropImage(
        sourcePath: widget.imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      widget.imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    widget.imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  void imagePickup(File pickedImage) {
    widget.imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (widget.imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
    setState(() {
      croppingSecond = true;
      originalFile = pickedImage;
    });
    croppingImage();
  }

  void croppingImage() {
    _cropImage();
  }
}
