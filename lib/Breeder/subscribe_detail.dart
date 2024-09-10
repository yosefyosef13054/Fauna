import 'dart:convert';
import 'dart:io';

import 'package:fauna/class/progressShowBreeder.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class SubscribePost extends StatefulWidget {
  SubscribePost({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListViewDemoState();
  }
}

class ListViewDemoState extends State<SubscribePost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Add Details",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: new Container(
            child: new SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        )));
  }
}
