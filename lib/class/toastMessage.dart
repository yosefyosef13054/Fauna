import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future showMessage(var message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFF9C27B0),
      textColor: Colors.white,
      fontSize: 16.0);
}
