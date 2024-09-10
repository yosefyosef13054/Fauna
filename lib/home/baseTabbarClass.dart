import 'dart:io';

import 'package:fauna/Breeder/breeder_posts.dart';
import 'package:fauna/Breeder/select_breeder.dart';
import 'package:fauna/class/deeplinkSet.dart';
import 'package:fauna/home/chat_class.dart';
import 'package:fauna/home/chatlistClass.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/home/profile.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarController extends KFDrawerContent {
  @override
  State<StatefulWidget> createState() {
    return TabBarControllerState();
  }
}

class TabBarControllerState extends State<TabBarController>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver
    implements StateListener {
  TabController _tabController;
  int currentIndex = 0;
  var isBreeder = 0;
  int _counter = 0;

  TabBarControllerState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var val = prefs.getInt(ISBREEDER);
    print("val-----" + val.toString());
    if (!mounted) return;
    setState(() {
      isBreeder = val;
    });
    /*var getRoute = prefs.getInt(GETROUTE);
    callRoute(prefs);
    if (getRoute != null) {
     callRoute(prefs);
    }*/
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUser();
    _tabController = new TabController(vsync: this, length: 5);
    _tabController.addListener(_handleTabSelection);
    initUniLinks(context);
  }

  _handleTabSelection() {
    setState(() {
      print(currentIndex);
      currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          _onBackPressed();
        },
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                    icon: new Image.asset("assets/explore.webp",
                        width: 22,
                        height: 22,
                        color: _tabController.index != 0
                            ? Colors.grey[400]
                            : Colors.pink),
                    text: "Explore"),
                Tab(
                    icon: _counter == 0
                        ? new Image.asset("assets/chats.webp",
                            width: 22,
                            height: 22,
                            color: _tabController.index != 1
                                ? Colors.grey[400]
                                : Colors.pink)
                        : new Stack(children: <Widget>[
                            new Image.asset("assets/chats.webp",
                                width: 22,
                                height: 22,
                                color: _tabController.index != 1
                                    ? Colors.grey[400]
                                    : Colors.pink),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: new Text(
                                  '$_counter',
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ]),
                    text: "Chats"),
                isGuestLogin
                    ? Tab(
                        icon: new Image.asset("assets/breeder.webp",
                            width: 22,
                            height: 22,
                            color: _tabController.index != 2
                                ? Colors.grey[400]
                                : Colors.pink),
                        text: "Breeder")
                    : isBreeder == 0
                        ? Tab(
                            icon: new Image.asset("assets/breeder.webp",
                                width: 22,
                                height: 22,
                                color: _tabController.index != 2
                                    ? Colors.grey[400]
                                    : Colors.pink),
                            text: "Breeder")
                        : isBreeder == 1
                            ? Tab(
                                icon: new Image.asset("assets/my_post.webp",
                                    width: 22,
                                    height: 22,
                                    color: _tabController.index != 2
                                        ? Colors.grey[400]
                                        : Colors.pink),
                                text: "My Posts")
                            : Tab(
                                icon: new Image.asset("assets/breeder.webp",
                                    width: 22,
                                    height: 22,
                                    color: _tabController.index != 2
                                        ? Colors.grey[400]
                                        : Colors.pink),
                                text: "Breeder"),
                Tab(
                    icon: new Image.asset("assets/favorites.webp",
                        width: 22,
                        height: 22,
                        color: _tabController.index != 3
                            ? Colors.grey[400]
                            : Colors.pink),
                    text: "Favourite"),
                Tab(
                    icon: new Image.asset("assets/profile.webp",
                        width: 22,
                        height: 22,
                        color: _tabController.index != 4
                            ? Colors.grey[400]
                            : Colors.pink),
                    text: "Profile"),
              ],
              indicatorColor: Colors.transparent,
              labelColor: Colors.pink,
              labelPadding: EdgeInsets.all(1),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 10),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeClass(callback: callback, isBreederCall: isBreederCall),
                ChatListClass(fromMenu: false),
                isGuestLogin
                    ? SelectBreederClass(
                        isStatus: 1,
                      )
                    : isBreeder == 1
                        ? MyPostsClass(
                            fromMenu: false,
                          )
                        : isBreeder == 0
                            ? SelectBreederClass(
                                isStatus: 1,
                              )
                            : SelectBreederClass(
                                isStatus: 2,
                              ),
                FavoriteClass(
                  fromTab: true,
                  fromHome: false,
                ),
                ProfileClass(fromMenu: false),
              ],
              controller: _tabController,
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
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

  void callback() {
    setState(() {
      widget.onMenuPressed();
    });
  }

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dictData) {
    // TODO: implement onStateChanged
    print("StateChange---");
    var dict;
    dict = dictData;
    print("StateChange---dict : " + dict.toString());
    print("StateChange---//" + state.toString());
    if (state == ObserverState.UPDATEBREEDER) {
      print(dict["status"]);
      isBreeder = dict["status"];
    }
    if (state == ObserverState.UPDATECOUNTER) {
      print(dict["counter"]);
      setState(() {});
      _counter = dict["counter"];
    }
    if (state == ObserverState.UPDATEBREEDERFROMBREEDER) {
      isBreeder = dict["status"];
    }

    if (state == ObserverState.UPDATECOUNTERNOTIFICATION) {
      setState(() {
        _counter = _counter + 1;
      });
    }

    if (state == ObserverState.NOTIFICATION) {
      print("NotificationGet :-");
      print(dict);
      var type = dict["type"].toString();
      if (type == "null") {
        if (Platform.isAndroid) {
          type = dict["data"]['type'].toString();
          dict = dict["data"];
        } else {}
      }
      print("NotificationGet type :-" + type);

      if (type == "1") {
        //CHAT NOTIFICTATION
        if (CURRENTSCREEN == "CHAT") {
          Navigator.pop(context);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainChatClass(
              breederid: dict["breederId"].toString(),
              postid: dict["postId"],
              channelid: dict["channel_name"],
              name: dict["firstName"] + " " + dict["lastName"],
              profile: dict["profile_img"],
              conversation_id: dict["conversations_id"],
              price: dict["price"],
              status: dict["status"],
              commitment_fee: dict["commitment_fee"],
              isBreeder: dict["isBreeder"],
              /*chats[position].isBreeder,*/
              totalCount: dict["totalCount"],
              /*chats[position].totalCount,*/
              postType: dict["postType"],
              /*chats[position].postType,*/
              femaleCount: dict["femaleCount"],
              /*chats[position].femaleCount,*/
              maleCount: dict["maleCount"], /*chats[position].maleCount,*/
            ),
          ),
        );
        print(dict);
      } else if (type == "2") {
        updateBreeder(int.parse(dict["status"]));
        setState(() {
          isBreeder = int.parse(dict["status"]);
        });
        //Breeder Approved by ADMIN
      }
      // else if (type == "3") {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PetDetailClass(
      //         id: dict['reference_id'].toString(),
      //         fromBreeder: true,
      //         isPreview: false,
      //         post: null,
      //         images: null,
      //       ),
      //     ),
      //   );
      // }
    }
  }

  updateBreeder(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ISBREEDER, status);
    if (!mounted) return;
  }

  isBreederCall() {
    checkBreeder();
  }

  Future<void> checkBreeder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var data = prefs.getInt(ISBREEDER);
      print("data@@---" + data.toString());
      //0 not breeder
      //1 breeder
      //2 pending
      if (data.toString() == '1') {
        isBreeder = 1;
      } else {
        isBreeder = 0;
      }
    });
  }

  void callRoute(SharedPreferences prefs) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _tabController.index = 2;
      });
      prefs.remove(GETROUTE);
    });
  }
}
