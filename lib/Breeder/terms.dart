import 'dart:convert';
import 'dart:io';

import 'package:fauna/Breeder/register_success.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class TermsClass extends StatefulWidget {
  TermsClass(
      {Key key,
      this.frontImage,
      this.backImage,
      this.fullName,
      this.businessLicense,
      this.kennelLicense,
      this.id})
      : super(key: key);
  File frontImage;
  File backImage;
  var fullName;
  var businessLicense;
  var kennelLicense;
  var id;

  @override
  _TermsClassState createState() => _TermsClassState();
}

class _TermsClassState extends State<TermsClass> {
  bool rememberMe = false;
  bool abovePerson = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Terms & Conditions",
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
          ),
        ),
      ),
    );
  }

  addHeading() {
    return Text("Step 2/2",
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
          color: Color(0xFFA82A9C),
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
        onPressed: () async {
          if (rememberMe && abovePerson) {
            myPostApplyLoad();
          } else {
            showToast("please accept terms and conditions.");
          }
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Get Started", style: kButtontyle),
      ),
    );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Complete the questionnaire below",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
                space(),
                space(),
                addTermsRow(),
                space(),
                space(),
                addPersonRow()
              ])),
    );
  }

  addcheckbox() {
    return Checkbox(
      value: rememberMe,
      onChanged: _onRememberMeChanged,
      activeColor: Colors.pink,
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        if (rememberMe) {
        } else {}
      });

  addsecondCheckbox() {
    return Checkbox(
      value: abovePerson,
      onChanged: _onAbovePerosnMeChanged,
      activeColor: Colors.pink,
    );
  }

  void _onAbovePerosnMeChanged(bool newValue) => setState(() {
        abovePerson = newValue;
        if (abovePerson) {
        } else {}
      });

  addTermsRow() {
    return Row(
      children: [
        // ShaderMask(
        //     blendMode: BlendMode.srcIn,
        //     shaderCallback: (Rect bounds) {
        //       return ui.Gradient.linear(
        //         Offset(4.0, 24.0),
        //         Offset(24.0, 4.0),
        //         [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        //       );
        //     },
        //     child:
        Container(
          width: 20,
          height: 20,
          child: addcheckbox(),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            child: Text.rich(
              TextSpan(
                text: "I have read the ",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                    text: "Rules and Regulations",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: " and fully comply.",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  )
                  // can add more TextSpans here...
                ],
              ),
            ),
            onTap: () {},
          ),
        )
      ],
    );
  }

  addPersonRow() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          child: addsecondCheckbox(),
        ),
        SizedBox(
          width: 10,
        ),
        Text("I am the person stated above.",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 15,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Future<void> myPostApplyLoad() async {
    ApiProvider _apiProvider = ApiProvider();
    var ENDPOINT = MAKEBREEDER;
    var _listDatas = jsonDecode(await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + ENDPOINT, TOKENKEY));
    if (_listDatas != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(ISBREEDER, 2); //for register
      StateProvider _stateProvider = StateProvider();
      var dict = {"status": 2};
      _stateProvider.notify(ObserverState.UPDATEBREEDER, dict);
      Future.delayed(const Duration(milliseconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  Future<void> _apiImageUpload() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(ApiProvider.baseUrl + BREEDERVERIFICATIONB);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    if (widget.frontImage == null) {
    } else {
      var stream = new http.ByteStream(
          DelegatingStream.typed(widget.frontImage.openRead()));
      var length = await widget.frontImage.length();
      var multipartFile_identity_front = new http.MultipartFile(
          'idFront', stream, length,
          filename: path.basename(widget.frontImage.path));
      request.files.add(multipartFile_identity_front);
    }
    if (widget.backImage == null) {
    } else {
      var stream = new http.ByteStream(
          DelegatingStream.typed(widget.backImage.openRead()));
      var length = await widget.backImage.length();
      var multipartFile_identity_front = new http.MultipartFile(
          'idBack', stream, length,
          filename: path.basename(widget.backImage.path));
      request.files.add(multipartFile_identity_front);
    }
    request.fields['fullName'] = widget.fullName;
    request.fields['businessLicense'] = widget.businessLicense;
    request.fields['kennelLicense'] = widget.kennelLicense;
    request.fields['id'] = widget.id.toString();

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      Map data = jsonDecode(await value);

      print("data-------------" + data.toString());

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(ISBREEDER, 2); //for register
        StateProvider _stateProvider = StateProvider();
        var dict = {"status": 2};
        _stateProvider.notify(ObserverState.UPDATEBREEDER, dict);
        Future.delayed(const Duration(milliseconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        showMessage("Something went wrong");
      }
    });
  }
}
