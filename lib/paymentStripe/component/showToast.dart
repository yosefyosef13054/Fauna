import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String mesage) {
  Fluttertoast.showToast(
      msg: mesage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}
