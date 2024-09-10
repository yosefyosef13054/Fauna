import 'package:fauna/Breeder/licensed_breeder.dart';
import 'package:fauna/Breeder/seller.dart';
import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';

class SelectBreederClass extends StatefulWidget {
  final int isStatus;
  SelectBreederClass({this.isStatus});
  @override
  _SelectBreederClassState createState() => _SelectBreederClassState();
}

enum SingingCharacter { seller, shelter, licensed }

class _SelectBreederClassState extends State<SelectBreederClass>
    implements StateListener {
  var isStatus = 0;
  SingingCharacter _character = SingingCharacter.seller;
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
      // _profileBloc.getUser();
    }
    // _profileBloc.loginStream.listen((event) {
    //   setState(() {
    //     switch (event.status) {
    //       case Status.LOADING:
    //         _isLoading = true;
    //         // Dialogs.showLoadingDialog(context, _keyLoader);
    //         break;
    //       case Status.COMPLETED:
    //         _isLoading = false;

    //         var status = event.data.isBreeder;
    //         updateBreeder();

    //         print(status);
    //         StateProvider _stateProvider = StateProvider();
    //         var dict = {"status": isStatus};
    //         _stateProvider.notify(ObserverState.UPDATEBREEDERFROMBREEDER, dict);

    //         if (status != null) {
    //           isStatus = status;
    //           print("status" + status.toString());
    //         }
    //         // Future.delayed(const Duration(milliseconds: 2), () {
    //         //   Navigator.of(_keyLoader.currentContext, rootNavigator: true)
    //         //       .pop();
    //         // });
    //         break;
    //       case Status.ERROR:
    //         _isLoading = true;
    //         Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    //         _showAlert(context, event.message);

    //         break;
    //     }
    //   });
    // });
    isStatus = widget.isStatus;
  }

  // updateBreeder() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt(ISBREEDER, isStatus);
  // }

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

  _SelectBreederClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
          child: isGuestLogin
              ? null
              : isStatus == 2
                  ? null
                  : addBreederButton(),
        ),
        body: isGuestLogin
            ? Center(child: guestuser(context))
            : isStatus == 2
                ? successRegister()
                : Stack(children: [
                    Image.asset(
                      "assets/bg.webp",
                      width: MediaQuery.of(context).size.width,
                      //  height: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ]),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 30, 10, 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Select Type of Seller",
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Need help finding a new home.',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          subtitle: const Text(
                                              'If you have one pet, you would like to find a new home select this option.',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.seller,
                                            groupValue: _character,
                                            hoverColor: Colors.pink,
                                            activeColor: Colors.pink,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ListTile(
                                          title: const Text('Shelter',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          subtitle: const Text(
                                              'If you work for or own a shelter, please select this option.',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.shelter,
                                            groupValue: _character,
                                            hoverColor: Colors.pink,
                                            activeColor: Colors.pink,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ListTile(
                                          title: const Text('Licensed Breeder',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          subtitle: const Text(
                                              'If you are a licensed breeder and would like to use Fauna to help '
                                              'you find homes for your pets, then please select this option.',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          leading: Radio<SingingCharacter>(
                                            value: SingingCharacter.licensed,
                                            groupValue: _character,
                                            hoverColor: Colors.pink,
                                            activeColor: Colors.pink,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                _character = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                                // )
                                )))
                  ]));
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

  addBreederButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        //0xffB1308A
        onPressed: () {
          //0xFF9C27B0
          if (_character == SingingCharacter.seller) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerClass(
                  type: "1",
                ),
              ),
            );
          } else if (_character == SingingCharacter.shelter) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellerClass(
                          type: "2",
                        )));
          } else if (_character == SingingCharacter.licensed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LicensedClass(),
              ),
            );
          }
        },
        textColor: Colors.white,
        child: Text("Get Started",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
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
