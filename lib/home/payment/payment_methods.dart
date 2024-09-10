import 'dart:convert';

import 'package:fauna/paymentStripe/component/LabeledCheckboxClass.dart';

import 'package:fauna/paymentStripe/component/attachCard.dart';

import 'package:fauna/paymentStripe/component/cardsListReturn.dart';

import 'package:fauna/paymentStripe/component/stripePaymentId.dart';

import 'package:fauna/paymentStripe/networkConnection/apis.dart';

import 'package:fauna/paymentStripe/networkConnection/httpConnection.dart';

import 'package:fauna/paymentStripe/component/model/paymentModel.dart';

import 'package:fauna/paymentStripe/component/showToast.dart';

import 'package:fauna/supportingClass/constants.dart';

import 'package:flutter/material.dart';

import 'package:kf_drawer/kf_drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:stripe_payment/stripe_payment.dart';

class PaymentMethodsClass extends KFDrawerContent {
  @override
  _PaymentMethodsClasstate createState() => _PaymentMethodsClasstate();
}

class _PaymentMethodsClasstate extends State<PaymentMethodsClass> {
  List<PaymentCards> _listCard = List();

  var loading = true;

  var dataAvaialble = true;

  var customer_id = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: pkKey,
    //     merchantId: paymentType,
    //     androidPayMode: paymentTypeAndroid));

    paymentCardsCheck();
  }

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
              "Payment Info",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Card details:",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                cardAttach();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xFF9C27B0),
                                  ),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    dataAvaialble
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _listCard.length,
                            itemBuilder: (BuildContext context, int index) {
                              return cardsListItem(
                                  _listCard, index, context, setState);
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Center(
                              child: Text("No Cards Available",
                                  style: TextStyle(
                                      color: Color(0xff080040),
                                      fontFamily: "Montserrat",
                                      fontSize: 20)),
                            ),
                          )
                  ],
                ),
              ));
  }

  cardsListItem(List<PaymentCards> listCard, int index, BuildContext context,
      setStatenew) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Card(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: cardImageSet(
                            listCard[index].card['brand'].toString()),
                      ),
                    ),
                    Expanded(
                      flex: 16,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
                        child: Text(
                          '**** **** **** ' +
                              listCard[index].card['last4'].toString(),
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color(0xFF9C27B0),
                          ),
                          onPressed: () {
                            deleteCardRequest(listCard[index].id);
                          },
                        ))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  cardImageSet(String cardType) {
    print("cardType -" + cardType.toString());

    String brand;

    if (cardType == "unionpay") {
      brand = 'assets/PaymentCards/UnionPay.webp';
    } else if (cardType == "jcb") {
      brand = 'assets/PaymentCards/JCB.webp';
    } else if (cardType == "diners") {
      brand = 'assets/PaymentCards/DinersClub.webp';
    } else if (cardType == "discover") {
      brand = 'assets/PaymentCards/Discover.webp';
    } else if (cardType == "amex") {
      brand = 'assets/PaymentCards/Amex.webp';
    } else if (cardType == "mastercard") {
      brand = 'assets/PaymentCards/Mastercard.webp';
    } else if (cardType == "visa") {
      brand = 'assets/PaymentCards/Visa.webp';
    } else {
      brand = 'assets/PaymentCards/rupay.webp';
    }

    return Image.asset(brand);
  }

  Future<Null> detachCardData(card_token) async {
    var map;

    print(map);

    print("response");

    Map decoded = jsonDecode(await authaCardDetechStripe(
        detachCardUrlStripe + card_token + "/detach", map, context));

    var error;

    error = decoded['error'];

    print("error : " + error.toString());

    if (error == null) {
      paymentCardsCheck();
    } else {}
  }

  Future<void> paymentCardsCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    customer_id = prefs.getString(STRIPECUSTOMERID).toString();

    print("val :- " + customer_id.toString());

    paymentCheck(customer_id);
  }

  void cardAttach() {
    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
    //     .then((paymentMethod) {
    //   print("paymentMethod :-" + paymentMethod.id);

    //   var token = paymentMethod.id;

    //   attachCardAndpaymentConfirm(context, customer_id, token);
    // }).catchError(setError);
  }

  void setError(dynamic error) {
    // showToast(error.toString());
  }

  Future<void> attachCardAndpaymentConfirm(context, customer_id, token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    customer_id = prefs.getString(STRIPECUSTOMERID).toString();

    print("val :- " + customer_id.toString());

    attachCard(customer_id, token, context);
    Future.delayed(const Duration(milliseconds: 1000), () {
      paymentCheck(customer_id);
    });
  }

  Future<void> paymentCheck(String customer_id) async {
    if (mounted)
      setState(() {
        loading = true;
        dataAvaialble = true;
      });

    var list = await cardListReturn(context, customer_id);

    print("list :- " + list.toString());

    if (list.toString() == 'null' || list.toString() == null) {
    } else {
      setState(() {
        _listCard.clear();

        _listCard = list;

        loading = false;

        if (_listCard.length < 1) {
          dataAvaialble = false;
        } else {
          loading = false;
        }
      });
    }
  }

  Future<bool> deleteCardRequest(id) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Are you sure",
              ),
              content: Text(
                "Do you want to delete this card.",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    detachCardData(id);
                  },
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }
}
