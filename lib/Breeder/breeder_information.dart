import 'package:fauna/Breeder/code.dart';
import 'package:fauna/blocs/breeder_bloc.dart';
import 'package:fauna/class/email_validator.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';

class BreederInfoClass extends StatefulWidget {
  BreederInfoClass({Key key}) : super(key: key);

  @override
  _BreederInformationClassState createState() =>
      _BreederInformationClassState();
}

class _BreederInformationClassState extends State<BreederInfoClass> {
  BreederInfoBloc _infoBloc;
  var _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerBusinessLicense = TextEditingController();
  TextEditingController controllerKennelLicense = TextEditingController();
  // TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _infoBloc = BreederInfoBloc();
    _infoBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CodeClass(
                        responseData: event.data,
                        fullName: controllerFullName.text,
                        businessLicense: controllerBusinessLicense.text,
                        kennelLicense: controllerKennelLicense.text,
                        id: event.data.id)));
            break;
          case Status.ERROR:
            _isLoading = false;
            print("data :-" + event.message.toString());
            // showMessage(event.data.toString());
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
    return Text("Step 1/4",
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

  addCodeButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            checkInfoDetail();
          }
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Get Code", style: kButtontyle),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "To make Fauna a safe platform for everyone we need to get to know you a little."
                      " Please fill out the below information to be able to find a home for your sheltered animals.",
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
                addBuisnessLicense(),
                space(),
                addDetail(),
                space(),
                space(),
                addKennelLicense(),
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Business License.';
                }
                return null;
              },
              controller: controllerBusinessLicense,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Business License'))),
      onPressed: () {},
    );
  }

  addDetail() {
    return Wrap(
      children: [
        Text(
          "If you do not have one apply here ",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal),
        ),
        InkWell(
          child: Text(
            "Get Licensed",
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

  addKennelLicense() {
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
                  return 'Please enter Kennel License.';
                }
                return null;
              },
              controller: controllerKennelLicense,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Kennel License'))),
      onPressed: () {},
    );
  }

/*  addEmail() {
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
                  return 'Please enter Email.';
                }
                return null;
              },
              controller: controllerEmail,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Email'))),
      onPressed: () {},
    );
  }*/

  void checkInfoDetail() {
    /*var email = controllerEmail.text.trim();
    final bool emailValid = EmailValidator.validate(email);
    if (emailValid == false) {
      showMessage("Please Enter Valid Email.");
    } else {
      Map<String, String> body = <String, String>{
        'fullName': controllerFullName.text,
        'businessLicense': controllerBusinessLicense.text,
        'kennelLicense': controllerKennelLicense.text,
        'email': controllerEmail.text,
      };
      _infoBloc.addBreederInfo(body);
    }*/

    Map<String, String> body = <String, String>{
      'fullName': controllerFullName.text,
      'businessLicense': controllerBusinessLicense.text,
      'kennelLicense': controllerKennelLicense.text
    };
    _infoBloc.addBreederInfo(body);
  }
}
