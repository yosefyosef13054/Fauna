import 'dart:convert';

import 'package:fauna/paymentStripe/networkConnection/apis.dart';
import 'package:fauna/paymentStripe/networkConnection/httpConnection.dart';
import 'package:fauna/paymentStripe/component/model/paymentModel.dart';
import 'package:fauna/paymentStripe/component/stripePaymentId.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';

class CardAdd extends StatefulWidget {
  CardAdd({Key key, this.price}) : super(key: key);
  var price;

  @override
  _CardAddState createState() => _CardAddState();
}

class _CardAddState extends State<CardAdd> {
  TextEditingController cardNamer = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cardCvv = TextEditingController();
  List<PaymentCards> _list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: pkKey,
    //     merchantId: paymentType,
    //     androidPayMode: paymentTypeAndroid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter the details below:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              spaceHeight(20.0),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(
                    children: [
                      Image.asset('assets/clippedCard.webp'),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            spaceHeight(10.0),
                            Text(
                              "ADD CARD",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              spaceHeight(20.0),
              cardHolderName(),
              spaceHeight(20.0),
              cardholderNumber(),
              spaceHeight(20.0),
              rowCardDetail(),
              spaceHeight(40.0),
              addPayNowButton(),
            ],
          ),
        ),
      ),
    );
  }

  cardHolderName() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          //height: 50,
          child: TextFormField(
              style: kTextFeildStyle,
              controller: cardNamer,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: kSubHeading,
                  hintText: 'Cardholder Name'))),
      onPressed: () {},
    );
  }

  cardholderNumber() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          //height: 50,
          child: TextFormField(
              style: kTextFeildStyle,
              keyboardType: TextInputType.phone,
              controller: cardNumber,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: kSubHeading,
                  hintText: 'Cardholder Number'))),
      onPressed: () {},
    );
  }

  rowCardDetail() {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: UnicornOutlineButton(
              strokeWidth: 1,
              radius: 24,
              gradient: LinearGradient(
                colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                end: const Alignment(0.0, -1),
                begin: const Alignment(0.0, 0.6),
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  //height: 50,
                  child: TextFormField(
                      style: kTextFeildStyle,
                      keyboardType: TextInputType.phone,
                      controller: cardExpiryDate,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: kSubHeading,
                          hintText: 'Expiry Date'))),
              onPressed: () {},
            )),
        spaceWidth(10.0),
        Expanded(
            flex: 5,
            child: UnicornOutlineButton(
              strokeWidth: 1,
              radius: 24,
              gradient: LinearGradient(
                colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                end: const Alignment(0.0, -1),
                begin: const Alignment(0.0, 0.6),
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.4,
                  //height: 50,
                  child: TextFormField(
                      style: kTextFeildStyle,
                      controller: cardCvv,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: kSubHeading,
                          hintText: 'CVV'))),
              onPressed: () {},
            ))
      ],
    );
  }

  addPayNowButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 30,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          checkPayment();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Pay Now", style: kButtontyle),
      ),
    );
  }

  spaceHeight(double doubleSize) {
    return SizedBox(
      height: doubleSize,
    );
  }

  spaceWidth(double doubleSize) {
    return SizedBox(
      width: doubleSize,
    );
  }

  void _createPaymentMethod(customer_id, context) {
//     StripePayment.createPaymentMethod(
//       PaymentMethodRequest(
//         card: CreditCard(
//           number: cardNumber.text,
//           expMonth: 12,
//           expYear: 21,
//         ),
//       ),
//     ).then((paymentMethod) {
//       print("id : " + paymentMethod.id);
// //      attachCardData(paymentMethod.id.toString(), context, customer_id, userId);
//       attechCardData(customer_id, paymentMethod.id);
//       payToStripeData(customer_id, paymentMethod.id);
//       // cardListData(customer_id);
//     }).catchError(setError);
  }

  void setError(dynamic error) {
    _showToast(error.toString());
  }

  Widget _showToast(String mesage) {
    Fluttertoast.showToast(
        msg: mesage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> attechCardData(String customer_id, token) async {
    var map = {"customer": customer_id};
    print(map);
    print("customer_id :" + customer_id);
    print("token :" + token);
    print("response");
    Map decoded = jsonDecode(await authaCardAddStripe(
        attechCardUrlStripe + token + "/attach", map, context));
    var error;
    error = decoded['error'];
    print("error : " + error.toString());
    if (error == null) {
    } else {
      _showToast(error['message'].toString());
    }
  }

  Future<void> payToStripeData(customer_id, paymentMethod) async {
    _showToast("Please wait");
    var amount = int.parse(widget.price) * 100;
    print("amount :-" + amount.toString());
    var map = {
      "amount": amount.toString().replaceAll(".0", ""),
      "currency": "usd",
      "payment_method": paymentMethod,
      "customer": customer_id,
    };
    print(map);
    print("map ~~~:" + map.toString());
    Map decoded =
        jsonDecode(await authaPayStripe(PayCardUrlStripe, map, context));
    print("decodedss :" + decoded.toString());
    var error;
    error = decoded['error'];
    if (error == null) {
      payToStripeConfirm(decoded["id"].toString(), paymentMethod);
    } else {
      _showToast(error['message'].toString());
    }
  }

  Future<void> payToStripeConfirm(id, card_token) async {
    var map = {
      "payment_method": card_token,
    };
    Map decoded = jsonDecode(await authaPayStripe(
        PaymentConfirmation + id + "/confirm", map, context));
    print("decodedscon :" + decoded.toString());
    var error;
    error = decoded['error'];
    if (error == null) {
      _showToast("Payment submit successfully");
      _showToast("Payment submit successfully");
    } else {
      _showToast(error['message'].toString());
    }
  }

  Future<void> checkPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var val = prefs.getString(STRIPECUSTOMERID);
    print("val :- " + val.toString());
    _createPaymentMethod(val, context);
  }

  Future<Null> cardListData(customer_id) async {
    print("response");
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
        _showToast("Please add a card");
      }
    } else {}
  }
}
