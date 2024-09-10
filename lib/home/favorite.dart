import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

// import 'package:connectivity/connectivity.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/home/petLists.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/posts_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/login.dart';
import 'package:fauna/onboarding/register.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class FavoriteClass extends KFDrawerContent {
  final bool fromTab;
  final bool fromHome;

  FavoriteClass({this.fromTab, this.fromHome});

  @override
  _FavoriteClassState createState() => _FavoriteClassState();
}

class _FavoriteClassState extends State<FavoriteClass> {
  bool _isLoading = true;
  bool isInternetOn = false;
  List<PostsModel> _posts;
  FavBloc _favBloc;
  FavListBloc _favListBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var bodyParam;

  @override
  void dispose() {
    _posts = [];
    _favBloc.dispose();
    _favListBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    GetConnect();
  }

  void GetConnect() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        favInitData();
      }
    } on SocketException catch (_) {
      print('not connected');
      showToast('No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: widget.fromTab ? true : false,
            leading: !widget.fromTab
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
                    onPressed: () {
                      if (widget.fromHome) {
                        Navigator.pop(context);
                      } else {
                        // StateProvider _stateProvider = StateProvider();
                        widget.onMenuPressed();
                      }
                    },
                  )
                : Container(),
            title: Text(
              !widget.fromHome ? "Favourite" : "Featured Pets",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        body: widget.fromHome
            ? _isLoading
                ? Container()
                : mainWidget()
            : isGuestLogin
                ? guestuser(context)
                : _isLoading
                    ? Container()
                    : mainWidget());
  }

  mainWidget() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: _posts.length == 0
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/banner/Favorite.webp",
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No favorites yet!",
                      style: kHeading,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "When you select the heart icon on pet listing in the explore section of the app they will be added here for easy access.",
                      textAlign: TextAlign.center,
                      style: kSubHeading,
                    ),
                    SizedBox(height: 30),
                    //addSaveButton()
                  ],
                ))
            : SingleChildScrollView(
                child: Column(
                children: [
                  new GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: new List.generate(_posts.length, (index) {
                      return new GridTile(
                          child: InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0)),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      child: CachedNetworkImage(
                                        imageUrl: _posts[index].filename,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2 *
                                                0.60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    isGuestLogin
                                        ? Container()
                                        : Positioned(
                                            top: 20,
                                            right: 10,
                                            child: InkWell(
                                              child: Container(
                                                width: 20.0,
                                                height: 20.0,
                                                child: new Container(
                                                  width: 10.0,
                                                  height: 10.0,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                      image: _posts[index]
                                                                  .isFavourite ==
                                                              1
                                                          ? new AssetImage(
                                                              'assets/heart.webp')
                                                          : new AssetImage(
                                                              "assets/unselectedHeart.webp"),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          new Radius.circular(
                                                              10.0)),
                                                  border: new Border.all(
                                                    color: Colors.white,
                                                    width: 4.0,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (_posts[index]
                                                          .isFavourite ==
                                                      0) {
                                                    _posts[index].isFavourite =
                                                        1;
                                                  } else {
                                                    _posts[index].isFavourite =
                                                        0;
                                                  }
                                                });
                                                Map<String, String> body =
                                                    <String, String>{
                                                  'postId': _posts[index]
                                                      .id
                                                      .toString(),
                                                };
                                                _favBloc.setFavorite(body);
                                                unfavCall();
                                              },
                                            ),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(_posts[index].name,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1)),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(_posts[index].description,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 10,
                                            color: Color(0xffAEAEAE),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 1)),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                        "\$" + _posts[index].price.toString(),
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1)),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                              // ),
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PetDetailClass(
                                        id: _posts[index].id.toString(),
                                        fromBreeder: false,
                                        isPreview: false,
                                        post: null,
                                        images: null,
                                      )));
                        },
                      ));
                    }),
                  ),
                ],
              )));
  }

  void favInitData() async{
    await getLatLong();
    if (mounted) _favBloc = FavBloc();
    _favListBloc = FavListBloc();
    setState(() {
      if (widget.fromHome) {
        _favListBloc.getFeaturedPets(bodyParam);
      } else {
        if (isGuestLogin) {
        } else {
          _favListBloc.getFavorites();
        }
      }
      _favListBloc.loginStream.listen((event) {
        if (mounted)
          setState(() {
            switch (event.status) {
              case Status.LOADING:
                Dialogs.showLoadingDialog(context, _keyLoader);
                _isLoading = true;
                break;
              case Status.COMPLETED:
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                _isLoading = false;
                _posts = event.data;
                break;
              case Status.ERROR:
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                _isLoading = false;
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
              // if (widget.fromHome) {
              //   _favListBloc.getFeaturedPets();
              // } else {
              //   if (isGuestLogin) {
              //   } else {
              //     _favListBloc.getFavorites();
              //   }
              // }
              break;
            case Status.ERROR:
              break;
          }
        });
      });
    });
  }

  getLatLong() async {
    if (await Permission.locationAlways.serviceStatus.isEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        bodyParam = {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };
      });
    } else {
      setState(() {
        bodyParam = {
          'latitude': '',
          'longitude': '',
        };
      });
    }
    print('get user location $bodyParam');
  }

  void unfavCall() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        favInitData();
      });
    });
  }

//   addSaveButton() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.80,
//       height: 50,
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10)),
//             side: BorderSide(color: Color(0xFF9C27B0))),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => BreederslistClass(
//                       showFilters: true, dict: null, categoryName: "")));
//         },
//         color: Color(0xFF9C27B0),
//         textColor: Colors.white,
//         child: Text("Start Wishlisting",
//             style: TextStyle(
//                 fontFamily: "Montserrat",
//                 fontStyle: FontStyle.normal,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
}

Widget guestuser(context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/login.webp"),
          SizedBox(
            height: 20,
          ),
          Text(
            "Please login or register",
            style: kHeading,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Please login or register to explore more features or to save post. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                style: kSubHeading,
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 20,
          ),
          addSaveButton(context),
          SizedBox(
            height: 10,
          ),
          addRegisterButton(context)
        ],
      ));
}

addSaveButton(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.80,
    height: 50,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          side: BorderSide(color: Color(0xFF9C27B0))),
      onPressed: () {
        Navigator.pushNamed(context, LoginCLass.routeName);
      },
      color: Color(0xFF9C27B0),
      textColor: Colors.white,
      child: Text("Sign In",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 18,
              fontWeight: FontWeight.w600)),
    ),
  );
}

addRegisterButton(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.80,
    height: 50,
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          side: BorderSide(color: Color(0xFF9C27B0))),
      onPressed: () {
        Navigator.pushNamed(context, RegisterCLass.routeName);
      },
      color: Colors.white,
      textColor: Colors.white,
      child: Text("Sign Up",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xFF9C27B0),
              fontWeight: FontWeight.w600)),
    ),
  );
}
