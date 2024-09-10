import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fauna/home/change_pass.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/update_pass.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingClass extends StatefulWidget {
  SettingClass({Key key}) : super(key: key);
  @override
  _SettingClassState createState() => _SettingClassState();
}

class _SettingClassState extends State<SettingClass> implements StateListener {
  bool isSwitched = true;
  var _username = "";
  var _phone = "";
  var _profile = "";

  _SettingClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    // TODO: implement onStateChanged
    if (state == ObserverState.UPDATEPROFILE) {
      getUser();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: false,
          title: Text(
            "Settings",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      body: isGuestLogin
          ? guestuser(context)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFFF1F1F1),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DottedBorder(
                            borderType: BorderType.Circle,
                            radius: Radius.circular(25),
                            color: Colors.pink,
                            padding: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                imageUrl: _profile,
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_username,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              Text(_phone,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                  addContainer("Notification",
                      "assets/settings/notifaction.webp", "checkbox", ""),
                  addLine(),
                  InkWell(
                    child: addContainer("Change Password",
                        "assets/settings/changePassword.webp", "", ""),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePasswordClass()));
                    },
                  ),
                ],
              ),
            ),
    );
  }

  addLine() {
    return Divider(
      color: Colors.grey[200],
      height: 2,
    );
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(USERNAME);
      _phone = prefs.getString(USERPHONE);
      _profile = prefs.getString(USERPROFILE);
    });
  }

  addContainer(str, image, checkbox, detail) {
    return InkWell(
        child: InkWell(
            child: Container(
                color: Colors.white,
                //width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Row(
                      children: [
                        Image.asset(
                          image,
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(str,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Color(0xff595959),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                        checkbox == "showDetail"
                            ? Text(detail,
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff595959),
                                  fontSize: 15,
                                ))
                            : Container(),
                        SizedBox(
                          width: 10,
                        ),
                        checkbox == "checkbox"
                            ? CupertinoSwitch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
                                  });
                                },
                                activeColor: Color(0xff9C27B0),
                              )
                            : Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              )
                      ],
                    )))));
  }
}
