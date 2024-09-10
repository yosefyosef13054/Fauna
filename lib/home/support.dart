import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class SupportClass extends KFDrawerContent {
  @override
  _SupportClassState createState() => _SupportClassState();
}

class _SupportClassState extends State<SupportClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
            onPressed: () {
              widget.onMenuPressed();
            },
          ),
          title: Text(
            "Support",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      backgroundColor: Colors.white,
    );
  }
}
