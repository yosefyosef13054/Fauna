import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:fauna/Breeder/terms.dart';
import 'package:fauna/blocs/breeder_bloc.dart';
import 'package:fauna/class/imagePick.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/supportingClass/CurrenLocationFinder.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

class SellerClass extends StatefulWidget {
  final String type;

  SellerClass({this.type});

  @override
  _SellerClassState createState() => _SellerClassState();
}

class _SellerClassState extends State<SellerClass> {
  BreederInfoBloc _infoBloc;
  var _isLoading = false;
  PlatformFile file;
  String _lat = "0.0";
  String _long = "0.0";
  File imageFile;
  File result;
  String _fileName = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerBusinessLicense = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  // TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    pickCurrentLocation();
  }

  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // File file = File(result.files.single.path);
      PlatformFile fil = result.files.first;
      setState(() {
        file = fil;
      });
      controllerBusinessLicense.text = fil.name;
    } else {
      // User canceled the picker
    }
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE",
        //apiHeaders: await GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        controllerAddress.text = p.description;
        _lat = lat.toString();
        _long = lng.toString();
      });
      //scaffold.showSnackBar(
      //SnackBar(content: Text("${p.description} - $lat/$lng")),
      //);
    }
  }

  pickerAddress(context) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE");
    displayPrediction(p, homeScaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
        child: addCodeButton(),
      ),
      appBar: AppBar(
          centerTitle: false,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Color(0xff080040),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Get Started",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addHeading(),
                  space(),
                  space(),
                  space(),
                  addProgress(),
                  space(),
                  space(),
                  space(),
                  space(),
                  Center(
                    child: addContainer(),
                  ),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                ],
              )),
        ),
      ),
    );
  }

  addHeading() {
    return Text("Step 1/2",
        style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 25,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Color(0xFF080040)));
  }

  space() {
    return SizedBox(
      height: 10,
    );
  }

  addProgress() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 2,
          color: Color(0xFFA82A9C),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          width: 60,
          height: 2,
          color: Colors.grey[850],
        ),
      ],
    );
  }

  addCodeButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xffB1308A))),
        onPressed: () {
          if (controllerFullName.text == "") {
            _showAlert(context, "Please enter Full name.");
            return;
          }
          if (controllerPhone.text == "") {
            _showAlert(context, "Please enter Phone.");
            return;
          }

          if (controllerAddress.text == '') {
            _showAlert(context, "Please select Address");
            return;
          }
          if (controllerBusinessLicense.text == "") {
            _showAlert(context, "Please upload picture of license or ");
            return;
          }
          uplaodImages();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Submit", style: kButtontyle),
      ),
    );
  }

  void _showAlert(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              content: Text(str),
              actions: [
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  addContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.type == "1"
                      ? "To make Fauna a safe platform for all we need to get to know you a little. "
                          "Please fill out the below information to be able to find a home for your pet."
                      : "To make Fauna a safe platform for everyone we need to get to know you a little. Please fill out the below information to be able to find a home for your sheltered animals.",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
                space(),
                space(),
                space(),
                addUsername(),
                space(),
                space(),
                addPhonename(),
                space(),
                space(),
                addAddress(),
                space(),
                space(),
                addBuisnessLicense(),
                space(),
                addDetail(),
                space(),
                space(),

/*
                addEmail(),
*/
              ])),
    );
  }

  addUsername() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: 50,
          child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Name.';
                }
                return null;
              },
              controller: controllerFullName,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Full Name'))),
      onPressed: () {},
    );
  }

  addPhonename() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: 50,
          child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter phone.';
                }
                return null;
              },
              controller: controllerPhone,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Phone'))),
      onPressed: () {},
    );
  }

  addAddress() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: 50,
          child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter address.';
                }
                return null;
              },
              controller: controllerAddress,
              enabled: false,
              style: kTextFeildStyle,
              maxLines: 2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Address'))),
      onPressed: () {
        pickerAddress(context);
      },
    );
  }

  addBuisnessLicense() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: 50,
          child: TextFormField(
              controller: controllerBusinessLicense,
              style: kTextFeildStyle,
              enabled: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Upload Documents'))),
      onPressed: () {
        //pickFile();
        openCamera();
      },
    );
  }

  openCamera() async {
    File image = await imagePick(context, "Camera");
    print("image :- " + image.toString());
    imageFile = image;
    if (Platform.isIOS) {
      final filePath = await FlutterAbsolutePath.getAbsolutePath(image.path);
      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        String fileName = tempFile.path.split('.').last;
        print(fileName);
        if (fileName == "HEIC") {
          final dir = await path_provider.getTemporaryDirectory();
          var time = DateTime.now().toString();
          var imga = "IMG" + time + "." + fileName;
          var fina = imga.replaceAll(new RegExp(r"\s+"), "");
          _fileName = fina.toString();
          final targetPath = dir.absolute.path + "/${fina.toString()}";
          print(targetPath);
          imageFile = await FlutterImageCompress.compressAndGetFile(
              tempFile.absolute.path, targetPath,
              quality: 55, minWidth: 500, format: CompressFormat.heic);
        } else {
          final dir = await path_provider.getTemporaryDirectory();
          var time = DateTime.now().toString();
          var imga = "IMG" + time + "." + fileName;
          var fina = imga.replaceAll(new RegExp(r"\s+"), "");
          _fileName = fina.toString();
          final targetPath = dir.absolute.path + "/${fina.toString()}";
          print(targetPath);
          imageFile = await FlutterImageCompress.compressAndGetFile(
            tempFile.absolute.path,
            targetPath,
            quality: 55,
            minWidth: 500,
            minHeight: 500,
          );
        }
      }
      if (imageFile != null) {
        setState(() {
          controllerBusinessLicense.text = _fileName;
        });
      }
    } else {
      imageFile = image;
      if (imageFile != null) {
        setState(() {
          controllerBusinessLicense.text = imageFile.path;
        });
      }
    }
  }

  addDetail() {
    return Wrap(
      children: [
        Text(
          widget.type == "1"
              ? "Upload any document for proof of identity such as your driver's license, passport, or similar document."
              : "Upload any document for proof of identity such as Shelter license, owners' driver's license, passport, or similar document",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal),
        ),
        InkWell(
          child: Text(
            "",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 13,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  // void checkInfoDetail() {
  //   Map<String, String> body = <String, String>{
  //     'fullName': controllerFullName.text,
  //     'businessLicense': controllerBusinessLicense.text,
  //     'kennelLicense': controllerKennelLicense.text
  //   };
  //   _infoBloc.addBreederInfo(body);
  // }

  uplaodImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + SELLER_API);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    if (Platform.isIOS) {
      Uint8List data =
          (await rootBundle.load(imageFile.path)).buffer.asUint8List();
      List<int> _imageData = data.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes('document_id', _imageData,
            filename: _fileName),
      );
    } else {
      File filePickedUser = File(imageFile.path);

      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await filePickedUser.length();
      var multipartFile_identity_front = new http.MultipartFile(
          'document_id', stream, length,
          filename: path.basename(imageFile.path));
      request.files.add(multipartFile_identity_front);
    }

    request.fields['name'] = controllerFullName.text;
    request.fields['phone'] = controllerPhone.text;
    request.fields['address'] = controllerAddress.text;
    request.fields['latitude'] = _lat;
    request.fields['longitude'] = _long;
    request.fields['breederType'] = widget.type;

    Dialogs.showLoadingDialog(context, _keyLoader);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        prefs.setString(ADDRESS, controllerAddress.text);
        prefs.setString(LATITUDE, _lat);
        prefs.setString(LONGITUDE, _long);
        print(response.statusCode);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TermsClass())); // showMessage("Post uploaded successfully".toString());
      } else {
        _showAlert(context, error.toString());
      }
    });
  }

  Future<void> pickCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = prefs.getString(ADDRESS);
    var latitude = prefs.getString(LATITUDE);
    var longitude = prefs.getString(LONGITUDE);
    if (address != null) {
      controllerAddress.text = address;
      _lat = latitude.toString();
      _long = longitude.toString();
    } else
      try {
        await currentLocation().then((valData) {
          print("locationData :-" + valData.toString());
          if (mounted)
            setState(() {
              controllerAddress.text = valData['Address'];
              _lat = valData['Latitude'].toString();
              _long = valData['Longitude'].toString();
            });
        }).catchError((error, stackTrace) {});
      } catch (e) {}
  }
}
