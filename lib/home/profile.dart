import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/class/imagePick.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/models/profile_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/change_email_otp.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:fauna/supportingClass/sidebar/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:kf_drawer/kf_drawer.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileClass extends KFDrawerContent {
  final bool fromMenu;
  // final Function callback;
  ProfileClass({this.fromMenu});
  @override
  _ProfileClassState createState() => _ProfileClassState();
}

class _ProfileClassState extends State<ProfileClass> {
  ProfileBloc _profileBloc;
  EditProfileBloc _editProfileBloc;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isLoading = true;
  File imageFile;
  UserProfileModel _userModel;
  bool isEdit = false;
  String address = "";
  String _lat = "";
  String _long = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _descpController = TextEditingController();
  TextEditingController _memberController = TextEditingController();
  var breederStatus = 0;
  var breederType = 0;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void dispose() {
    // TODO: implement dispose
    _profileBloc.dispose();
    _editProfileBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _editProfileBloc = EditProfileBloc();
    if (isGuestLogin) {
    } else {
      getConnect();
    }

    _profileBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            _isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _userModel = event.data;
            breederStatus = _userModel.isBreeder;
            if (_userModel.breederType != null && breederStatus == 1) {
              breederType = _userModel.breederType;
            }

            //  breederStatus = 1;
            _nameController.text = _userModel.firstName;
            _lastController.text = _userModel.lastName;
            _emailController.text = _userModel.email;
            _addressController.text = _userModel.address;
            _descpController.text = _userModel.description.toString();
            _memberController.text = _userModel.memberFrom.toString();
            _lat = _userModel.latitude.toString();
            _long = _userModel.longitude.toString();
            _userModel.phone == null ? _userModel.phone = 0 : _userModel.phone;
            _userModel.countryCode == null
                ? _userModel.countryCode = 0
                : _userModel.countryCode;
            break;
          case Status.ERROR:
            _isLoading = true;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            _showAlert(context, event.message);

            break;
        }
      });
    });

    _editProfileBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            update(event.data);
            if (event.data.emailChange == 0) {
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeEmailOtp(
                            email: event.data.email,
                          )));
            }
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            _showAlert(context, event.message);
            break;
        }
      });
    });
  }

  void getConnect() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _profileBloc.getUser();
      }
    } on SocketException catch (_) {
      print('not connected');
      showToast('No Internet Connection');
    }
  }

  update(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StateProvider _stateProvider = StateProvider();
    _stateProvider.notify(ObserverState.UPDATEPROFILE, null);
    setState(() {
      prefs.setString(USERNAME, data.firstName + " " + data.lastName);
      prefs.setString(USERPHONE, data.phone.toString());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
          centerTitle: widget.fromMenu ? false : true,
          leading: widget.fromMenu
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
                  onPressed: () {
                    widget.onMenuPressed();
                  },
                )
              : SizedBox.shrink(),
          title: Text(
            "My Profile",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: isGuestLogin
          ? guestuser(context)
          : SingleChildScrollView(
              child: Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.50,
                  color: Color(0xffFDEEFF),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            addprofile(),
                            Positioned.fill(
                              top: 20,
                              right: 30,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: addediticon()),
                            ),
                          ],
                        ),
                      ])),
              _isLoading ? Container() : _buildMainWidget()
            ])),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE",
        //  apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        _addressController.text = p.description;

        _lat = lat.toString();
        _long = lng.toString();
      });

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  addediticon() {
    return InkWell(
        child: Container(
            width: 40,
            height: 40,
            child: Center(
              child: Image.asset(
                "assets/edit.webp",
                width: 20,
                height: 20,
              ),
            )),
        onTap: () {
          setState(() {
            isEdit = true;
          });
        });
  }

  addprofile() {
    return _isLoading
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 280,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageFile.toString() != "null"
                      ? breederStatus == 0
                          ? DottedBorder(
                              borderType: BorderType.Circle,
                              radius: Radius.circular(25),
                              color: Colors.pink,
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black45,
                                      )
                                    ]),
                                child: CircleAvatar(
                                  radius: 25,
                                  child: ClipOval(
                                    child: Image.file(
                                      imageFile,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ))
                          : Stack(
                              children: [
                                DottedBorder(
                                    borderType: BorderType.Circle,
                                    radius: Radius.circular(25),
                                    color: Colors.pink,
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      height: 100.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 10,
                                              color: Colors.black45,
                                            )
                                          ]),
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: ClipOval(
                                          child: Image.file(
                                            imageFile,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )),
                                breederStatus == 1
                                    ? breederType == 3
                                        ? Positioned.fill(
                                            bottom: 0,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Image.asset(
                                                    "assets/verified.png")))
                                        : Positioned.fill(
                                            bottom: 0,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Image.asset(
                                                    "assets/breedertag.png")),
                                          )
                                    : Container()
                              ],
                            )
                      : breederStatus == 0
                          ? DottedBorder(
                              borderType: BorderType.Circle,
                              radius: Radius.circular(25),
                              color: Colors.pink,
                              padding: EdgeInsets.all(5),
                              child: CircularImage(CachedNetworkImageProvider(
                                  _userModel.profileImg)))
                          : Stack(
                              children: [
                                DottedBorder(
                                    borderType: BorderType.Circle,
                                    radius: Radius.circular(25),
                                    color: Colors.pink,
                                    padding: EdgeInsets.all(5),
                                    child: CircularImage(
                                        CachedNetworkImageProvider(
                                            _userModel.profileImg))),
                                breederStatus == 1
                                    ? breederType == 3
                                        ? Positioned.fill(
                                            bottom: 0,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Image.asset(
                                                    "assets/verified.png")))
                                        : Positioned.fill(
                                            bottom: 0,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Image.asset(
                                                    "assets/breedertag.png")),
                                          )
                                    : Container()
                              ],
                            ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _userModel.firstName + " " + _userModel.lastName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  addChangeButton()
                ],
              ),
            ),
          );
  }

  addbg() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xffFDEEFF),
      //  color: Colors.red,
      //child: addprofile(),
    );
  }

  _buildMainWidget() {
    return SingleChildScrollView(
        //   physics: NeverScrollableScrollPhysics(),
        child: Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        // height: 800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addNameContainer("First Name", _userModel.firstName),
            SizedBox(
              height: 10,
            ),
            addLastNameContainer("Last Name", _userModel.lastName),
            SizedBox(
              height: 10,
            ),
            addPhoneContainer("Phone Number", _userModel.phone.toString()),
            SizedBox(
              height: 10,
            ),
            addEmailContainer("Email", _userModel.email),
            SizedBox(
              height: 10,
            ),
            addAddressContainer("My Address", _userModel.address),
            breederStatus == 1
                ? SizedBox(
                    height: 10,
                  )
                : Container(),
            breederStatus == 1
                ? addDescriptionContainer("Description", _userModel.description)
                : Container(),
            breederStatus == 1
                ? SizedBox(
                    height: 10,
                  )
                : Container(),
            breederStatus == 1
                ? addMemberContainer("Member from", _userModel.memberFrom)
                : Container(),
            SizedBox(
              height: 20,
            ),
            isEdit ? addSaveButton() : Container()
          ],
        ),
      ),
    ));
  }

  addNameContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: _nameController,
                enabled: isEdit ? true : false,
                decoration: InputDecoration(
                  border: isEdit ? UnderlineInputBorder() : InputBorder.none,
                  // hintText: "Name",
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                validator: (String value) {
                  if (value.isEmpty)
                    return 'First name is Required';
                  else
                    return null;
                },
              ))
            ],
          ),
        ));
  }

  addLastNameContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: _lastController,
                enabled: isEdit ? true : false,
                decoration: InputDecoration(
                  border: isEdit ? UnderlineInputBorder() : InputBorder.none,
                  // hintText: "Name",
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                validator: (String value) {
                  if (value.isEmpty)
                    return 'Last name is Required';
                  else
                    return null;
                },
              ))
            ],
          ),
        ));
  }

  addEmailContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: _emailController,
                enabled: isEdit ? true : false,
                decoration: InputDecoration(
                  border: isEdit ? UnderlineInputBorder() : InputBorder.none,
                  // hintText: "Name",
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                validator: (String value) {
                  if (value.isEmpty)
                    return 'Email is Required';
                  else
                    return null;
                },
              ))
            ],
          ),
        ));
  }

  addMemberContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: _memberController,
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // hintText: "Name",
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ))
            ],
          ),
        ));
  }

  addPhoneContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: checkEditPhoneNumber())
            ],
          ),
        ));
  }

  addAddressContainer(str, desc) {
    return InkWell(
      child: Container(
          width: MediaQuery.of(context).size.width - 40,
          //height: 100,
          constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xffF8F8F8),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  str,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: TextFormField(
                  controller: _addressController,
                  enabled: false,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: isEdit ? UnderlineInputBorder() : InputBorder.none,

                    // hintText: "Name",
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500),
                ))
              ],
            ),
          )),
      onTap: () {
        if (isEdit) {
          picker(context);
        } else {}
      },
    );
  }

  picker(context) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE");
    displayPrediction(p, homeScaffoldKey.currentState);
  }

  addDescriptionContainer(str, desc) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        // // height: 100,
        constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF8F8F8),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextFormField(
                controller: _descpController,
                maxLines: 8,
                minLines: 1,
                enabled: isEdit ? true : false,
                decoration: InputDecoration(
                  border: isEdit ? UnderlineInputBorder() : InputBorder.none,

                  // hintText: "Name",
                ),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ))
            ],
          ),
        ));
  }

  addChangeButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          imagePickData(context);
        },
        textColor: Colors.white,
        child: Text("Change Picture",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  addSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            saveAddress();
            Map<String, String> body = <String, String>{
              'first_name': _nameController.text,
              'last_name': _lastController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'address': _addressController.text,
              'description': _descpController.text,
              'latitude': _lat,
              "longitude": _long
            };
            _editProfileBloc.editUser(body);
            setState(() {
              isEdit = false;
            });
          }
        },
        // color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Save Changes",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  void imagePickData(BuildContext context) {
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
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: FlatButton(
                            child: Text("Camera"),
                            onPressed: () async {
                              Navigator.pop(context);
                              File image = await imagePick(context, "Camera");
                              print("image :- " + image.toString());
                              imageSendToNextPage(image);
                            },
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.blue,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blue,
                          ),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: FlatButton(
                            child: Text("Gallery"),
                            onPressed: () async {
                              Navigator.pop(context);
                              File image = await imagePick(context, "Gallery");
                              print("image :- " + image.toString());
                              imageSendToNextPage(image);
                            },
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.blue,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blue,
                          ),
                        )
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: new SizedBox(
                      width: double.infinity,
                      // height: double.infinity,
                      child: new OutlineButton(
                          borderSide: BorderSide(color: Color(0xff9C27B0)),
                          child: new Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0))),
                    ),
                  ),
                ],
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)));
        });
  }

  final String _baseUrl = "https://fauna.live/adminportal/api/v1/";

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    return token;
  }

  Future<String> uploadImage(filepath, url) async {
    Dialogs.showLoadingDialog(context, _keyLoader);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    if (filepath == null) {
    } else {
      var stream =
          new http.ByteStream(DelegatingStream.typed(filepath.openRead()));
      var length = await filepath.length();
      var multipartFile_identity_front = new http.MultipartFile(
          'profile_img', stream, length,
          filename: path.basename(filepath.path));
      request.files.add(multipartFile_identity_front);
    }

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Map data = jsonDecode(await value);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        StateProvider _stateProvider = StateProvider();
        _stateProvider.notify(ObserverState.UPDATEPROFILE, null);
        setState(() {
          prefs.setString(USERPROFILE, data["profile_img"].toString());
        });
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        print(response);
        _showAlert(context, data["profile_img"].toString());
        setState(() {
          imageFile = null;
        });
      }
    });
  }

  void imageSendToNextPage(File image) async {
    setState(() {
      imageFile = image;
    });
    print(imageFile.path);
    var res = await uploadImage(imageFile, _baseUrl + UPDATEPROFILEIMG);
    print(res);

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => ImagePicker(imageFile: image)));
  }

  checkEditPhoneNumber() {
    if (isEdit) {
      _phoneController.text = _userModel.phone.toString();
    } else {
      _phoneController.text = "+" +
          _userModel.countryCode.toString() +
          " " +
          _userModel.phone.toString();
    }
    return TextFormField(
      enabled: isEdit ? true : false,
      controller: _phoneController,
      decoration: InputDecoration(
        border: isEdit ? UnderlineInputBorder() : InputBorder.none,
        // hintText: "Name",
      ),
      style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w500),
      validator: (String value) {
        if (value.isEmpty)
          return 'Phone number is Required';
        else
          return null;
      },
    );
  }

  Future<void> saveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ADDRESS, _addressController.text.toString());
    prefs.setString(LATITUDE, _lat.toString());
    prefs.setString(LONGITUDE, _long.toString());
  }
}
