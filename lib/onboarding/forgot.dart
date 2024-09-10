import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/otp_verify.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:fauna/home/home.dart';

class ForgotClass extends StatefulWidget {
  ForgotClass({Key key}) : super(key: key);
  static const routeName = '/forgot';
  @override
  _ForgotClassState createState() => _ForgotClassState();
}

class _ForgotClassState extends State<ForgotClass> {
  ForgotBloc _forgotBloc;
  bool isLoading = false;
  TextEditingController _controller = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _forgotBloc = ForgotBloc();
    _forgotBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            isLoading = true;
            Dialogs.showLoadingDialog(context, _keyLoader);

            break;
          case Status.COMPLETED:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _showSuccessAlert(context, event.data.message);
            break;
          case Status.ERROR:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            print(event.message);
            _showAlert(context, event.message);
            break;
        }
      });
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

  void _showSuccessAlert(BuildContext context, str) {
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
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OTPClass(
                                  email: _controller.text,
                                  fromEmail: false,
                                )));
                  },
                ),
              ],
            ));
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
              Positioned(
                top: 50,
                left: 10,
                child: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
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
            "Forgot Password",
            style: kMainHeading,
          ),
          space,
          space,
          space,
          Text(
            "Please enter your email address or  phone number. You will recieve a link  to create a new password.",
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
              "assets/forgot.webp",
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
          addEmail(),
          space,
          space,
          space,
          space,
          space,
          addForgotButton()
        ],
      ),
    ));
  }

  addEmail() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          height: 50,
          child: TextFormField(
              controller: _controller,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Email id / Phone Number'))),
      onPressed: () {},
    );
  }

  apply() {
    if (_controller.text.isEmpty) {
      _showAlert(context, "Please enter Email.");
    } else {
      var data = {"email": _controller.text};
      _forgotBloc.forgot(data);
    }
  }

  addForgotButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          apply();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Next", style: kButtontyle),
      ),
    );
  }
}
