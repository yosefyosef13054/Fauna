import 'dart:convert';
import 'dart:io';
import 'package:fauna/Breeder/terms.dart';
import 'package:fauna/blocs/breeder_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/supportingClass/CurrenLocationFinder.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class LicensedClass extends StatefulWidget {
  @override
  _LicensedClassState createState() => _LicensedClassState();
}

class _LicensedClassState extends State<LicensedClass> {
  BreederInfoBloc _infoBloc;
  var _isLoading = false;
  File file;
  File kernelfile;
  String _lat = "";
  String _long = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerBusinessLicense = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerKernelLicense = TextEditingController();

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
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      file = File(result.files.single.path);
      controllerBusinessLicense.text = result.files.single.name.toString();
    } else {
      // User canceled the picker
    }
  }

  pickKernelFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      kernelfile = File(result.files.single.path);
      controllerKernelLicense.text = result.files.single.name.toString();
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
        SizedBox(
          width: 15,
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
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          bool isValidName =
              RegExp(r"^[A-Za-z\\s]+$").hasMatch(controllerFullName.text);
          bool isValidNumber =
              RegExp(r"^([+]\d{2}[ ])?\d{5}$").hasMatch(controllerPhone.text);
          if (controllerFullName.text == "") {
            _showAlert(context, "Please enter Full name.");
            return;
          }
          if (!isValidName) {
            _showAlert(context, "Invalid Full Name.");
            return;
          }
          if (controllerPhone.text == "") {
            _showAlert(context, "Please enter Phone.");
            return;
          }
          if (!isValidNumber) {
            _showAlert(context, "Invalid Phone.");
            return;
          }
          if (controllerAddress.text == '') {
            _showAlert(context, "Please select Address");
            return;
          }
          if (controllerBusinessLicense.text == "") {
            _showAlert(context,
                "Please select buisness license document of jpg', 'pdf' or 'doc' type.");
            return;
          }
          if (controllerKernelLicense.text == "") {
            _showAlert(context,
                "Please select  kernel license document of jpg', 'pdf' or 'doc' type.");
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
                  "To make Fauna a safe platform for everyone we need to get to know you a little. "
                  "Please fill out the below information to be able to list and find homes for your pure-bred animals.",
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
                addKernelLicense(),
                space(),
                space(),
                addDetail(),
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
                  hintText: 'Business Name / Name'))),
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
                  hintText: 'Upload Buisness Licenese'))),
      onPressed: () {
        pickFile();
      },
    );
  }

  addKernelLicense() {
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
              controller: controllerKernelLicense,
              style: kTextFeildStyle,
              enabled: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Upload Kernel Licenese'))),
      onPressed: () {
        pickKernelFile();
      },
    );
  }

  addDetail() {
    return Wrap(
      children: [
        Text(
          "Upload a pdf or image of any documents supporting the licensing of your breeding facility.",
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
    var uri = Uri.parse(ApiProvider.baseUrl + LICENSED_BREEDER);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

/*    final String _fileName = file.name;
    Uint8List data = (await rootBundle.load(file.path)).buffer.asUint8List();
    List<int> _imageData = data.buffer.asUint8List();
    request.files.add(
      http.MultipartFile.fromBytes('businessLicense', _imageData,
          filename: _fileName),
    );*/

    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile_identity_front = new http.MultipartFile(
        'businessLicense', stream, length,
        filename: path.basename(file.path));
    request.files.add(multipartFile_identity_front);

/*    final String _fileKernName = kernelfile.name;
    Uint8List datak =
        (await rootBundle.load(kernelfile.path)).buffer.asUint8List();
    List<int> _imageDatak = datak.buffer.asUint8List();
    request.files.add(
      http.MultipartFile.fromBytes('kennelLicense', _imageDatak,
          filename: _fileKernName),
    );*/

    var stream1 =
        new http.ByteStream(DelegatingStream.typed(kernelfile.openRead()));
    var length1 = await kernelfile.length();
    var multipartFile_identity_front1 = new http.MultipartFile(
        'kennelLicense', stream1, length1,
        filename: path.basename(kernelfile.path));
    request.files.add(multipartFile_identity_front1);

    request.fields['name'] = controllerFullName.text;
    request.fields['phone'] = controllerPhone.text;
    request.fields['address'] = controllerAddress.text;
    request.fields['latitude'] = _lat;
    request.fields['longitude'] = _long;
    request.fields['breederType'] = "3";

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
