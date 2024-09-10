import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class MyList extends KFDrawerContent {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
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
            "My Pets",
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
