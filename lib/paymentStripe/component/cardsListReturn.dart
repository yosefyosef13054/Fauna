// cardsSaceReturn

import 'dart:convert';

import 'package:fauna/paymentStripe/component/model/paymentModel.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';

import '../networkConnection/apis.dart';
import '../networkConnection/httpConnection.dart';

Future<List> cardListReturn(context, customer_id) async {
  print("response");
  List<PaymentCards> _list = List();
  Map decoded = jsonDecode(await authaGetAddStripe(
      getCardListUrlStripe + customer_id + "&type=card", context));
  print("decodedCards :" + decoded.toString());
  var tripList = decoded['data'] as List;
  print("dataList :" + tripList.length.toString());
  var error;
  error = decoded['error'];
  print("error : " + error.toString());
  if (error == null) {
    var dataList = decoded['data'] as List;
    _list = dataList
        .map<PaymentCards>((json) => PaymentCards.fromJson(json))
        .toList();
    print(dataList);

    if (_list.length < 1) {
      showToast("Please add a card");
      return _list;
    } else {
      return _list;
    }
  } else {
    showToast("Please add a card");
  }
  return _list;
}
