import 'package:fauna/Breeder/verifcation.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class CodeClass extends StatefulWidget {
  CodeClass(
      {Key key,
      this.responseData,
      this.fullName,
      this.businessLicense,
      this.kennelLicense,
      this.id})
      : super(key: key);
  var responseData;
  var fullName;
  var businessLicense;
  var kennelLicense;
  var id;

  @override
  _CodeClassState createState() => _CodeClassState();
}

class _CodeClassState extends State<CodeClass> {
  String otp = "";

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
            "Enter Code",
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
                  Text(
                    "Please enter the code sent to you by email.",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        color: Color(0xFF595959),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                  space(),
                  space(),
                  addOTP(context),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                  space(),
                  addresendButton(),
                ],
              ))),
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
          checkOtp();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Next", style: kButtontyle),
      ),
    );
  }

  addresendButton() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            "Didn’t you recieved any code?",
            TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
            ),
            gradient: LinearGradient(
              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          Text(
            "Resend a new code",
            style: TextStyle(
              color: Color(0xffFF3D00),
              fontFamily: "Montserrat",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          )
        ],
      ),
    );
  }

  addOTP(context) {
    return OTPTextField(
      length: 4,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldWidth: 50,
      fieldStyle: FieldStyle.box,
      style: kTextFeildStyle,
      onCompleted: (pin) {
        setState(() {
          otp = pin.toString();
        });
      },
      onChanged: (pin) {
        setState(() {
          if (pin.length < 4) {
            otp = "";
          }
        });
      },
    );
  }

  addHeading() {
    return Text("Step 2/4",
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
          color: Colors.grey[850],
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

  void checkOtp() {
    print("otp  OTP" + otp);
    print("responseData Enter OTP" + widget.responseData.otp.toString());

    if (otp.isEmpty) {
      // showMessage("Please Enter OTP");
      print("Please Enter OTP");
    } else if (otp == widget.responseData.otp.toString()) {
      // showMessage("Right OTP");
      print("Right OTP");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IDVerificationClass(
                  fullName: widget.fullName,
                  businessLicense: widget.businessLicense,
                  kennelLicense: widget.kennelLicense,
                  id: widget.id)));
    } else {
      // showMessage("Data OTP");
      print("Incorrect OTP");
    }
  }
}
