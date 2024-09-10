import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/posts_model.dart';
import 'package:fauna/models/showAllBreedsModel.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filter.dart';

class BreederslistClass extends KFDrawerContent {
  final bool showFilters;
  final String category;
  final String categoryName;
  final String isAll;
  final Map<String, String> dict;

  BreederslistClass({
    this.showFilters,
    this.category,
    this.categoryName,
    this.isAll,
    this.dict,
  });

  @override
  _BreederslistClassState createState() => _BreederslistClassState();
}

class _BreederslistClassState extends State<BreederslistClass>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String category;
  PostListBloc _postListBloc;
  List<PostsModel> _posts;
  List<AllBreeds> _allBreeds = [];
  bool _isLoading = false;
  FavBloc _favBloc;
  PostFliterBloc _postFliterBloc;
  ShowAllBreedsBloc _showBreedsBloc;
  List array;
  List keyarray;
  Map<String, String> dict;
  bool _showFilters;
  int page = 1;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyLoader1 = new GlobalKey<State>();

  String userid = "";

  @override
  void dispose() {
    _postListBloc.dispose();
    _postFliterBloc.dispose();
    _favBloc.dispose();
    _showBreedsBloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    page = 1;

    _showFilters = false;
    //_showFilters = widget.showFilters;
    _postListBloc = PostListBloc();
    _postFliterBloc = PostFliterBloc();
    _showBreedsBloc = ShowAllBreedsBloc();
    _favBloc = FavBloc();
    if (widget.isAll == 'showAll') {
      _showBreedsBloc.showAllBreeds(
        {'category': widget.category},
        page,
      );
    } else {
      if (widget.showFilters) {
        //  _postFliterBloc.getFilteredPosts(null);
      } else {
        category = widget.category;
        Map<String, String> body = <String, String>{
          'category': category,
          'latitude': '',
          'longitude': '',
        };
        _postListBloc.getPosts(body);
      }
    }
    _postListBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            // Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            _isLoading = false;
            // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _posts = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            _posts = [];
            _showAlert(context, event.message);
            break;
        }
      });
    });
    _postFliterBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _posts = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            _posts = [];
            _showAlert(context, event.message);
            break;
        }
      });
    });
    _showBreedsBloc.showBreedsStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            if (page == 1) {
              _isLoading = true;
            }
            break;
          case Status.COMPLETED:
            if (page == 1) {
              _isLoading = false;
            }
            _allBreeds = event.data.allBreeds;
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
    WidgetsBinding.instance.addObserver(this);
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
    userid = prefs.getString(USERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              widget.isAll == 'showAll'
                  ? SizedBox.shrink()
                  : InkWell(
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 5.0, color: Colors.white),
                              color: Colors.white),
                          child: Center(
                            child: Image.asset(
                              "assets/filter.webp",
                              width: 20,
                              height: 20,
                            ),
                          )),
                      onTap: () {
                        navigateToFilter();
                      },
                    )
            ],
            title: Text(
              widget.categoryName,
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              setState(() {
                page += 1;
                _showBreedsBloc.showAllBreeds(
                  {'category': widget.category},
                  page,
                );
              });
            }
          },
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xff9C27B0)),
                  ),
                )
              : SingleChildScrollView(
                  child: widget.isAll == 'showAll'
                      ? Container(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children:
                                new List.generate(_allBreeds.length, (index) {
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
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _allBreeds[index].filename,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 *
                                                    0.60,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.fitWidth,
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
                                                          decoration:
                                                              new BoxDecoration(
                                                            image:
                                                                new DecorationImage(
                                                              image: _allBreeds[
                                                                              index]
                                                                          .isFavourite ==
                                                                      1
                                                                  ? new AssetImage(
                                                                      'assets/heart.webp')
                                                                  : new AssetImage(
                                                                      "assets/unselectedHeart.webp"),
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            new BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              new BorderRadius
                                                                  .all(new Radius
                                                                      .circular(
                                                                  10.0)),
                                                          border:
                                                              new Border.all(
                                                            color: Colors.white,
                                                            width: 4.0,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          if (_allBreeds[index]
                                                                  .isFavourite ==
                                                              0) {
                                                            _allBreeds[index]
                                                                .isFavourite = 1;
                                                          } else {
                                                            _allBreeds[index]
                                                                .isFavourite = 0;
                                                          }
                                                          Map<String, String>
                                                              body =
                                                              <String, String>{
                                                            'postId':
                                                                _allBreeds[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                          };
                                                          _favBloc.setFavorite(
                                                              body);
                                                        });
                                                      },
                                                    ),
                                                  )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Text(_allBreeds[index].name,
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1)),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Text(
                                                _allBreeds[index].description,
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 10,
                                                    color: Color(0xffAEAEAE),
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                maxLines: 1)),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Text(
                                                "\$" +
                                                    _allBreeds[index]
                                                        .price
                                                        .toString(),
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1)),
                                      ],
                                      // ),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PetDetailClass(
                                                id: _allBreeds[index]
                                                    .id
                                                    .toString(),
                                                fromBreeder: false,
                                                isPreview: false,
                                                post: null,
                                                images: null,
                                              )));
                                },
                              ));
                            }),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              _showFilters
                                  ? array.length != 0
                                      ? addGridView()
                                      : Container()
                                  : Container(),
                              _posts.length == 0
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Center(
                                        child: Text(
                                          "No data available",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: 30),
                              new GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children:
                                    new List.generate(_posts.length, (index) {
                                  return new GridTile(
                                      child: InkWell(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(5.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5)),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        _posts[index].filename,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2 *
                                                            0.60,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.fitWidth,
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
                                                            child:
                                                                new Container(
                                                              width: 10.0,
                                                              height: 10.0,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                image:
                                                                    new DecorationImage(
                                                                  image: _posts[index]
                                                                              .isFavourite ==
                                                                          1
                                                                      ? new AssetImage(
                                                                          'assets/heart.webp')
                                                                      : new AssetImage(
                                                                          "assets/unselectedHeart.webp"),
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                              ),
                                                            ),
                                                            decoration:
                                                                new BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .all(new Radius
                                                                          .circular(
                                                                      10.0)),
                                                              border: new Border
                                                                  .all(
                                                                color: Colors
                                                                    .white,
                                                                width: 4.0,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              if (_posts[index]
                                                                      .isFavourite ==
                                                                  0) {
                                                                _posts[index]
                                                                    .isFavourite = 1;
                                                              } else {
                                                                _posts[index]
                                                                    .isFavourite = 0;
                                                              }
                                                              Map<String,
                                                                      String>
                                                                  body = <
                                                                      String,
                                                                      String>{
                                                                'postId': _posts[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                              };
                                                              _favBloc
                                                                  .setFavorite(
                                                                      body);
                                                            });
                                                          },
                                                        ),
                                                      )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                child: Text(_posts[index].name,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1)),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                child: Text(
                                                    _posts[index].description,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xffAEAEAE),
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    maxLines: 1)),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                child: Text(
                                                    "\$" +
                                                        _posts[index]
                                                            .price
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1)),
                                          ],
                                          // ),
                                        )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PetDetailClass(
                                                    id: _posts[index]
                                                        .id
                                                        .toString(),
                                                    fromBreeder: false,
                                                    isPreview: false,
                                                    post: null,
                                                    images: null,
                                                  )));
                                    },
                                  ));
                                }),
                              )
                            ],
                          ))),
        ));
  }

  navigateToFilter() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FilterClass()));
    if (result != null) {
      _showFilters = true;
      dict = result;
      array = dict.entries.map((entry) => "${entry.key}").toList();

      for (var val in array) {
        if (val == "latitude") {
          array.remove(val);
          break;
        }
      }
      for (var val in array) {
        if (val == "longitude") {
          array.remove(val);
          break;
        }
      }

      keyarray = dict.entries.map((entry) => "${entry.key}").toList();

      for (var val in keyarray) {
        if (val == "latitude") {
          array.remove(val);
          break;
        }
      }
      for (var val in keyarray) {
        if (val == "longitude") {
          array.remove(val);
          break;
        }
      }

      dict['category'] = category;
      _postListBloc.getPosts(dict);
    }
  }

  addGridView() {
    return new GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 2,
      childAspectRatio: 3.0,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: new List.generate(array.length, (index) {
        return new Container(
            decoration: BoxDecoration(
              color: Color(0xFF9C27B0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5.0),
                Expanded(
                  child: Text(
                    array[index],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  child: Icon(
                    Icons.clear_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      array.removeAt(index);
                      var value = keyarray[index];
                      keyarray.removeAt(index);
                      dict.remove(value);
                      _postListBloc.getPosts(dict);
                    });
                  },
                ),
                SizedBox(width: 5.0),
              ],
            ));
      }),
    );
  }
}
