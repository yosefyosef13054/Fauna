import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';

class UpdatePasswordClass extends StatefulWidget {
  final String email;
  UpdatePasswordClass({this.email});
  @override
  _UpdatePasswordClassState createState() => _UpdatePasswordClassState();
}

class _UpdatePasswordClassState extends State<UpdatePasswordClass> {
  TextEditingController _newController = TextEditingController();
  TextEditingController _oldController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var _newPass = "";
  var _confrimPass = "";

  ChangePasswordBloc _passwordBloc;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordBloc = ChangePasswordBloc();
    _passwordBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);

            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            _showSuccessAlert(context, "Password changed Sucessfully");
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _showAlert(context, event.message);
            _isLoading = true;
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
        child: addCodeButton(),
      ),
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: false,
          title: Text(
            "Change Password",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              addOldPassword(),
              SizedBox(height: 20),
              addNewPassword(),
              SizedBox(height: 20),
              addConfirmPassword()
            ],
          ),
        ),
      ),
    );
  }

  addOldPassword() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              // onSaved: (String val) {
              //   _newPass = val;
              // },
              obscureText: true,
              controller: _oldController,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Enter old password'))),
      onPressed: () {},
    );
  }

  addNewPassword() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              onSaved: (String val) {
                _newPass = val;
              },
              obscureText: true,
              controller: _newController,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Enter new password'))),
      onPressed: () {},
    );
  }

  addConfirmPassword() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              onSaved: (String val) {
                _confrimPass = val;
              },
              controller: _confirmController,
              obscureText: true,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Enter confirm password'))),
      onPressed: () {},
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
              content: Text(str,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      color: Colors.pink,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              actions: [
                FlatButton(
                  child: Text('Ok'),
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
              content: Text("Your password is changed successfully."),
              actions: [
                FlatButton(
                  child: Text('OK',
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          color: Colors.pink,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
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
          if (_newController.text.isEmpty) {
            _showAlert(context, "Enter new password.");
          } else if (_oldController.text.isEmpty) {
            _showAlert(context, "Enter old password.");
          } else if (_newController.text != _confirmController.text) {
            _showAlert(context, "Password and Confirm Password mismatched.");
          } else {
            var data = {
              "oldPassword": _oldController.text,
              "password": _newController.text
            };
            _passwordBloc.chanegPassword(data);
          }
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Save Password", style: kButtontyle),
      ),
    );
  }
}
