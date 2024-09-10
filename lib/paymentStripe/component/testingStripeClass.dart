import 'package:fauna/paymentStripe/component/attachCard.dart';
import 'package:fauna/paymentStripe/component/model/paymentModel.dart';
import 'package:fauna/paymentStripe/component/paymentConfirm.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import 'LabeledCheckboxClass.dart';
import 'cardsListReturn.dart';
import 'paymentIntent.dart';
import 'showToast.dart';

/*------------Testing payment Class------------*/
class PaymentDataCheck extends StatefulWidget {
  PaymentDataCheck({Key key, this.paymentData}) : super(key: key);
  var paymentData;
  @override
  _PaymentDataCheckState createState() => _PaymentDataCheckState();
}

class _PaymentDataCheckState extends State<PaymentDataCheck> {
  var customer_id = "";
  List<PaymentCards> _listCard = List();
  List<bool> inputsCards = new List<bool>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStripeId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Payment",
          style: TextStyle(
              color: Color(0xff080040),
              fontFamily: "Montserrat",
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }

  cardsListItem(List<PaymentCards> listCard, int index, BuildContext context,
      setStatenew, BuildContext contextScreen) {
    var indexSet = -1;
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
                      child: new LabeledCheckbox(
                          value: inputsCards[index],
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          onChanged: (bool val) {
                            ItemChangeCards(val, index, context, setStatenew);
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              Navigator.pop(context);
                              print("listCard:- " +
                                  listCard[index].id.toString());
                              attachCardAndpaymentConfirm(contextScreen,
                                  customer_id, listCard[index].id.toString());
                            });
                          }),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 6,
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

  void ItemChangeCards(bool val, int index, BuildContext context, setStatenew) {
    if (mounted)
      for (int i = 0; i < _listCard.length; i++) {
        setStatenew(() {
          if (i == index) {
            inputsCards[i] = true;
          } else {
            inputsCards[i] = false;
          }
        });
      }
  }

  Future<void> checkStripeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString(STRIPECUSTOMERID).toString();
    print("val :- " + customer_id.toString());
    if (customer_id == 'null') {
      Navigator.pop(context, "fail");
    } else {
      if (mounted) paymentCheck(customer_id);
    }
  }

  Future<void> paymentCheck(String customer_id) async {
    var list = await cardListReturn(context, customer_id);
    if (list.toString() == 'null' || list.toString() == null) {
      cardAttach();
    } else {
      if (list.length > 0) {
        _listCard = list;
        inputsCardsAddCard();
        bottomCardList(context, customer_id);
        print("list :- " + list.toString());
      } else {
        cardAttach();
      }
    }
  }

  bottomCardList(BuildContext contextScreen, String customer_id) {
    var heightOfModalBottomSheet = MediaQuery.of(contextScreen).size.height / 2;

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SizedBox(
              height: heightOfModalBottomSheet,
              child: Column(
                children: [
                  roundedTopBox(MediaQuery.of(context).size, "Added Cards",
                      true, 20.0, 60.0),
                  Container(
                    color: Colors.white,
                    height: heightOfModalBottomSheet - 60,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listCard.length,
                        itemBuilder: (BuildContext context, int index) {
                          return cardsListItem(_listCard, index, context,
                              setState, contextScreen);
                        }),
                  )
                ],
              ),
            );
          });
        });
  }

  roundedTopBox(size, var firstText, var addEnable, var roundedSize,
      var heightContainer) {
    return Container(
      height: heightContainer,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFF9C27B0),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(roundedSize),
          topLeft: Radius.circular(roundedSize),
        ),
        border: Border.all(
          width: 3,
          color: Color(0xFF9C27B0),
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                firstText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              flex: 1,
            ),
            Expanded(
                flex: 1,
                child: addEnable
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            cardAttach();
                          },
                        ),
                      )
                    : SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  Future<void> attachCardAndpaymentConfirm(context, customer_id, token) async {
    var bool = await attachCard(customer_id, token, context);
    if (bool) paymentConfirm(context, customer_id, token);
  }

  Future<void> paymentConfirm(context, customer_id, token) async {
    var pmId = await cardIntentReturn(
        context, customer_id, token, widget.paymentData.toString());
    if (pmId.toString() == "" || pmId.toString() == 'null') {
    } else {
      var message = await payToStripeConfirm(pmId, token, context);
      print("message :-- " + message);
      if (message == "success") {
        Navigator.pop(context);
      }
    }
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
    showToast(error.toString());
  }

  void inputsCardsAddCard() {
    if (mounted)
      setState(() {
        for (int i = 0; i < _listCard.length; i++) {
          inputsCards.add(false);
        }
      });
  }
}
