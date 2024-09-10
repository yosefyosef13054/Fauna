import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/chat_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/models/chat_history.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/networking/pusher.dart';
import 'package:fauna/paymentStripe/component/LabeledCheckboxClass.dart';
import 'package:fauna/paymentStripe/component/attachCard.dart';
import 'package:fauna/paymentStripe/component/buttonAnimation/speed_dial.dart';
import 'package:fauna/paymentStripe/component/buttonAnimation/speed_dial_child.dart';
import 'package:fauna/paymentStripe/component/cardsListReturn.dart';
import 'package:fauna/paymentStripe/component/model/paymentModel.dart';
import 'package:fauna/paymentStripe/component/paymentConfirm.dart';
import 'package:fauna/paymentStripe/component/paymentIntent.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/paymentStripe/component/stripePaymentId.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:fauna/supportingClass/sidebar/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import 'breeder_detail.dart';

class MainChatClass extends StatefulWidget {
  final channelid;
  final breederid;
  final postid;
  final profile;
  final name;
  final conversation_id;
  final status;
  final price;
  final commitment_fee;
  final isBreeder;
  final totalCount;
  final postType;
  final femaleCount;
  final maleCount;

  MainChatClass(
      {this.channelid,
      this.postid,
      this.breederid,
      this.profile,
      this.name,
      this.conversation_id,
      this.status,
      this.price,
      this.commitment_fee,
      this.isBreeder,
      this.totalCount,
      this.postType,
      this.femaleCount,
      this.maleCount});

  @override
  _ChatClassState createState() => _ChatClassState();
}

class _ChatClassState extends State<MainChatClass>
    with SingleTickerProviderStateMixin {
  PusherService pusherService = PusherService();
  List<ChatHistory> messages = [];
  TextEditingController _chatController = TextEditingController();
  MessagesBloc _bloc;
  String userid;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ScrollController _scrollController = new ScrollController();
  bool isScrollUp = false;
  bool showMsg = false;
  var isDataAvailable = false;
  var disableOffer = false;

  // var fees = "";

/*----------Payment Section----------------*/
  final String _baseUrl = "https://fauna.live/adminportal/api/v1/";

  var customer_id = "";
  List<PaymentCards> _listCard = List();
  List<bool> inputsCards = new List<bool>();
  var managePay = true;
  TextEditingController numberController = TextEditingController();
  TextEditingController femaleController = TextEditingController();
  TextEditingController maleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var priceAccept = "";
  var pricedisable = false;
  var buttonHide = false;
  var paymentPostType = "1";
  var paymentMaleCt = "0";
  var paymentFemaleCt = "0";

  /*---------------------------------------*/
  @override
  void initState() {
    femaleController.text = "0";
    maleController.text = "0";
    ChanelName = widget.channelid;
    CURRENTSCREEN = "CHAT";
    getUser();
    pusherService = PusherService();
    pusherService.firePusher(widget.channelid, 'SendMessage');
    super.initState();
    _bloc = MessagesBloc();
    if (widget.conversation_id != "0") {
      var dict = {"conversations_id": widget.conversation_id.toString()};
      _bloc.getChatList(dict);
    }

    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            var mssages = event.data;
            messages = List.from(mssages.reversed);
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
            break;
          case Status.ERROR:
            _showAlert(context, event.message);
            break;
        }
      });
    });

    pusherService.eventStream.listen((event) {
      setState(() {
        if (event.channelName.toString() == widget.channelid.toString())
          messages.insert(0, event);
        if (isScrollUp) {
          showMsg = true;
        }
      });
    });
    _scrollController.addListener(_scrollListener);
    paymentDefineCheck();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isScrollUp = false;
      });
    } else {
      setState(() {
        isScrollUp = true;
      });
    }
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isScrollUp = true;
      });
    }
    if (_scrollController.offset == 0.0) {
      setState(() {
        isScrollUp = false;
      });
    }
  }

  void _showAlert(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              content: Text(str,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      color: Colors.pink,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  addContainer() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(offset: Offset(0, 2), blurRadius: 2, color: Colors.grey)
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Message",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                )
              ],
            )),
      ),
      onTap: () {
        setState(() {
          showMsg = false;
        });

        _scrollController.animateTo(0.0,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
      },
    );
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(USERID);
  }

  @override
  void dispose() {
    ChanelName = "";
    CURRENTSCREEN = "";
    _bloc.dispose();
    pusherService.unbindEvent('SendMessage');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: paymentCheckWidget(context),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: InkWell(
            child: Row(
              children: [
                CircularImage(
                  CachedNetworkImageProvider(widget.profile),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                  maxLines: 2,
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BreedersDetailpage(
                          breederid: widget.breederid.toString())));
            },
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () {
                Navigator.of(context).pop("update");
                updateCount();
              }),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                padding: const EdgeInsets.all(15),
                itemCount: messages.length,
                controller: _scrollController,
                itemBuilder: (ctx, i) {
                  if (messages[i].type.toString() == "2") {
                    return checkType(messages[i].type, messages[i].messages,
                        messages[i].time);
                  } else if (messages[i].type.toString() == "3") {
                    return SizedBox.shrink();
                  } else {
                    if (widget.isBreeder.toString() == "1") {
                      print("messageType  --  " + messages[i].type.toString());
                      if (messages[i].type.toString() == "1") {
                        return checkType(messages[i].type, messages[i].messages,
                            messages[i].time);
                      } else if (messages[i].fromUserId.toString() == userid) {
                        return senderUI(messages[i].messages, messages[i].time);
                      } else {
                        return receiverUI(
                            messages[i].messages, messages[i].time);
                      }
                    } else {
                      if (messages[i].type.toString() == "1") {
                        return checkAcceptReject(messages, i, context);
                      } else if (messages[i].fromUserId.toString() == userid) {
                        return senderUI(messages[i].messages, messages[i].time);
                      } else {
                        return receiverUI(
                            messages[i].messages, messages[i].time);
                      }
                    }
                  }
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 100, maxHeight: 250),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 60, maxHeight: 250),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //         offset: Offset(0, 3),
                                    //         blurRadius: 5,
                                    //         color: Colors.grey)
                                    //   ],
                                    // ),
                                    // child: Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              90,
                                          child: TextField(
                                            textInputAction: TextInputAction.go,
                                            controller: _chatController,
                                            maxLines: 5,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                                hintText: "Type Something...",
                                                border: InputBorder.none),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              //),
                              Container(
                                  padding: const EdgeInsets.all(10.0),
                                  // decoration: BoxDecoration(color: myGreen, shape: BoxShape.circle),
                                  child: InkWell(
                                    child: Icon(
                                      Icons.send,
                                      size: 40,
                                      color: Colors.pink,
                                    ),
                                    onTap: () {
                                      bool isValidName = RegExp(r"^\s")
                                          .hasMatch(_chatController.text);
                                      if (_chatController.text.isEmpty) {
                                        showToast("Enter some message");
                                      } else if (isValidName) {
                                        showToast("Invalid message");
                                      } else {
                                        sendMsg(_chatController.text, "0");
                                      }
                                      setState(() {
                                        _chatController.text = "";
                                      });
                                    },
                                  ))
                            ],
                          ),
                        )))),
            showMsg
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 120),
                      child: addContainer(),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  senderUI(msg, time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xffB1308A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    time.toString(),
                    style: TextStyle(
                        color: Color(0xffC5C5C5),
                        fontFamily: "Montserrat",
                        fontSize: 10),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  receiverUI(msg, time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.toString(),
                          style: TextStyle(
                            color: Color(0xff595959),
                            fontFamily: "Montserrat",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          time.toString(),
                          style: TextStyle(
                              color: Color(0xff595959),
                              fontFamily: "Montserrat",
                              fontSize: 10),
                        ),
                      ])),
            ],
          ),
        ],
      ),
    );
  }

  void updateCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + UPDATECOUNTER);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['channel_name'] = widget.channelid.toString();
    request.fields['postId'] = widget.postid.toString();
    request.fields['user_id'] = userid;
    request.fields['conversations_id'] = widget.conversation_id.toString();
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      // print("data-------------" + data.toString());
      if (response.statusCode == 200) {
        // print(response.toString());
        // print(data["counter"]);
        StateProvider _stateProvider = StateProvider();
        var dict = {"counter": data["counter"]};
        _stateProvider.notify(ObserverState.UPDATECOUNTER, dict);
      } else {
        print("error" + response.toString());
      }
    });
  }

  void sendMsg(msg, type, {postType}) async {
    var date = DateFormat('hh:mm:ss aa').format(DateTime.now());
    messages.insert(
        0,
        ChatHistory(
            messages: msg,
            fromUserId: userid,
            toUserId: widget.breederid,
            time: date.toString(),
            type: type));
    _scrollController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    // Dialogs.showLoadingDialog(context, _keyLoader);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + SEND_MSG);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['channel_name'] = widget.channelid.toString();
    request.fields['postId'] = widget.postid.toString();
    request.fields['message'] = msg;
    request.fields['breederId'] = widget.breederid.toString();
    request.fields['type'] = type;
    request.fields['price'] = priceController.text;
    if (msg.toString().contains(ACCEPTEDOFFER)) {
      request.fields['status'] = '2';
    } else if (msg.toString().contains(COUNTEROFFER)) {
      request.fields['status'] = '1';
    }
    if (postType == "2") {
      var total = int.parse(maleController.text.toString()) +
          int.parse(femaleController.text.toString());
      numberController.text = total.toString();
      request.fields['maleCount'] = maleController.text;
      request.fields['femaleCount'] = femaleController.text;
      request.fields['totalCount'] = numberController.text;
    } else {
      request.fields['totalCount'] = numberController.text;
    }

    print(request.fields.toString());
    var response = await request.send();
    // showToast("breederid - "+widget.breederid.toString());
    response.stream.transform(utf8.decoder).listen((value) async {
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      //  print("data-------------" + data.toString());
      if (response.statusCode == 200) {
        //    print(response.toString());
      } else {}
    });
  }

  void paymentDefineCheck() {
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: pkKey,
    //     merchantId: paymentType,
    //     androidPayMode: paymentTypeAndroid));
    // print("price :- " + widget.price.toString());
    // print("isBreeder :- " + widget.isBreeder.toString());
    // print("status :- " + widget.status.toString());
    var breederChange = widget.isBreeder.toString();
    changeType(breederChange);
  }

  void changeType(String breederChange) {
    if (mounted)
      setState(
        () {
          if (breederChange == "1") {
            if (widget.status.toString() == "1") {
              //home found and offer
              isDataAvailable = true;
            } else if (widget.status.toString() == "2") {
              //home found
              disableOffer = true;
            } else if (widget.status.toString() == "3") {
              // buttonHide = true;
              disableOffer = true;
            } else {
              isDataAvailable = true;
            }
          } else {
            isDataAvailable = false;
          }
        },
      );
  }

  paymentCheckWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 80.0),
      child: buttonHide
          ? SizedBox.shrink()
          : disableOffer
              ? SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: true,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Speed Dial',
                  heroTag: 'dialOpen',
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Image.asset('assets/homefound.png'),
                      ),
                      backgroundColor: Colors.pink,
                      label: "Home Found",
                      labelStyle: TextStyle(fontSize: 15.0, color: Colors.pink),
                      onTap: () async {
                        checkpostTypetotalCount(context, 'homefound');
                      },
                    ),
                  ],
                )
              : SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: isDataAvailable,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  tooltip: 'Speed Dial',
                  heroTag: 'dialOpen',
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Image.asset('assets/homefound.png'),
                      ),
                      backgroundColor: Colors.pink,
                      label: "Home Found",
                      labelStyle: TextStyle(fontSize: 15.0, color: Colors.pink),
                      onTap: () async {
                        checkpostTypetotalCount(context, 'homefound');
                      },
                    ),
                    SpeedDialChild(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Image.asset('assets/sendOffer.png'),
                        ),
                        backgroundColor: Colors.pink,
                        label: 'Set Price',
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.pink),
                        onTap: () {
                          checkpostTypetotalCount(context, 'sendOffer');
                        }),
                  ],
                ),
    );
  }

  /*
  *
  *
  * Stripe Payment Code
  *
  *
  * */
/*---------------------Payment Section-------------------------*/
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
                                // print("listCard:- " +
                                //     listCard[index].id.toString());
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
          /* if (i == index) {
            inputsCards[i] = true;
          } else {
            inputsCards[i] = false;
          }*/
        });
      }
  }

  Future<void> checkStripeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_id = prefs.getString(STRIPECUSTOMERID).toString();
    print("val :- " + customer_id.toString());
    if (customer_id == 'null') {
      showToast("Please contact to admin and setup your stripe account.");
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
    Dialogs.showLoadingDialog(context, _keyLoader);
    var bool = await attachCard(customer_id, token, context);
    if (bool) {
      paymentConfirm(context, customer_id, token);
    } else {
      popDialogShow();
    }
  }

  Future<void> paymentConfirm(context, customer_id, token) async {
    // var percentage = double.parse(widget.commitment_fee.toString());
    // double percentageData = roundDouble(percentage, 2);
    var amountDouble = double.parse(priceAccept.toString());
    // var amount = amountDouble + percentageData;
    var amount = amountDouble;

    var pmId =
        await cardIntentReturn(context, customer_id, token, amount.toString());
    if (pmId.toString() == "" || pmId.toString() == 'null') {
      popDialogShow();
    } else {
      var decoded = await payToStripeMapReturnConfirm(pmId, token, context);

      var error;
      error = decoded['error'];
      if (error == null) {
        var paymentId = decoded['id'].toString();
        var conversation_id = messages[0].id.toString();
        var postId = messages[0].postId.toString();
        callApiPayment(_baseUrl + "payCommitmentFee", conversation_id, postId,
            paymentId, amount);
      } else {
        popDialogShow();
        showToast(error['message'].toString());
      }
    }
  }

  void cardAttach() {
    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
    //     .then((paymentMethod) {
    //   print("paymentMethod :-" + paymentMethod.id);
    //   var token = paymentMethod.id;
    //   checkPayment(context, customer_id, token);
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

  void callApiPayment(url, conversation_id, postId, payment_id, amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['conversation_id'] = conversation_id;
    request.fields['postId'] = postId;
    request.fields['payment_id'] = payment_id;
    request.fields['amount'] = amount.toString();
    if (paymentPostType == "2") {
      var total = int.parse(paymentMaleCt.toString()) +
          int.parse(paymentFemaleCt.toString());
      numberController.text = total.toString();
      request.fields['maleCount'] = paymentMaleCt.toString();
      request.fields['femaleCount'] = paymentFemaleCt.toString();
      request.fields['totalCount'] = numberController.text;
    } else {
      request.fields['totalCount'] = numberController.text;
    }
    print("AllData---" +
        url.toString() +
        "\n" +
        conversation_id.toString() +
        "\n" +
        postId.toString() +
        "\n" +
        payment_id.toString() +
        "\n" +
        amount.toString() +
        "\n" +
        paymentMaleCt.toString() +
        "\n" +
        paymentFemaleCt.toString() +
        "\n" +
        numberController.text.toString());

    var amountSendChat = amount.toString();
    try {
      var amountCheck = amount.toString().split(".");
      if (amountCheck[1].toString() == "0") {
        amountSendChat = amount.toString().replaceAll(".0", "");
      } else {
        amountSendChat = amount.toString();
      }
    } catch (e) {}
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Map data = jsonDecode(await value);
      print(response.statusCode);
      if (response.statusCode == 200) {
        showToast("Payment Done Successfully....");
        popDialogShow();
        paymentPostDoneDialog();
        sendMsg(
            ACCEPTEDOFFER + " Paid " + "\$" + amountSendChat.toString(), "2");
        if (mounted)
          setState(() {
            pricedisable = true;
          });
      } else {
        popDialogShow();
        showToast("Something went wrong.");
      }
    });
  }

/*
  void apiForSendOffer(url, postId, payment_id) async {
    print("AllData---" +
        url.toString() +
        "\n" +
        postId.toString() +
        "\n" +
        payment_id.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    request.fields['breederId'] = widget.breederid;
    request.fields['postId'] = postId;
    request.fields['type'] = "1";
    request.fields['channel_name'] = widget.channelid;

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Map data = jsonDecode(await value);
      print(response.statusCode);
      if (response.statusCode == 200) {
        showToast("Payment Done Successfully....");
        popDialogShow();
        paymentPostDoneDialog();
      } else {
        popDialogShow();
        showToast("Something went wrong.");
      }
    });
  }
*/

  double roundDouble(double value, int places) {
    double mod = pow(100.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void popDialogShow() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Future<bool> paymentPostDoneDialog() {
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
                    "Congratulations!\non your new Pet!",
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
                    "Your payment was successful processed. Please let the breeder know that your payment was accepted and organize directly with the breeder to prepare to take your pet to its new home.",
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
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  checkType(type, msg, time) {
    print("type :------------ " + type.toString());
    print("msg :------------ " + msg.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff9C27B0),
                  width: 1,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff9C27B0),
                        fontFamily: "Montserrat",
                        fontSize: 16),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget checkAcceptReject(
      List<ChatHistory> messages, int i, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 40.0, 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            SizedBox(
              width: 270,
              height: 150,
              child: Image.network(
                messages[i].post_img,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
            new Container(
              width: 270,
              height: 50.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border.all(
                  color: Colors.black26,
                  width: 0.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          child: Text(messages[i].post_name,
                              textAlign: TextAlign.center),
                          alignment: Alignment.center,
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.black26,
                            width: 1.0,
                          ),
                        )),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          child: Text(
                              "offer : " +
                                  "\$" +
                                  " " +
                                  messages[i].price.toString(),
                              textAlign: TextAlign.center),
                          alignment: Alignment.center,
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.black26,
                            width: 1.0,
                          ),
                        )),
                    flex: 1,
                  ),
                ],
              ),
            ),
            messages[i].maleCount.toString() == "null"
                ? SizedBox.shrink()
                : new Container(
                    width: 270,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        color: Colors.black26,
                        width: 0.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Align(
                                child: Text(
                                    "Male : " +
                                        messages[i].maleCount.toString(),
                                    textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(
                                  color: Colors.black26,
                                  width: 1.0,
                                ),
                              )),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Align(
                                child: Text(
                                    "Female : " +
                                        messages[i].femaleCount.toString(),
                                    textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(
                                  color: Colors.black26,
                                  width: 1.0,
                                ),
                              )),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
            pricedisable
                ? SizedBox.shrink()
                : new Container(
                    width: 270,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        color: Colors.black26,
                        width: 0.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (mounted)
                                setState(() {
                                  if (messages[i].maleCount.toString() ==
                                      "null") {
                                    paymentPostType = "1";
                                  } else {
                                    paymentPostType = "2";
                                    paymentMaleCt =
                                        messages[i].maleCount.toString();
                                    paymentFemaleCt =
                                        messages[i].femaleCount.toString();
                                  }
                                  priceAccept = messages[i].price.toString();
                                });
                              checkStripeId();
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Align(
                                  child: Text(
                                    "Accept Offer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                decoration: new BoxDecoration(
                                  color: Color(0xff9C27B0),
                                  border: new Border.all(
                                    color: Colors.black26,
                                    width: 1.0,
                                  ),
                                )),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Align(
                                  child: Text(
                                    COUNTEROFFER,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                    color: Colors.black26,
                                    width: 1.0,
                                  ),
                                )),
                            onTap: () {
                              sendMsg(COUNTEROFFER, "2");
                              if (mounted)
                                setState(() {
                                  pricedisable = true;
                                });
                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  )
          ],
        ),

        /*Container(
           width: MediaQuery.of(context).size.width,
           height: 140.0,
           decoration: BoxDecoration(
             color: Colors.lightBlue,
             shape: BoxShape.circle,
           ),
           child: CachedNetworkImage(imageUrl: messages[i].post_img,fit: BoxFit.fitWidth,),

         ),
         */
      ),
    );
  }

  void checkpostTypetotalCount(context, String type) {
    int number = 0;
    print("postType :-  " + widget.postType.toString());
    print("totalCount :-  " + widget.totalCount.toString());
    if (widget.postType.toString() == "1") {
      //1=individual
    } else {
      if (widget.totalCount.toString() == "null") {
      } else
        number = int.parse(widget.totalCount.toString());
      //2=Litter
    }
    if (type == 'sendOffer') {
      widget.postType.toString() == "2"
          ? showDialogPayment(widget.postType.toString(), number, context)
          : showDialogForOffer(widget.postType.toString(), number, context);
    } else {
      if (widget.postType.toString() == "1") {
        //1=individual
        MarkasHomefound(context);
      } else {
        showDialogForHomeFound(widget.postType.toString(), number, context);
      }
    }
  }

  Future<bool> showDialogForOffer(String postType, int totalNumber, contexts) {
    return showDialog(
        context: contexts,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 0.0),
              content: StatefulBuilder(
                  // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xff9C27B0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          "Send Offer",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: headerText(
                            text: postType == "2"
                                ? "Please add pet number and price:"
                                : "Please add price:",
                            size: 18.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      postType == "2"
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: normalTextfield(
                                  hintText: 'Enter pet number',
                                  controller: numberController,
                                  keyboardType: TextInputType.name,
                                  borderColour: Colors.black45,
                                  context: context),
                            )
                          /**/
                          : SizedBox.shrink(),
                      postType == "2"
                          ? SizedBox(
                              height: 20.0,
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: dialogTextfield(
                            hintText: 'Enter your price',
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50.0,
                          child: fullColouredBtn(
                              text: "Send Offer",
                              radiusButtton: 20.0,
                              onPressed: () async {
                                if (postType == "1") {
                                  var priceRight =
                                      isNumeric(priceController.text);
                                  if (priceController.text
                                          .toString()
                                          .trim()
                                          .toString() ==
                                      "") {
                                    showToast("Please Enter price");
                                  } else if (!priceRight) {
                                    showToast("Please Enter right price");
                                  } else {
                                    Navigator.pop(context);
                                    callPaymentProcedure(postType: postType);
                                  }
                                } else {}
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  Future<bool> showDialogForHomeFound(
      String postType, int totalNumber, contexts) {
    var maleCount = widget.maleCount;
    var femaleCount = widget.femaleCount;
    return showDialog(
        context: contexts,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 0.0),
              content: StatefulBuilder(
                  // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xff9C27B0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          "Home Found",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: headerText(
                            text:
                                "Please add Male number: Max limit is $maleCount",
                            size: 18.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: normalTextfield(
                            hintText: 'Enter pet number',
                            controller: maleController,
                            keyboardType: TextInputType.name,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: headerText(
                            text:
                                "Please add female number: Max limit is $femaleCount",
                            size: 18.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: normalTextfield(
                            hintText: 'Enter pet number',
                            controller: femaleController,
                            keyboardType: TextInputType.name,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50.0,
                          child: fullColouredBtn(
                              text: "Submit",
                              radiusButtton: 20.0,
                              onPressed: () async {
                                if (femaleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter Male Number");
                                } else if (maleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter female Number");
                                } else {
                                  var femaleRight = false;
                                  var maleRight = false;

                                  var numberfemaleRight =
                                      isNumeric(femaleController.text);
                                  if (numberfemaleRight) {
                                    int numberData =
                                        int.parse(femaleController.text);
                                    if (numberData > widget.femaleCount) {
                                      femaleRight = false;
                                      showToast(
                                          "female number limit is $femaleCount");
                                    } else {
                                      femaleRight = true;
                                      /*Navigator.pop(context);
                                      MarkasHomefound(contexts);*/
                                    }
                                  } else {
                                    femaleRight = false;
                                    showToast("Please Enter right number");
                                  }

                                  var numbermaleRight =
                                      isNumeric(maleController.text);
                                  if (numbermaleRight) {
                                    int numberData =
                                        int.parse(maleController.text);
                                    if (numberData > widget.maleCount) {
                                      maleRight = false;
                                      showToast(
                                          "male number limit is $maleCount");
                                    } else {
                                      maleRight = true;
                                      /*Navigator.pop(context);
                                      MarkasHomefound(contexts);*/
                                    }
                                  } else {
                                    maleRight = false;
                                    showToast("Please Enter right number");
                                  }
                                  /* if(amountController)*/

                                  if (maleRight && femaleRight) {
                                    Navigator.pop(context);
                                    MarkasHomefound(contexts);
                                  }
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  Future<bool> showDialogPayment(String postType, int totalNumber, contexts) {
    var maleCount = widget.maleCount;
    var femaleCount = widget.femaleCount;
    return showDialog(
        context: contexts,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.only(top: 0.0),
              content: StatefulBuilder(
                  // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xff9C27B0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        child: Text(
                          "Send Offer",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: headerText(
                            text:
                                "Please add Male number: Max limit is $maleCount",
                            size: 18.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: normalTextfield(
                            hintText: 'Enter pet number',
                            controller: maleController,
                            keyboardType: TextInputType.name,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: headerText(
                            text:
                                "Please add female number: Max limit is $femaleCount",
                            size: 18.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: normalTextfield(
                            hintText: 'Enter pet number',
                            controller: femaleController,
                            keyboardType: TextInputType.name,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: normalTextfield(
                            hintText: 'Enter your price',
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            borderColour: Colors.black45,
                            context: context),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50.0,
                          child: fullColouredBtn(
                              text: "Submit",
                              radiusButtton: 20.0,
                              onPressed: () async {
                                if (femaleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter Male Number");
                                } else if (maleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter female Number");
                                } else if (priceController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter price");
                                } else {
                                  var femaleRight = false;
                                  var maleRight = false;

                                  var numberfemaleRight =
                                      isNumeric(femaleController.text);
                                  if (numberfemaleRight) {
                                    int numberData =
                                        int.parse(femaleController.text);
                                    if (numberData > widget.femaleCount) {
                                      femaleRight = false;
                                      showToast(
                                          "female number limit is $femaleCount");
                                    } else {
                                      femaleRight = true;
                                      /*Navigator.pop(context);
                                      MarkasHomefound(contexts);*/
                                    }
                                  } else {
                                    femaleRight = false;
                                    showToast("Please Enter right number");
                                  }

                                  var numbermaleRight =
                                      isNumeric(maleController.text);
                                  if (numbermaleRight) {
                                    int numberData =
                                        int.parse(maleController.text);
                                    if (numberData > widget.maleCount) {
                                      maleRight = false;
                                      showToast(
                                          "male number limit is $maleCount");
                                    } else {
                                      maleRight = true;
                                      /*Navigator.pop(context);
                                      MarkasHomefound(contexts);*/
                                    }
                                  } else {
                                    maleRight = false;
                                    showToast("Please Enter right number");
                                  }
                                  /* if(amountController)*/

                                  if (maleRight && femaleRight) {
                                    var priceRight =
                                        isNumeric(priceController.text);

                                    if (!priceRight) {
                                      showToast("Please Enter right price");
                                    } else {
                                      if (maleController.text.toString() ==
                                              "0" &&
                                          femaleController.text.toString() ==
                                              "0") {
                                        showToast(
                                            "Please Enter male/female count");
                                      } else {
                                        callPaymentProcedure(
                                            postType: postType);
                                        Navigator.pop(context);
                                      }
                                    }
                                  }
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  void callPaymentProcedure({String postType = "1"}) {
    sendMsg('Offer Sent', "1", postType: postType);
    if (mounted)
      setState(() {
        disableOffer = true;
      });
    // changeType("0");
  }

  Future<bool> MarkasHomefound(context) {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/homeFoundDetail.png',
                        height: 200,
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: Text(
                        "Mark as Homefound",
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
                        "Are you sure you want to mark this post as homefound?",
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
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50.0,
                        child: fullColouredBtn(
                            text: "Mark as Homefound",
                            radiusButtton: 20.0,
                            onPressed: () async {
                              Navigator.pop(context);
                              callHomeFoundPayment(_baseUrl + "homefound");
                            }),
                      ),
                    ),
                  ],
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  void callHomeFoundPayment(url) async {
    var postId = messages[0].postId.toString();
    var totalCount =
        int.parse(femaleController.text) + int.parse(maleController.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    request.fields['postId'] = postId;
    request.fields['userId'] = widget.breederid;
    request.fields['totalCount'] = totalCount.toString();
    request.fields['channel_name'] = widget.channelid.toString();
    request.fields['femaleCount'] = femaleController.text.toString();
    request.fields['maleCount'] = maleController.text.toString();
    print("request :-" + request.fields.toString());
    print("token :-" + token.toString());

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      print(response.statusCode);
      if (response.statusCode == 200) {
        showToast("Home Found Successfully....");
        if (mounted)
          setState(() {
            buttonHide = true;
          });
      } else {
        showToast("Something went wrong.");
      }
    });
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
                    "Do you want to pay for this post.",
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

  Future<void> checkPayment(
      BuildContext context, String customer_id, String token) async {
    var statusPayment = await paymentCheckDialog();
    print("statusPayment :- " + statusPayment.toString());
    if (statusPayment.toString() != "null") {
      attachCardAndpaymentConfirm(context, customer_id, token);
    }
  }

/*  if (paymentPostType == "1") {
      request.fields['totalCount'] = totalCount.toString();
    } else {
      var total = int.parse(paymentFemaleCt.toString()) + int.parse(paymentMaleCt.toString());
      totalCount = total;
      request.fields['totalCount'] = totalCount.toString();
      request.fields['femaleCount'] = paymentFemaleCt.toString();
      request.fields['maleCount'] = paymentMaleCt.toString();
      print("paymentMaleCt :-" + paymentMaleCt.toString());

    }*/
}

ElevatedButton fullColouredBtn(
    {String text, Function onPressed, var radiusButtton}) {
  return ElevatedButton(
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff9C27B0)),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff9C27B0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      radiusButtton == null ? 5.0 : radiusButtton),
                  side: BorderSide(color: Color(0xff9C27B0))))),
      onPressed: onPressed);
}

Text headerText({String text, Color color, double size, fontWeight}) {
  return Text(text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size == null ? 20.0 : size,
          color: color == null ? Colors.black : color));
}

UnicornOutlineButton normalTextfield(
    {String hintText,
    TextEditingController controller,
    TextInputType keyboardType,
    Color borderColour,
    context}) {
  return UnicornOutlineButton(
    strokeWidth: 1,
    radius: 24,
    gradient: LinearGradient(
      colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      end: const Alignment(0.0, -1),
      begin: const Alignment(0.0, 0.6),
    ),
    child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 50,
        child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Pet Name';
              }
              return null;
            },
            controller: controller,
            style: kTextFeildStyle,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                hintStyle: kSubHeading,
                hintText: hintText))),
    onPressed: () {},
  );
}

UnicornOutlineButton dialogTextfield(
    {String hintText,
    TextEditingController controller,
    TextInputType keyboardType,
    Color borderColour,
    context}) {
  return UnicornOutlineButton(
    strokeWidth: 1,
    radius: 24,
    gradient: LinearGradient(
      colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      end: const Alignment(0.0, -1),
      begin: const Alignment(0.0, 0.6),
    ),
    child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.8,
        height: 50,
        child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Pet Name';
              }
              return null;
            },
            controller: controller,
            style: kTextFeildStyle,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                hintStyle: kSubHeading,
                hintText: hintText))),
    onPressed: () {},
  );
}
