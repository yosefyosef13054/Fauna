import 'dart:convert';

import 'package:fauna/paymentStripe/networkConnection/apis.dart';

import '../networkConnection/httpConnection.dart';
import 'showToast.dart';

Future<String> cardIntentReturn(
    context, customer_id, paymentMethod, price) async {
  showToast("Please wait");
  var doubleData = double.parse(price.toString());
  int intPrice = doubleData.round(); // i = 21
  var amount = intPrice * 100;
  print("amount :-" + amount.toString());
  var map = {
    "amount": amount.toString().replaceAll(".0", ""),
    "currency": "usd",
    "payment_method": paymentMethod,
    "customer": customer_id,
  };
  print("cardIntentReturn :- " + map.toString());
  print("map ~~~:" + map.toString());
  Map decoded =
      jsonDecode(await authaPayStripe(PayCardUrlStripe, map, context));
  print("decodedss :" + decoded.toString());
  var error;
  error = decoded['error'];
  if (error == null) {
    var id = decoded["id"].toString();
    return id;
    // payToStripeConfirm(decoded["id"].toString(), paymentMethod);
  } else {
    return "null";
    showToast(error['message'].toString());
  }
}
