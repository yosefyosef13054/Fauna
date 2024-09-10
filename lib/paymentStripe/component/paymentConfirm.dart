import 'dart:convert';

import 'package:fauna/paymentStripe/networkConnection/apis.dart';
import 'package:fauna/paymentStripe/networkConnection/httpConnection.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';

Future<String> payToStripeConfirm(id, card_token, context) async {
  var map = {
    "payment_method": card_token,
  };
  print("payToStripeConfirm :- " + map.toString());
  Map decoded = jsonDecode(await authaPayStripe(
      PaymentConfirmation + id + "/confirm", map, context));
  print("decodedscon :" + decoded.toString());
  var error;
  error = decoded['error'];
  if (error == null) {
    showToast("Payment submit successfully");
    return 'success';
  } else {
    showToast(error['message'].toString());
  }
}
Future<Map> payToStripeMapReturnConfirm(id, card_token, context) async {
  var map = {
    "payment_method": card_token,
  };
  print("payToStripeConfirm :- " + map.toString());
  Map decoded = jsonDecode(await authaPayStripe(
      PaymentConfirmation + id + "/confirm", map, context));

  return decoded;
}