import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fauna/Breeder/add_pet.dart';
import 'package:fauna/blocs/breeder_bloc.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/class/shareApplicationData.dart';
import 'package:fauna/home/base_class.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/home/image_preview.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/paymentStripe/component/attachCard.dart';
import 'package:fauna/paymentStripe/component/paymentConfirm.dart';
import 'package:fauna/paymentStripe/component/paymentIntent.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/paymentStripe/component/stripePaymentId.dart';
import 'package:fauna/paymentStripe/screens/cardAdd.dart';
import 'package:fauna/paymentStripe/subscription.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import 'chat_class.dart';

class PetDetailClass extends StatefulWidget {
  final String id;
  bool fromBreeder = false;
  bool isPreview = false;
  List images;
  final PostModelClass post;
  var isIamCreator;
  var requestData;
  var customer_id;

  PetDetailClass({
    this.id,
    this.fromBreeder,
    this.isPreview,
    this.post,
    this.images,
    this.isIamCreator,
    this.requestData,
    this.customer_id,
  });
  static const routeName = '/petDetails';

  @override
  _PetDetailClassState createState() => _PetDetailClassState();
}

class _PetDetailClassState extends State<PetDetailClass> {
  PostDetailBloc _postDetailBloc;
  int _current = 0;
  PostModelClass _post;
  String id = "";
  var _isLoading = false;
  FavBloc _favBloc;
  String userid = "";
  String breederUserid = "";
  bool hideFeedback = false;
  RateBloc _rateBloc;
  MarkHomeBloc _bloc;
  var status = "1";
  var rating;
  var checkId;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var malecount;
  var femalecount;
  var totalCount;
  var enableToShowCount = false;
  var isBreeder = false;
  var loadindDone = false;
  TextEditingController femaleController = TextEditingController();
  TextEditingController maleController = TextEditingController();
  List itemsName = List();

  @override
  void dispose() {
    _postDetailBloc.dispose();
    _favBloc.dispose();

    _rateBloc.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    print("id :- " + id.toString());
    _bloc = MarkHomeBloc();
    // femaleController.text = "0";
    // maleController.text = "0";
    id = widget.id;
    _postDetailBloc = PostDetailBloc();
    _rateBloc = RateBloc();
    _favBloc = FavBloc();

    if (!widget.isPreview) {
      _postDetailBloc.getPostData(id);
    } else {
      _post = widget.post;
    }

    _rateBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            customPostDialog();
            _post.isReview = 0;
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            showToast("Somehting went wrong");
            break;
        }
      });
    });

    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            status = "2";
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            showToast("Somehting went wrong");
            break;
        }
      });
    });

    _postDetailBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _post = event.data;
            if (event.data.postType == 2) {
              enableToShowCount = true;
              malecount = event.data.maleCount;
              femalecount = event.data.femaleCount;
              totalCount = event.data.totalCount;
            }
            status = _post.status.toString();
            breederUserid = _post.userId.toString();
            break;
          case Status.ERROR:
            _isLoading = false;
            _showAlert(context, event.message);
            break;
        }
      });
    });

    _favBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            break;
          case Status.COMPLETED:
            break;
          case Status.ERROR:
            _showAlert(context, event.message);
            break;
        }
      });
    });
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: pkKey,
    //     merchantId: paymentType,
    //     androidPayMode: paymentTypeAndroid));
    lazyLoad();
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

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString(USERID);
      var data = prefs.getInt(ISBREEDER);
      print("data---" + data.toString());
      //0 not breeder
      //1 breeder
      //2 pending
      if (data.toString() == '1') {
        isBreeder = true;
      } else {
        isBreeder = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map getData = ModalRoute.of(context).settings.arguments;
    // setState(() {
    //   widget.isPreview = getData['isPreview'];
    // });
    return Scaffold(
      bottomNavigationBar:
          _isLoading ? SizedBox.shrink() : bottomButtonManage(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data(),
                  widget.isPreview
                      ? addSlider(widget.images)
                      : addSlider(_post.filename),
                  space(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.isPreview
                          ? _buildPageIndicator(widget.images.length)
                          : _buildPageIndicator(_post.filename != null
                              ? _post.filename.length
                              : 0)),
                  addRow(),
                  checkPostType(),
                  addTitle(),
                  space(),
                  addDescription(),
                  addProperties(),
                  widget.isIamCreator == null
                      ? _post.isReview == 0
                          ? Container()
                          : showRatingSection()
                      : subscribeBtn(),
                  space(),
                  isBreeder ? Container() : addFeaturedPets(),
                  isBreeder ? Container() : addpetsList(),
                  space(),
                  space(),
                ],
              ),
            ),
    );
  }

  showRatingSection() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "How was your experience with Breeder?",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                glowColor: Colors.amber,
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 26,
                //  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (_rating) {
                  print(rating);
                  setState(() {
                    rating = _rating;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              addButton(context),
            ],
          ),
        ));
  }

  addButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          side: BorderSide(
            color: Color(0xFF9C27B0),
          ),
        ),
        onPressed: () {
          // setState(() {
          //   hideFeedback = true;
          // });

          var dict = {
            "rating": rating.toString(),
            "breederId": _post.breeder.id.toString(),
            "postId": _post.id.toString()
          };
          _rateBloc.rateData(dict);
          // customPostDialog();
        },
        color: Colors.white,
        textColor: Colors.white,
        child: Text(
          "Submit Feedback",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xFF9C27B0),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  addViewers() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(children: [
          Text(
            _post.visits.toString(),
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Views",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ]));
  }

  addBottomBar() {
    return Container(
      color: Colors.transparent,
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: 3, left: 3),
        child: addConnectButton(),
      ),
    );
  }

  addOfferButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          if (enableToShowCount) {
            showDialogForHomeFound("2", context);
          } else {
            var dict = {"postId": _post.id.toString()};
            _bloc.markHomeFound(dict);
          }

          // if post is liter then we need to send type of like male female child
        },
        child: Text(
          "Mark as Home Found",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<bool> showDialogForHomeFound(String postType, contexts) {
    var maleCount = malecount;
    var femaleCount = femalecount;
    return showDialog(
        context: contexts,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
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
                            topRight: Radius.circular(20.0),
                          ),
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
                          context: context,
                        ),
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
                          context: context,
                        ),
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
                                        "" ||
                                    maleController.text
                                            .toString()
                                            .trim()
                                            .toString() ==
                                        "") {
                                  showToast("Please Enter male/female Number");
                                } else if (femaleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter female Number");
                                } else if (maleController.text
                                        .toString()
                                        .trim()
                                        .toString() ==
                                    "") {
                                  showToast("Please Enter male Number");
                                } else {
                                  var femaleRight = false;
                                  var maleRight = false;

                                  var numberfemaleRight =
                                      isNumeric(femaleController.text);
                                  if (numberfemaleRight) {
                                    int numberData =
                                        int.parse(femaleController.text);
                                    if (numberData > femaleCount) {
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
                                    if (numberData > maleCount) {
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
                                    var totalCount =
                                        int.parse(femaleController.text) +
                                            int.parse(maleController.text);
                                    var dict = {
                                      "postId": _post.id.toString(),
                                      "femaleCount":
                                          femaleController.text.toString(),
                                      "maleCount":
                                          maleController.text.toString(),
                                      "totalCount": totalCount.toString(),
                                    };

                                    _bloc.markHomeFound(dict);
                                  }
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  addConnectButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: loadindDone
          ? FlatButton(
              onPressed: () {
                connect();
              },
              textColor: Colors.white,
              child: Text(
                "Connect with Breeder",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  addSendButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 80,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          side: BorderSide(
            color: Color(0xFF9C27B0),
          ),
        ),
        onPressed: () {},
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text(
          "Send",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  addPrice() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 80,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          side: BorderSide(
            color: Color(0xFF9C27B0),
          ),
        ),
        onPressed: () {},
        color: Colors.white,
        textColor: Colors.black,
        child: Text(
          "90.00",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text("Make An Offer", style: kHeading),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur sit adipiscing elit, sed do eiusmod",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    color: Color(0xFF595959),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              space(),
              space(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F3FE),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        child: Text(
                          "Off 05%",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        padding: EdgeInsets.all(10),
                      )),
                  Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F3FE),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        child: Text(
                          "Off 10%",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        padding: EdgeInsets.all(10),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3FE),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: Padding(
                      child: Text(
                        "Off 15%",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              space(),
              // space(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    addPrice(),
                    addSendButton(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  addCount() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total :  $totalCount",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "male :  $malecount",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "female :  $femalecount",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  addfeMaleCount() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "female  $femalecount",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            addViewers()
          ],
        ));
  }

  addTitle() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Description",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            addViewers()
          ],
        ));
  }

  addDescription() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: new DescriptionTextWidget(text: _post.description),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 4.0,
      width: isActive ? 45.0 : 3.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
        //   color: Colors.pink,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int count) {
    List<Widget> list = [];
    for (int i = 0; i < count; i++) {
      list.add(i == _current ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  addSlider(events) {
    return Stack(
      children: [
        events.length != 0
            ? Column(children: [
                CarouselSlider.builder(
                  itemCount:
                      widget.isPreview ? widget.images.length : events.length,
                  itemBuilder: (context, index, val) {
                    if (widget.isPreview) {
                      var event = widget.images[index];
                      return _loadPreviewImage(event);
                    }
                    var event = events[index];
                    return _loadControllerImage(event.filename);
                  },
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.40,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                )
              ])
            : Container(),
        Positioned(
          bottom: 20,
          left: 30,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _post.name,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Image.asset(
                    "assets/location.png",
                    color: Colors.white,
                    width: 15,
                    height: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      _post.address,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              widget.isIamCreator == null
                  ? SizedBox(height: 10)
                  : SizedBox.shrink(),
              createdDataWidget(),
            ],
          ),
        ),
        Positioned(
          top: 60,
          left: 30,
          child: InkWell(
            child: Image.asset(
              "assets/back.webp",
              width: 20,
              height: 20,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        widget.isPreview
            ? Container(
                width: 0,
                height: 0,
              )
            : Positioned(
                top: 60,
                right: 30,
                child: Row(
                  children: [
                    InkWell(
                      child: Image.asset(
                        "assets/sidebar/share.webp",
                        width: 20,
                        height: 20,
                      ),
                      onTap: () {
                        share(type: "pet", id: widget.id);
                      },
                    ),
                    SizedBox(width: 20),
                    isGuestLogin
                        ? Container()
                        : isBreeder
                            ? userid.toString() == _post.breeder.id.toString()
                                ? InkWell(
                                    child: Image.asset(
                                      'assets/edit.png',
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    onTap: () {
                                      addPost();
                                    },
                                  )
                                : SizedBox.shrink()
                            : InkWell(
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  child: new Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: _post.isFavourite == 1
                                            ? new AssetImage(
                                                'assets/heart.webp')
                                            : new AssetImage(
                                                "assets/unselectedHeart.webp",
                                              ),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(10.0)),
                                    border: new Border.all(
                                      color: Colors.white,
                                      width: 4.0,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (_post.isFavourite == 0) {
                                      _post.isFavourite = 1;
                                    } else {
                                      _post.isFavourite = 0;
                                    }
                                    Map<String, String> body = <String, String>{
                                      'postId': _post.id.toString(),
                                    };
                                    _favBloc.setFavorite(body);
                                  });
                                },
                              ),
                    deleteDataWidget(),
                  ],
                ),
              ),
      ],
    );
  }

  addPost() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetClass(
          dict: _post,
          fromDrafts: false,
          id: _post.id.toString(),
        ),
      ),
    );
    if (result != null) {
      _postDetailBloc.getPostData(id);
    }
  }

  Widget _loadControllerImage(filename) {
    return InkWell(
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black],
          ).createShader(
            Rect.fromLTRB(0, 0, rect.width, rect.height),
          );
        },
        blendMode: BlendMode.darken,
        child: filename != null
            ? CachedNetworkImage(
                imageUrl: filename,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : Container(),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewLCass(url: filename),
          ),
        );
      },
    );
  }

  Widget _loadPreviewImage(filename) {
    return InkWell(
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.transparent],
            ).createShader(
              Rect.fromLTRB(0, 0, rect.width, rect.height),
            );
          },
          blendMode: BlendMode.darken,
          child: filename != null
              ? new Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                    ),
                    Align(
                      child: Image.file(
                        filename,
                        fit: BoxFit.cover,
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                )
              : Container(),
        ),
        onTap: () {});
  }

  space() {
    return SizedBox(height: 10);
  }

  addRow() {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: _post.breeder.profileImg != null
            ? CachedNetworkImage(
                imageUrl: _post.breeder.profileImg,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover)
            : Container(),
      ),
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Text(
          _post.breeder.firstName + " " + _post.breeder.lastName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 17,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          addrating(),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "\$ " + _post.price,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Color(0xFF9C27B0),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  addProperties() {
    print("_post.filter :- " + _post.filter.toString());
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: _post.filter.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEEEBFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                height: 90,
                width: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    printWiget(_post.filter[position].id.toUpperCase()),
                    Text(
                      _post.filter[position].id.toUpperCase(),
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    space(),
                    Text(
                      _post.filter[position].value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        color: Color(0xff595959),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  addFeaturedPets() {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _post.feturedPost.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      "No Similar Featured Pets Avaialble",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    "Featured Pets",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            // Text(
            //   "Show All",
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontFamily: "Montserrat",
            //     fontSize: 12,
            //     fontStyle: FontStyle.normal,
            //     fontWeight: FontWeight.w500,
            //     decoration: TextDecoration.underline,
            //   ),
            // )
          ],
        ));
  }

  addpetsList() {
    print("_post.feturedPost :- " + _post.feturedPost.toString());
    print("_post.feturedPost :- " + _post.feturedPost.isEmpty.toString());

    return _post.feturedPost.isEmpty
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: _post.feturedPost.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _post.feturedPost[position].filename != null
                                    ? CachedNetworkImage(
                                        imageUrl: _post
                                            .feturedPost[position].filename,
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                                space(),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                        _post.feturedPost[position].name,
                                        style: kTextFeildStyle,
                                        maxLines: 1)),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      _post.feturedPost[position].address,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Color(0xff595959),
                                          fontWeight: FontWeight.w500),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "34",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Montserrat",
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PetDetailClass(
                                          id: _post.feturedPost[position].id
                                              .toString(),
                                          fromBreeder: false,
                                          isPreview: false,
                                          images: [],
                                          post: null,
                                        )));
                          },
                        ));
                  }),
            ),
          );
  }

  addrating() {
    var rating = 0.0;
    if (_post.breeder.rating.toString() == "null") {
    } else {
      rating = double.parse(_post.breeder.rating.toString());
    }
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 18,
      ignoreGestures: true,
      //  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),

      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  void paymentCheck() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CardAdd(
                  price: _post.price,
                )));
  }

  Future<void> cardCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customer_id = prefs.getString(STRIPECUSTOMERID).toString();
    print("val :- " + customer_id.toString());
    if (customer_id == 'null') {
      return;
    }

    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
    //     .then((paymentMethod) {
    //   print("paymentMethod :-" + paymentMethod.id);
    //   var token = paymentMethod.id;
    //   paymentConfirm(context, customer_id, token);
    // }).catchError(setError);
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

  Future<void> paymentConfirm(context, customer_id, token) async {
    attachCard(customer_id, token, context);
    var pmId = await cardIntentReturn(context, customer_id, token, _post.price);
    if (pmId.toString() == "" || pmId.toString() == 'null') {
    } else {
      payToStripeConfirm(pmId, token, context);
    }
  }

  void connect() async {
    setState(() {
      _isLoading = true;
    });
    // Dialogs.showLoadingDialog(context, _keyLoader);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + "connectwithBreeder");
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['breederId'] = _post.breeder.id.toString();
    request.fields['postId'] = _post.id.toString();
    request.fields['offer'] = "5 %";
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      setState(() {
        _isLoading = false;
      });
      // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        var channel_name = data["channel_name"];
        var convstnID = data["conversations_id"];

        print(response.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainChatClass(
                      breederid: _post.breeder.id.toString(),
                      postid: _post.id.toString(),
                      channelid: channel_name.toString(),
                      name: _post.breeder.firstName +
                          " " +
                          _post.breeder.lastName,
                      profile: _post.breeder.profileImg,
                      conversation_id: convstnID.toString(),

                      /* status: chats[position].status,
              price: chats[position].price,
              commitment_fee: "",
              isBreeder: chats[position].isBreeder,
              totalCount: chats[position].totalCount,
              postType: chats[position].postType,*/
                      price: "",
                      commitment_fee: "",
                      status: "",
                    )));
      } else {}
    });
  }

  Future<bool> customPostDialog() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/banner/rating.webp',
                        height: 150,
                      ),
                    ),
                    Positioned(
                      child: InkWell(
                        child: Image.asset("assets/cancelgradient.webp"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      width: 20,
                      height: 20,
                      right: 10,
                      top: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Thank You ",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "For the Feedback",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "You have successfully submitted your valuable feedback to the breader.",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
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

  checkPostType() {
    if (enableToShowCount) {
      return addCount();
    }
    return SizedBox.shrink();
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  data() {
    print("_post :- " + _post.toString());
    return SizedBox.shrink();
  }

  dataItems() {}

  printWiget(upperCase) {
    print("upperCase- " + upperCase.toString());
    return SizedBox.shrink();
  }

  bottomButtonManage() {
    print("homeFound---" + "isBreeder---" + isBreeder.toString());
    print("homeFound---" + "status---" + status.toString());
    print("homeFound---" + "userid---" + userid.toString());
    print("homeFound---" + "breederUserid---" + breederUserid.toString());
    print("homeFound---" + "isIamCreator---" + widget.isIamCreator.toString());
    checkId = userid.toString();
    if (checkId == "" || checkId == "null") {
      checkId = "NA";
    }
    return widget.isIamCreator == null
        ? isBreeder
            ? status == "2"
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : checkId == breederUserid.toString()
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 30),
                        // child: SizedBox.shrink(),
                        child: addOfferButton(),
                      )
                    : addBottomBar()
            : status == "1"
                ? addBottomBar()
                : Container(
                    width: 0,
                    height: 0,
                  )
        : Container(
            width: 0,
            height: 0,
          );
  }

  subscribeBtn() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Subscription(
                      customerId: widget.customer_id,
                      request: widget.requestData,
                      isPreview: "yes")));
        },
        // color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Post", style: kButtontyle),
      ),
    );
  }

  void lazyLoad() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        loadindDone = true;
      });
    });
  }

  createdDataWidget() {
    return widget.isIamCreator == null
        ? Text(
            "Created Date : " + _post.created_at.toString(),
            style: TextStyle(color: Colors.white),
          )
        : SizedBox.shrink();
  }

  deleteDataWidget() {
    print("_postData " + "userId" + userid.toString());
    print("_postData " + "breederId" + _post.breeder.id.toString());
    if (userid.toString() == _post.breeder.id.toString()) {
      return widget.isIamCreator == null
          ? Row(
              children: [
                SizedBox(width: 20),
                InkWell(
                  child: Image.asset(
                    "assets/sidebar/delete.png",
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    _onDeletePost();
                  },
                )
              ],
            )
          : SizedBox.shrink();
    }
    return SizedBox.shrink();
  }

  Future<bool> _onDeletePost() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to delete this post.'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost(_post.id, ApiProvider.baseUrl + DELETEPOST);
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

  Future<String> deletePost(postId, url) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['postId'] = postId.toString();
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Map data = jsonDecode(await value);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        _showToast("Post Delete Successfully");
        Navigator.pushNamed(context, BaseClass.routeName);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        print(response);
      }
    });
  }
}
