import 'dart:convert';

import 'package:fauna/paymentStripe/networkConnection/httpConnection.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';

import '../networkConnection/apis.dart';

Future<bool> attachCard(String customer_id, token, context) async {
  var map = {"customer": customer_id};
  print("attachCard :- "+map.toString());
  print("customer_id :" + customer_id);
  print("token :" + token);
  print("response");
  Map decoded = jsonDecode(await authaCardAddStripe(
      attechCardUrlStripe + token + "/attach", map, context));
  var error;
  error = decoded['error'];
  print("error : " + error.toString());
  if (error == null) {
    return true;
  } else {
    return false;
  }
}
