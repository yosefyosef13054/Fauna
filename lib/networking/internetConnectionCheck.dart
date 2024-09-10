import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> internetConnectionState() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      _showToast("Please Check internet Connection");
      return false;

    }
  } on SocketException catch (_) {
    _showToast("Please Check internet Connection");
    return true;
  }
}
void _showToast(String mesage) {
  Fluttertoast.showToast(
      msg: mesage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}