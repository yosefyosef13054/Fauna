import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmailOtp extends StatefulWidget {
  final String email;
  ChangeEmailOtp({this.email});
  @override
  _ChangeEmailOtpState createState() => _ChangeEmailOtpState();
}

class _ChangeEmailOtpState extends State<ChangeEmailOtp> {
  ResendOTPBloc _resendOTPBloc;
  bool isLoading = false;
  String _pin;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ChangeEmailOTPBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChangeEmailOTPBloc();
    _resendOTPBloc = ResendOTPBloc();
    callbacks();
  }

  callbacks() {
    _resendOTPBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            _showAlert(context, event.data.message);
            break;
          case Status.ERROR:
            print(event.message);
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _showAlert(context, event.message);
            break;
        }
      });
    });

    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            _showAlert(context, "Email Changed Successfully");
            break;
          case Status.ERROR:
            print(event.message);
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _showAlert(context, event.message);
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            children: [
              Image.asset(
                "assets/bg.webp",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
              _mainWidget(),
            ],
          ),
        ));
  }

  _mainWidget() {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(40, 100, 40, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Verification",
            style: kMainHeading,
          ),
          space,
          space,
          space,
          Text(
            "Please enter the code we have sent you on your email.",
            style: kSubHeading,
          ),
          space,
          space,
          space,
          space,
          space,
          space,
          Center(
            child: Image.asset(
              "assets/verify.webp",
              width: MediaQuery.of(context).size.width * 0.60,
              fit: BoxFit.cover,
            ),
          ),
          space,
          space,
          space,
          space,
          space,
          space,
          addEmail(context),
          space,
          space,
          space,
          space,
          space,
          addresendButton(),
          space,
          space,
          space,
          space,
          space,
          space,
          addverifyButton()
        ],
      ),
    ));
  }

  addEmail(context) {
    return OTPTextField(
      length: 4,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldWidth: 50,
      fieldStyle: FieldStyle.box,
      style: kTextFeildStyle,
      onCompleted: (pin) {
        _pin = pin;
        print("Completed: " + pin);
      },
    );
  }

  verify() {
    if (_pin == null) {
      _showAlert(context, "Please enter pin.");
    } else {
      Map<String, String> body = <String, String>{
        "email": widget.email,
        "token": _pin
      };

      _bloc.loginUser(body);
    }
  }

  resend() {
    Map<String, String> body = <String, String>{
      "email": widget.email,
    };
    _resendOTPBloc.resendOtp(body);
  }

  void _showCircular(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.40),
              title: CircularProgressIndicator(),
            ));
  }

  void _showAlert(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Success",
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
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
          InkWell(
            child: Text(
              "Resend a new code",
              style: TextStyle(
                color: Color(0xffFF3D00),
                fontFamily: "Montserrat",
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              resend();
            },
          )
        ],
      ),
    );
  }

  addverifyButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          verify();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Verify", style: kButtontyle),
      ),
    );
  }
}
