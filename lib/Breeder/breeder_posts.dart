import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/Breeder/add_pet.dart';
import 'package:fauna/class/shimmerEffects/imageloadshimmer.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/myposts.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPostsClass extends KFDrawerContent {
  final bool fromMenu;

  MyPostsClass({this.fromMenu});

  @override
  _MyPostsClassState createState() => _MyPostsClassState();
}

class _MyPostsClassState extends State<MyPostsClass> {
  bool nodata = true;
  List<my_posts> _list = List();
  List<bool> inputsRecently = new List<bool>();
  var loaddingData = false;
  String userid = "";
  var isBreeder = 0;

  @override
  void initState() {
    super.initState();
    getUser();
    myPostLoad();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var val = prefs.getInt(ISBREEDER);
    if (mounted)
      setState(() {
        userid = prefs.getString(USERID);
        isBreeder = val;
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 1.8;
    return Scaffold(
        floatingActionButton: widget.fromMenu
            ? null
            : loaddingData
                ? nodata
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 10.0),
                        child: FloatingActionButton(
                          heroTag: "CreateEvent",
                          onPressed: () {
                            addPost();
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Color(0xFF9C27B0),
                        ))
                : null,
        appBar: loaddingData
            ? AppBar(
                centerTitle: widget.fromMenu ? false : true,
                leading: widget.fromMenu
                    ? IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
                        onPressed: () {
                          widget.onMenuPressed();
                        },
                      )
                    : SizedBox.shrink(),
                title: Text(
                  widget.fromMenu ? "My Pets" : "My Posts",
                  style: TextStyle(
                      color: Color(0xff080040),
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.white)
            : null,
        body: loaddingData
            ? nodata
                ? widget.fromMenu
                    ? Center(
                        child: Image.asset(
                          "assets/no_history_available.webp",
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                      )
                    : addDetails()
                : GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                    children: List.generate(_list.length, (index) {
                      return Center(
                        child: listItems(
                            _list, inputsRecently, index, context, itemHeight),
                      );
                    }))
            : Container(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xffB1308A)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Wait....",
                            style: TextStyle(color: Color(0xffB1308A)),
                          )
                        ]),
                  ),
                ),
              ));
  }

  Widget addDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/banner/emptyPost.webp",
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.width * 0.80,
        ),
        SizedBox(
          height: 20,
        ),
        Text("Add Pet Details",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
                "In the next screen you will be prompted to enter details that make your pet unique. Providing as much information as possible is going to generate a lot of interest and eventually help you find a suitable home for your pet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500))),
        SizedBox(
          height: 35,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: addDemoBreederButton())
      ],
    );
  }

  addDemoBreederButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 30,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          addPost();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Add Pet", style: kButtontyle),
      ),
    );
  }

  Future<void> myPostLoad() async {
    ApiProvider _apiProvider = ApiProvider();
    var ENDPOINT = widget.fromMenu ? MYPOSTBUY : MYPOST;

    var _listDatas = jsonDecode(
      await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + ENDPOINT,
        TOKENKEY,
      ),
    );
    _list =
        _listDatas.map<my_posts>((json) => my_posts.fromJson(json)).toList();
    if (mounted)
      setState(() {
        if (_list.length < 1) {
          nodata = true;
        } else {
          nodata = false;
        }
        loaddingData = true;
      });
  }

  listItems(List<my_posts> _list, input, index, context, itemHeight) {
    return GestureDetector(
      onTap: () {
        if (widget.fromMenu) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetDetailClass(
                id: _list[index].id.toString(),
                fromBreeder: true,
                isPreview: false,
                post: null,
                images: null,
              ),
            ),
          );
        } else if (_list[index].status.toString() == "4") {
          moveTodrafts(index);
        } else {
          if (isBreeder == 0) {
            // Navigator.push(   context,MaterialPageRoute(
            //         builder: (context) => PetDetailClass(
            //               id: _list[index].id.toString(),
            //               fromBreeder: false,
            //               isPreview: false,
            //               post: null,
            //               images: null)));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetailClass(
                  id: _list[index].id.toString(),
                  fromBreeder: true,
                  isPreview: false,
                  post: null,
                  images: null,
                ),
              ),
            );
          }
        }
      },
      child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      _list[index].filename != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              child: CachedNetworkImage(
                                  height: itemHeight / 1.8,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl: _list[index].filename,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      imageShimmer(context, 40.0),
                                  errorWidget: (context, url, error) {}),
                            )
                          : Container(),
                      statusAndType(_list[index]),
                      _list[index].isOwner.toString() == "1"
                          ? _list[index].status.toString() == '2'
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      color: Colors.pink,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      height: 20.0,
                                      child: Center(
                                          child: Text(
                                        "Home found",
                                        style: TextStyle(color: Colors.white),
                                      ))))
                              : _list[index].type.toString() == '2'
                                  ? Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                          color: Colors.pink,
                                          width: 60.0,
                                          height: 20.0,
                                          child: Center(
                                              child: Text(
                                            "Featured",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))))
                                  : _list[index].status.toString() == '4'
                                      ? Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              color: Colors.pink,
                                              width: 60.0,
                                              height: 20.0,
                                              child: Center(
                                                  child: Text(
                                                "Drafts",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))))
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(_list[index].name,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 12,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500),
                          maxLines: 1)),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(_list[index].description.toString(),
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 10,
                              color: Color(0xffAEAEAE),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400),
                          maxLines: 1)),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //     padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  //     child: Text("\$ " + '${_list[index].price ?? ''}',
                  //         style: TextStyle(
                  //             fontFamily: "Montserrat",
                  //             fontSize: 10,
                  //             color: Colors.black,
                  //             fontStyle: FontStyle.normal,
                  //             fontWeight: FontWeight.w500),
                  //         maxLines: 1)),
                  // SizedBox(
                  //   height: 5,
                  // ),
                ],
                // ),
              ))),
    );
  }

  Future<void> addPost() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPetClass(
                  dict: null,
                  fromDrafts: true,
                  id: "",
                )));

    print("result :- " + result.toString());
    if (result == null) {
    } else {
      myPostLoad();
    }
  }

  Future<void> moveTodrafts(index) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPetClass(
                dict: null, fromDrafts: true, id: _list[index].id.toString())));

    print("result :- " + result.toString());
    if (result == null) {
    } else {
      myPostLoad();
    }
  }

  statusAndType(my_posts list) {
    print("status_-------" + list.status.toString());
    print("type-------" + list.type.toString());
    return SizedBox.shrink();
  }
}
