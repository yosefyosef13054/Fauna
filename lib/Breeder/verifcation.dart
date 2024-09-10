import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fauna/Breeder/terms.dart';
import 'package:fauna/class/imagePick.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';

import 'imageCropper.dart';

class IDVerificationClass extends StatefulWidget {
  IDVerificationClass(
      {Key key,
      this.fullName,
      this.businessLicense,
      this.kennelLicense,
      this.id})
      : super(key: key);
  var fullName;
  var businessLicense;
  var kennelLicense;
  var id;
  @override
  _IDVerificationClassState createState() => _IDVerificationClassState();
}

class _IDVerificationClassState extends State<IDVerificationClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
          child: addCodeButton(),
        ),*/
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
              "ID Verification",
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
                      addContainer()
                    ]))));
  }

  addHeading() {
    return Text("Step 3/4",
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
        SizedBox(
          width: 15,
        ),
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TermsClass()));
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Next", style: kButtontyle),
      ),
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
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: "Select Document Type"))),
      onPressed: () {},
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* Text(
                    "Fill out information about your business",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),*/

/*
                  addUsername(),
*/

                  space(),
                  addRow(),
                  space(),
                  space(),
                  addScanner()
                ])));
  }

  addScanner() {
    return InkWell(
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(25),
        color: Color(0xff6442FF),
        padding: EdgeInsets.all(8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.80,
              color: Color(0xff6442FF).withOpacity(0.2),
              child: Center(
                child: Text(
                  "Click here to scan your document",
                  style: TextStyle(
                    color: Color(0xff6442FF),
                    fontSize: 14,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            )),
      ),
      onTap: () async {
        imagePickData(context);
      },
    );
  }

  addRow() {
    return Row(
      children: [
        Image.asset("assets/scan.webp", width: 30, height: 30),
        SizedBox(
          width: 20,
        ),
        Text(
          "Scan",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Color(0xFF595959),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        )
      ],
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
                        FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Text("Camera"),
                          onPressed: () async {
                            Navigator.pop(context);
                            File image = await imagePick(context, "Camera");
                            print("image :- " + image.toString());
                            imageSendToNextPage(image);
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
                            File image = await imagePick(context, "Gallery");
                            print("image :- " + image.toString());
                            imageSendToNextPage(image);
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

  void imageSendToNextPage(File image) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImagePicker(
                imageFile: image,
                fullName: widget.fullName,
                businessLicense: widget.businessLicense,
                kennelLicense: widget.kennelLicense,
                id: widget.id)));
  }
}
