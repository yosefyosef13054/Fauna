import 'package:fauna/Breeder/breeder_information.dart';
import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';

class BecomeBreederClass extends StatefulWidget {
  final int isStatus;
  BecomeBreederClass({this.isStatus});
  @override
  _BecomeBreederClassState createState() => _BecomeBreederClassState();
}

class _BecomeBreederClassState extends State<BecomeBreederClass>
    implements StateListener {
  var isStatus = 0;
  _BecomeBreederClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  ProfileBloc _profileBloc;
  var _isLoading = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    isStatus = widget.isStatus;
    if (isGuestLogin) {
    } else {
      _profileBloc.getUser();
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
            var status = event.data.isBreeder;
            print(status);
            // breederStatus = _userModel.isBreeder;
            if (status != null && status == 1) {
              print("status" + status.toString());
            }

            //  breederStatus = 1;

            break;
          case Status.ERROR:
            _isLoading = true;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Become Breeder",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      body: isGuestLogin
          ? Center(child: guestuser(context))
          : isStatus == 2
              ? successRegister()
              : mainWidget(),
    );
  }

  Widget successRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/banner/registerSuccesful.webp",
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.width * 0.80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            "Thank you for your application.\n One of our moderators will review your application and reach out as soon as possible.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget mainWidget() {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(40, 30, 40, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Want To Become",
            style: kMainHeading,
          ),
          space,
          Text(
            "Breeder",
            style: kMainHeading,
          ),
          space,
          space,
          Center(
            child: Image.asset(
              "assets/Breederbanner.webp",
              width: MediaQuery.of(context).size.width * 0.80,
              fit: BoxFit.cover,
            ),
          ),
          space,
          space,
          space,
          space,
          space,
          space,
          Text(
            "Read Below & Apply",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
          space,
          space,
          space,
          Text(
            "With Fauna it's fast and simple to become a breeder. Click below to register and take your breeding business to the next level",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 16,
                color: Color(0xFF595959),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400),
          ),
          space,
          space,
          space,
          space,
          space,
          space,
          space,
          space,
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

  addForgotButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BreederInfoClass()));
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Apply", style: kButtontyle),
      ),
    );
  }

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    if (state == ObserverState.UPDATEBREEDER) {
      // setState(() {
      print(dict["status"]);
      isStatus = dict["status"];
      // });
    }
  }
}
