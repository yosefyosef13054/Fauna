import 'dart:convert';

import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/paymentStripe/component/cardsListReturn.dart';
import 'package:fauna/paymentStripe/component/model/paymentModel.dart';
import 'package:fauna/paymentStripe/component/paymentConfirm.dart';
import 'package:fauna/paymentStripe/component/paymentIntent.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/paymentStripe/component/stripePaymentId.dart';
import 'package:fauna/paymentStripe/networkConnection/apis.dart';
import 'package:fauna/paymentStripe/networkConnection/httpConnection.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import 'component/LabeledCheckboxClass.dart';
import 'component/attachCard.dart';
import 'component/model/subscriptionModel.dart';

class Subscription extends StatefulWidget {
  Subscription({Key key, this.customerId, this.request, this.isPreview})
      : super(key: key);
  var customerId;
  var request;
  var isPreview;

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var type = "";
  List<subscriptionModel> _list = List();
  List<PaymentCards> _listCard = List();
  var loading = true;
  var dataAvaialble = true;
  List<bool> inputs = new List<bool>();
  List<bool> inputsCards = new List<bool>();
  var plan = "";
  var price = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var customer_id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listGet();
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: pkKey,
    //     merchantId: paymentType,
    //     androidPayMode: paymentTypeAndroid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: skipBtn(),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: continueBtn(),
              )),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Subscription",
          style: TextStyle(
            color: Color(0xff080040),
            fontFamily: "Montserrat",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 20.0),
        child: SingleChildScrollView(
          child: loading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : dataAvaialble
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpaceHeightTake(45.0),
                        Text(
                          "Please select a featured post plan below.",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SpaceHeightTake(15.0),
                        /*  TextField(
                          // controller: controller,
                          minLines: 3,
                          maxLines: 3,
                          decoration: new InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: "Do you want to get your post featured?",
                          ),
                        ),*/
                        Text(
                          "Your listing will be prioritized and put in our featured section on the main explore section of the App for the number of days you select below.",
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black45),
                        ),
                        SpaceHeightTake(25.0),
                        roundedTopBox(MediaQuery.of(context).size,
                            "Select Feature Duration", false, 15.0, 50.0),
                        new Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45)),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return subscriptionListPlanItem(
                                    _list, index, context);
                              }),
                        )
                      ],
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Center(
                        child: Text("No Subscription Plan Available",
                            style: TextStyle(
                                color: Color(0xff080040),
                                fontFamily: "Montserrat",
                                fontSize: 20)),
                      ),
                    ),
        ),
      ),
    );
  }

  SpaceHeightTake(double size) {
    return SizedBox(
      height: size,
    );
  }

  Future<void> listGet() async {
    type = "1"; //1 for breeder
    ApiProvider _apiProvider = ApiProvider();
    var sdecoded = jsonDecode(await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + BREEDERPLAN + type, TOKENKEY));
    print("sdecoded :-" + sdecoded.toString());
    _list = sdecoded
        .map<subscriptionModel>((json) => subscriptionModel.fromJson(json))
        .toList();

    setState(() {
      loading = false;
      if (mounted) if (_list.length < 1) {
        dataAvaialble = false;
      } else {
        for (int i = 0; i < _list.length; i++) {
          inputs.add(false);
        }
        loading = false;
      }
    });
  }

  Widget subscriptionListPlanItem(
      List<subscriptionModel> list, int index, BuildContext context) {
    return Card(
      child: new Container(
        padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: Row(
          children: [
            Expanded(
              child: new LabeledCheckbox(
                  value: inputs[index],
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  onChanged: (bool val) {
                    ItemChange(val, index, context);
                  }),
              flex: 1,
            ),
            Expanded(
              child: Text(
                list[index].title,
                style: TextStyle(color: Colors.black),
              ),
              flex: 5,
            ),
            Expanded(
              child: Text("\$ " + list[index].amount.toString()),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  void ItemChange(bool val, int index, BuildContext context) {
    if (mounted)
      for (int i = 0; i < _list.length; i++) {
        setState(() {
          if (i == index) {
            plan = _list[i].id.toString();
            price = _list[i].amount.toString();
            inputs[i] = true;
          } else {
            inputs[i] = false;
          }
        });
      }
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

  skipBtn() {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          customPostDialog();
        },
        color: Colors.white,
        textColor: Color(0xFF9C27B0),
        child: Text("Skip", style: kButtontyleUnselect),
      ),
    );
  }

  continueBtn() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          if (plan == "") {
            showToast("Please Select Feature Duration");
          } else {
            cardCreate();
          }
        },
        // color: Color(0xFF9C27B0),
        // textColor: Colors.white,
        child: Text("Continue", style: kButtontyle),
      ),
    );
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
              flex: 2,
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

  Future<void> cardCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString(STRIPECUSTOMERID).toString();
    print("val :- " + customer_id.toString());
    if (customer_id == 'null') {
      return;
    } else {
      paymentCheck(customer_id);
    }
  }

  void setError(dynamic error) {
    // showToast(error.toString());
  }

  Future<void> attachCardAndpaymentConfirm(context, customer_id, token) async {
    var bool = await attachCard(customer_id, token, context);
    if (bool) paymentConfirm(context, customer_id, token);
  }

  Future<void> paymentCheck(String customer_id) async {
    var list = await cardListReturn(context, customer_id);

    if (list.toString() == 'null' || list.toString() == null) {
    } else {
      if (list.length > 0) {
        _listCard = list;
        removeCheckedCard();
        bottomCardList(context, customer_id);
        print("list :- " + list.toString());
      } else {
        cardAttach();
      }
    }
  }

  bottomCardList(BuildContext context, String customer_id) {
    var heightOfModalBottomSheet = MediaQuery.of(context).size.height / 2;

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
                          return cardsListItem(
                              _listCard, index, context, setState);
                        }),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> paymentConfirm(context, customer_id, token) async {
    var pmId = await cardIntentReturn(context, customer_id, token, price);
    if (pmId.toString() == "" || pmId.toString() == 'null') {
    } else {
      var message = await payToStripeConfirm(pmId, token, context);
      if (message == "success") {
        sbscribeData("2");
      }
    }
  }

  cardsListItem(List<PaymentCards> listCard, int index, BuildContext context,
      setStatenew) {
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
                          onChanged: (bool val) async {
                            var statusPayment = await paymentCheckDialog();
                            print(
                                "statusPayment :- " + statusPayment.toString());
                            if (statusPayment.toString() != "null") {
                              Future.delayed(const Duration(milliseconds: 200),
                                  () async {
                                ItemChangeCards(
                                    val, index, context, setStatenew);
                                Navigator.pop(context);
                                print("listCard:- " +
                                    listCard[index].id.toString());
                                attachCardAndpaymentConfirm(context,
                                    customer_id, listCard[index].id.toString());
                              });
                            }
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteCardRequest(listCard[index].id);
                        },
                      ),
                    )
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
    // paymentCheck(customer_id);
    Navigator.pop(context);
  }

  void cardAttach() {
    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
    //     .then((paymentMethod) {
    //   print("paymentMethod :-" + paymentMethod.id);
    //   var token = paymentMethod.id;
    //   checkPayment(context, customer_id, token);
    // }).catchError(setError);
  }

  Future<void> sbscribeData(String type) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    widget.request.fields['type'] = type;
    widget.request.fields['subscription_id'] = plan;
    var response = await widget.request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      var data = jsonDecode(await value);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        print(response.statusCode);
        Navigator.pop(context, "data");
        Navigator.pop(context, "data");
        Navigator.pop(context, "data");
        if (widget.isPreview != null) {
          Navigator.pop(context, "data");
        }
        if (type == "2") {
          var featured_post_available = data['featured_post_available'];
          paymentPostDialog(featured_post_available);
        }
      } else {
        showMessage(error.toString());
      }
    });
  }

  Future<bool> customPostDialog() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/postImage.webp',
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    "Post Normally",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Do you want to post this as a normal post?",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF9C27B0))),
                          onPressed: () {
                            Navigator.pop(context);
                            sbscribeData("1");
                          },
                          color: Color(0xFF9C27B0),
                          textColor: Colors.white,
                          child: Text("Yes", style: kButtontyle),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF9C27B0))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          textColor: Color(0xFF9C27B0),
                          child: Text("No", style: kButtontyleUnselect),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  Future<bool> paymentPostDialog(var date) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/postImage.webp',
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    "Successfully Posted",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Congratulations! Your post has been posted as featured post for $date",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF9C27B0))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xFF9C27B0),
                          textColor: Colors.white,
                          child: Text("Back to Home", style: kButtontyle),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  Future<bool> paymentCheckDialog() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/paymentPost.png',
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    "Do you want to pay for this subscription.",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF9C27B0))),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          color: Color(0xFF9C27B0),
                          textColor: Colors.white,
                          child: Text("Yes", style: kButtontyle),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFF9C27B0))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xFF9C27B0),
                          textColor: Colors.white,
                          child: Text("No", style: kButtontyle),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  void removeCheckedCard() {
    if (mounted)
      setState(() {
        for (int i = 0; i < _listCard.length; i++) {
          inputsCards.add(false);
        }
      });
  }

  Future<void> checkPayment(
      BuildContext context, String customer_id, String token) async {
    var statusPayment = await paymentCheckDialog();
    print("statusPayment :- " + statusPayment.toString());
    if (statusPayment.toString() != "null") {
      attachCardAndpaymentConfirm(context, customer_id, token);
    }
  }
}
