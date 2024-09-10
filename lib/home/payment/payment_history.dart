import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/breeder_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/models/paymentHistoryModel.dart';
import 'package:fauna/networking/Response.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class PaymentHistoryClass extends KFDrawerContent {
  @override
  _PaymentHistoryClassState createState() => _PaymentHistoryClassState();
}

class _PaymentHistoryClassState extends State<PaymentHistoryClass> {
  PaymentHistoryBloc _bloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<PaymentHistoryModel> posts = List();
  var loadingDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PaymentHistoryBloc();
    var dict = {};
    _bloc.getHistory(dict);
    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            loadingDone = false;
            Dialogs.showLoadingDialog(context, _keyLoader);

            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            loadingDone = true;
            posts = event.data;
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            print(event.message);
            loadingDone = true;
            _showAlert(context, event.message);
            break;
        }
      });
    });
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
              content: Text(str),
              actions: [
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
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
              "Payment History",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: posts != null
            ? posts.isEmpty
                ? loadingDone?Center(
                    child: Image.asset(
                      "assets/no_history_available.webp",
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ):null
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: posts.length,
                    itemBuilder: (context, position) {
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: posts[position].filename ??
                                            "https://i2.wp.com/asvs.in/wp-content/uploads/2017/08/dummy.png?fit=399%2C275&ssl=1",
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            posts[position].postName ?? "",
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 18,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${posts[position].type.toString()} : \$ ${posts[position].amount.toString()}",
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          posts[position]
                                                      .payment_type
                                                      .toString() ==
                                                  "2"
                                              ? posts[position].maleCount ==
                                                      null
                                                  ? SizedBox.shrink()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Male Count : ${posts[position].maleCount.toString()}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Female Count : ${posts[position].femaleCount.toString()}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                              : SizedBox.shrink(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Date : ${posts[position].date.toString()}",
                                            style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ))
                                    ],
                                  ))));
                    })
            : Container());
  }
}
