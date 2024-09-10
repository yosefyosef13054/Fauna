import 'package:fauna/class/shareApplicationData.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:share/share.dart';

class ShareClass extends KFDrawerContent {
  @override
  _ShareClassState createState() => _ShareClassState();
}

class _ShareClassState extends State<ShareClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
          onPressed: () {
            widget.onMenuPressed();
          },
        ),
        centerTitle: false,
        title: Text(
          "Invite Friends",
          style: TextStyle(
              color: Color(0xff080040),
              fontFamily: "Montserrat",
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(child: successRegister()),
    );
  }

  Widget successRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/banner/invite.webp",
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.width * 0.80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Let your all your friends now!",
          style: kHeading,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            "Invite your friends to Fauna so they too can find their next pet on Fauna. As a token of our gratitude for spreading the word your email will be entered into a contest to win amazing prizes with Fauna at the end of every month. You will receive an email with details and confirmation of your participation in the contest for every friend that signs up and downloads Fauna.",
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
        addSaveButton(context)
      ],
    );
  }

  addSaveButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 60,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          share(type: "invite");
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Invite Now",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
