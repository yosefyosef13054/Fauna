import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fauna/Breeder/breeder_posts.dart';
import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/home/baseTabbarClass.dart';
import 'package:fauna/home/chatlistClass.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/payment/payment_history.dart';
import 'package:fauna/home/profile.dart';
import 'package:fauna/home/settings.dart';
import 'package:fauna/home/share.dart';
import 'package:fauna/home/support.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/login.dart';
import 'package:fauna/supportingClass/classBuilder.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'disputes.dart';
import 'payment/payment_methods.dart';

class BaseClass extends StatefulWidget {
  BaseClass({Key key}) : super(key: key);
  static const routeName = '/base_class';

  @override
  _BaseClassState createState() => _BaseClassState();
}

class _BaseClassState extends State<BaseClass>
    with TickerProviderStateMixin
    implements StateListener {
  KFDrawerController _drawerController;

  var _username = "";
  var _phone = "";
  var _profile = "";

  LogoutBloc _logoutBloc;
  bool _isLoading = false;

  _BaseClassState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _username = prefs.getString(USERNAME);
      _phone = prefs.getString(USERPHONE);
      _profile = prefs.getString(USERPROFILE);
    });
  }

  @override
  void dispose() {
    _logoutBloc.dispose();
    super.dispose();
  }

  logoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(AUTHTOKEN);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginCLass(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _logoutBloc = LogoutBloc();
    _logoutBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            removeToken();
            Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginCLass()));
            break;
          case Status.ERROR:
            _isLoading = false;
            Navigator.pop(context);
            _showAlert(context, event.message);
            break;
        }
      });
    });
    getUser();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('TabBarController'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Explore', style: kDrawerstyle),
          icon: Image.asset(
            "assets/explore.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: TabBarController(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Profile',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/profile.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: ProfileClass(fromMenu: true),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Invite Friends',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/invite.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: ShareClass(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Chat History',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/chats.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: ChatListClass(fromMenu: true),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Favorites',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/fav.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: FavoriteClass(
            fromTab: false,
            fromHome: false,
          ),
        ),
        // KFDrawerItem.initWithPage(
        //   text: Text(
        //     'Payment Method',
        //     style: kDrawerstyle,
        //   ),
        //   icon: Image.asset(
        //     "assets/sidebar/paymnt.webp",
        //     width: 20,
        //     height: 20,
        //     color: Colors.white,
        //   ),
        //   page: ShareClass(),
        // ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Payment Method',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/paymnt.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: PaymentMethodsClass(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Payment History',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/share.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: PaymentHistoryClass(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'My Pets',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/mylist.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: ISBREEDER == 1
              ? MyPostsClass(
                  fromMenu: true,
                )
              : MyPostsClass(
                  fromMenu: true,
                ),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Disputes',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/Disputes.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: Disputes(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Support',
            style: kDrawerstyle,
          ),
          icon: Image.asset(
            "assets/sidebar/support.webp",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: SupportClass(),
        ),
      ],
    );
  }

  removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(AUTHTOKEN);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        _onBackPressed();
      },
      child: Scaffold(
        body: KFDrawer(
          scrollable: true,
          controller: _drawerController,
          header: isGuestLogin
              ? Container(
                  height: 100,
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    height: 100,
                    // width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DottedBorder(
                          borderType: BorderType.Circle,
                          radius: Radius.circular(25),
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: _profile != ""
                                ? CachedNetworkImage(
                                    imageUrl: _profile,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_username,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500)),
                            Text(
                              _phone,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/sidebar/settings.webp",
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Settings', style: kDrawerstyle),
                    ],
                  )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingClass()));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  color: Colors.white,
                  width: 1,
                  height: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Container(
                    child: Text('Logout', style: kDrawerstyle),
                  ),
                  onTap: () {
                    if (isGuestLogin) {
                      isGuestLogin = false;
                      Navigator.pop(context);
                    } else {
                      onLogoutPressed();
                    }
                  },
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xffB1308A),
                Color(0xffB1308A),
              ], //0xFF9C27B0
              tileMode: TileMode.repeated,
            ),
          ),
        ),
      ),
    );
  }

  onLogoutPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to Logout?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    logout();
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

  logout() async {
    _logoutBloc.logout();
  }

  void _showAlert(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Alert"),
              content: Text(str),
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

  @override
  void onStateChanged(ObserverState state, Map<String, dynamic> dict) {
    // TODO: implement onStateChanged
    if (state == ObserverState.UPDATEPROFILE) {
      getUser();
    }
  }
}
