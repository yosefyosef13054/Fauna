import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/chat_bloc.dart';
import 'package:fauna/home/chat_class.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/models/chat_list.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:fauna/supportingClass/sidebar/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class ChatListClass extends KFDrawerContent {
  final bool fromMenu;

  ChatListClass({this.fromMenu});

  @override
  _ChatClassState createState() => _ChatClassState();
}

class _ChatClassState extends State<ChatListClass> implements StateListener {
  int segmentedControlValue = 0;
  ChatBloc _chatBloc;
  List<ChatList> chats = [];
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var loadingDone = false;

  _ChatClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chatBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatBloc = ChatBloc();
    getConnect();
    _chatBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);
            loadingDone = false;
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            loadingDone = true;
            chats = event.data;
            break;
          case Status.ERROR:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            loadingDone = true;
            _showAlert(context, event.message);
            break;
        }
      });
    });
    //getChats();
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

  void getConnect() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _chatBloc.getChatList();
      }
    } on SocketException catch (_) {
      showToast('No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: widget.fromMenu
              ? IconButton(
                  icon: Icon(Icons.menu, color: Color(0xff080040)),
                  onPressed: () {
                    widget.onMenuPressed();
                  },
                )
              : SizedBox.shrink(),
          title: Text(
            "Chats",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white),
      body: isGuestLogin
          ? Center(child: guestuser(context))
          : chats.isEmpty
              ? loadingDone
                  ? Center(
                      child: Image.asset(
                        "assets/no_chat_message.png",
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    )
                  : null
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      //  addSegment(),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // addHorizontalList(),
                      SizedBox(
                        height: 10,
                      ),
                      addUsersListView()
                    ],
                  ),
                ),
    );
  }

  addSegment() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CupertinoSlidingSegmentedControl(
          groupValue: segmentedControlValue,
          children: const <int, Widget>{
            0: Text('User'),
            1: Text('Breeder'),
          },
          onValueChanged: (value) {
            setState(() {
              segmentedControlValue = value;
            });
          }),
    );
  }

  addAllbutton(str) {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 20,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      ),
      child: SizedBox(
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  str,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: "Montserrat",
                  ),
                ))),
      ),
      onPressed: () {},
    );
  }

  addHorizontalList() {
    return Container(
      height: 60,
      child: ListView(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        children: [
          addAllbutton("All"),
          SizedBox(
            width: 10,
          ),
          addAllbutton("Bought"),
          SizedBox(
            width: 10,
          ),
          addAllbutton("Commitment Fee"),
          SizedBox(
            width: 10,
          ),
          addAllbutton("Cancelled"),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  addUsersListView() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (context, position) {
          return Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
              child: InkWell(
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircularImage(
                                CachedNetworkImageProvider(
                                    chats[position].profileImg),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  addOwnername(chats[position].firstName +
                                      " " +
                                      chats[position].lastName),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  addDogname(
                                      chats[position].post_name.toString()),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  //  addStatus(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          chats[position].unread.toString() == "0"
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.all(10.0),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color(0xffB1308A),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Text(
                                    chats[position].unread.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ]),
                    addBorder()
                  ],
                ),
                onTap: () {
                  navigateToMain(position);
                },
              ));
        });
  }

  navigateToMain(position) async {
    /*postType
     totalCount*/
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainChatClass(
                  breederid: chats[position].breederId.toString(),
                  postid: chats[position].postId,
                  channelid: chats[position].channelName,
                  name: chats[position].firstName +
                      " " +
                      chats[position].lastName,
                  profile: chats[position].profileImg,
                  conversation_id: chats[position].id,
                  status: chats[position].status,
                  price: chats[position].price,
                  commitment_fee: "",
                  isBreeder: chats[position].isBreeder,
                  totalCount: chats[position].totalCount,
                  postType: chats[position].postType,
                  femaleCount: chats[position].femaleCount,
                  maleCount: chats[position].maleCount,
                )));
    //print("result :- " + result.toString());
    if (result == null) {
    } else {
      chats = [];
      _chatBloc.getChatList();
    }
  }

  addOwnername(str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        fontFamily: "Montserrat",
      ),
    );
  }

  addDogname(str) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Text(
        str,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }

  addBorder() {
    return Divider(
      color: Color(0xffB7B7B7),
      height: 1,
    );
  }

  addStatus() {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xffFF0000).withOpacity(0.5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            " \u2022 Cancelled",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red,
              fontFamily: "Montserrat",
            ),
          ),
        ));
  }

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    // TODO: implement onStateChanged
    if (state == ObserverState.UPDATECHATLIST) {
      // chats = [];
      _chatBloc.getChatList();
    }
  }
}
