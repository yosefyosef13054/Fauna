import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/breeder_detail.dart';
import 'package:fauna/home/breeder_list.dart';
import 'package:fauna/home/category.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/home/petLists.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/home_model.dart';
import 'package:fauna/models/main_search.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/generalizedObserver.dart';
import 'package:fauna/supportingClass/notificatonManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeClass extends KFDrawerContent {
  final Function callback, isBreederCall;

  // HomeClass({Key key}) : super(key: key);
  HomeClass({this.callback, this.isBreederCall});

  @override
  _HomeClassState createState() => _HomeClassState();
}

class _HomeClassState extends State<HomeClass> {
  List<MainSearchModel> _searchResult = [];
  HomeSearchBloc _searchBloc;
  TextEditingController controller = new TextEditingController();

  Widget appBarTitle = new Text(
    "Search Sample",
    style: new TextStyle(color: Colors.white),
  );

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  bool _IsSearching = false;

  String _searchText = "";

  final TextEditingController _searchQuery = new TextEditingController();

  var _selectedItem = 0;

  List<TopCategory> categories = [];

  List<Color> colorArray = [
    Color(0xFFFFF1DA),
    Color(0xFFFFE2CE),
    Color(0xFFFFD9E1),
    Color(0xFFD9F5FF),
    Color(0xFFFFEBB1),
    Color(0xFFF4FFC3)
  ];

  HomeBloc _bloc;
  List<FeaturedPost> _featuredPostList = [];
  List<TopCategories> _topCategories = [];
  List<TopRatedBreeder> _topRatedBreeder = [];
  List<Explore> _featuredBreeders = [];
  var isBreeder;
  bool _isLoading = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var dataLoad = false;
  var bodyParam;

  @override
  void dispose() {
    _bloc.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = HomeBloc();
    _searchBloc = HomeSearchBloc();
    getLatLong();
    _bloc.loginStream.listen(
      (event) {
        setState(
          () {
            switch (event.status) {
              case Status.LOADING:
                Dialogs.showLoadingDialog(context, _keyLoader);
                _isLoading = false;
                dataLoad = false;
                break;
              case Status.COMPLETED:
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();
                _isLoading = false;
                _featuredPostList = event.data.featuredPost;
                _topCategories = event.data.topCategories;
                _featuredBreeders = event.data.explore;
                _topRatedBreeder = event.data.topRatedBreeder;
                _topRatedBreeder = event.data.topRatedBreeder;
                isBreeder = event.data.isBreeder;
                breederCalling();
                StateProvider _stateProvider = StateProvider();
                var dict = {"counter": event.data.counter};
                _stateProvider.notify(ObserverState.UPDATECOUNTER, dict);
                dataLoad = true;
                break;
              case Status.ERROR:
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();
                _isLoading = false;
                dataLoad = true;
                _showAlert(context, event.message);
                break;
            }
          },
        );
      },
    );

    _searchBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            break;
          case Status.COMPLETED:
            _searchResult = event.data;
            break;
          case Status.ERROR:
            _showAlert(context, event.message);
            break;
        }
      });
    });
    PushNotificationsManager().initialise();
    // showSnackBar();
    super.initState();
  }

  showSnackBar() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('How was your experience with Last Breeder?'),
    //       action: SnackBarAction(
    //         label: 'Undo',
    //         onPressed: () {
    //           // Some code to undo the change.
    //         },
    //       ),
    //     ),
    //   ),
    // );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text(
            'How was your experience with Last Breeder?',
          ),
          message: const Text(
            '* * * * *',
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text(
                'Submit',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'cancel',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  getLatLong() async {
    if (await Permission.locationAlways.serviceStatus.isEnabled) {
      // Use location.
      print('get user location ----');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print('get user location $position');
      setState(() {
        bodyParam = {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };
      });
      _bloc.getHomeData(bodyParam);
    } else {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Can't get gurrent location"),
      //         content: const Text(
      //             'Please make sure you enable GPS and try again'),
      //         actions: <Widget>[
      //           FlatButton(
      //               child: Text('Ok'),
      //               onPressed: () {
      //                 final AndroidIntent intent = AndroidIntent(
      //                     action:
      //                     'android.settings.LOCATION_SOURCE_SETTINGS');
      //                 intent.launch();
      //                 Navigator.of(context, rootNavigator: true).pop();
      //               })
      //         ],
      //       );
      //     });
      _bloc.getHomeData({
        'latitude': '',
        'longitude': '',
      });
    }
    print('get user location $bodyParam');
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
        content: Text(
          str,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            color: Colors.pink,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // @override
  // loader() {
  //   // here any widget would do
  //   return AlertDialog(
  //     title: Text('Wait.. Loading data..'),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(78),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Color(0xffB1308A),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      children: [
                        addMenuButton(),
                        SizedBox(width: 5),
                        //  _buildSearchBox(),
                        addSearchContainer(),
                        SizedBox(width: 5),
                        addFilterButton()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              child: Stack(
                children: [
                  _isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                // Color(0xff9C27B0),
                                Color(0xffB52C82),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )
                      : _buildMainWidget(),
                  // Positioned(
                  //   top: 60,
                  //   left: 30,
                  //   child: Row(
                  //     children: [
                  //       addMenuButton(),
                  //       SizedBox(
                  //         width: 5,
                  //       ),
                  //       //  _buildSearchBox(),
                  //       addSearchContainer(),
                  //       SizedBox(
                  //         width: 5,
                  //       ),
                  //       addFilterButton()
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )));
  }

  addSearchContainer() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            border: new Border.all(
              color: Color(0xff9C27B0),
              width: 1.0,
            )),
        height: 40,
        width: _IsSearching
            ? MediaQuery.of(context).size.width - 140
            : MediaQuery.of(context).size.width - 100,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: _buildSearchBox(),
        ));
  }

  Widget searchList() {
    return _searchResult.length == 0
        ? Center(
            child: Text('No similar featured Pets Available'),
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(70, 92, 30, 20),
            child: ListView.builder(
                itemCount: _searchResult.length,
                padding: EdgeInsets.only(top: 15),
                itemBuilder: (context, position) {
                  return InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _searchResult[position].name,
                          style: TextStyle(
                              color: Color(0xFF595959),
                              fontFamily: "Montserrat",
                              fontSize: 15,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Divider(
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                    onTap: () {
                      print(_searchResult[position].id.toString());
                      FocusScope.of(context).requestFocus(FocusNode());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BreederslistClass(
                                  categoryName: _searchResult[position].name,
                                  showFilters: false,
                                  category:
                                      _searchResult[position].id.toString())));
                      // controller.clear();
                      // onSearchTextChanged('');
                      // removecancel();
                    },
                  );
                }));
  }

  _buildMainWidget() {
    return _IsSearching
        ? searchList()
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.50,
                        decoration: BoxDecoration(
                            color: Color(0xffB1308A),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            )),
                      ),
                      // Image.asset(
                      //   "assets/homeBg.webp",
                      //   width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height * 0.50,
                      //   fit: BoxFit.cover,
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 150, 20, 00),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Find your",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            space(),
                            Text(
                              "next pet with Fauna.",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            space(),
                            space(),
                            space(),
                            space(),
                            space(),
                            checkSizeFeaturePost(),
                          ],
                        ),
                      )
                    ],
                  ),
                  checkSizeBottomSpaceFeaturePost(),
                  space(),
                  space(),
                  space(),
                  space(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: addTopCategories()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addCategories(),
                  ),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addBorder(),
                  ),
                  space(),
                  space(),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addFeaturedBreeders(),
                  ),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addFeaturedBreedersList(),
                  ),
                  space(),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addBorder(),
                  ),
                  space(),
                  space(),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addtopBreeders(),
                  ),
                  space(),
                  space(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: addtopBreedersList(),
                  )
                ],
              ),
            ),
          );
  }

  space() {
    return SizedBox(height: 10);
  }

  addFeaturedPets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Featured Pets",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Montserrat",
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          child: Text(
            "Show All",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoriteClass(
                          fromHome: true,
                          fromTab: false,
                        )));
          },
        )
      ],
    );
  }

  addFeaturedBreeders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Explore",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Montserrat",
            fontSize: 18,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          child: Text(
            "Show All",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BreederList(isFeatured: true)));
          },
        )
      ],
    );
  }

  addtopBreeders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Top Rated Breeders",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Montserrat",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          child: Text(
            "Show All",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BreederList(isFeatured: false)));
          },
        )
      ],
    );
  }

  addTopCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Top Categories",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Montserrat",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  addCategories() {
    final _random = new Random();
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: _topCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  child: Column(
                    children: [
                      (_selectedItem == index)
                          ? UnicornOutlineButton(
                              strokeWidth: 1,
                              radius: 5,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryClass(
                                            _topCategories[index].id.toString(),
                                            _topCategories[index].name)));
                              },
                              child: Container(
                                  // color: colorArray[
                                  //     _random.nextInt(colorArray.length)],
                                  height: 100,
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CachedNetworkImage(
                                      imageUrl: _topCategories[index].picture,
                                      //errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  )

                                  //   color: ,
                                  ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: colorArray[
                                    _random.nextInt(colorArray.length)],
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
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CachedNetworkImage(
                                  imageUrl: _topCategories[index].picture,
                                  //errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              )

                              //   color: ,
                              ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(_topCategories[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                          ))
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedItem = index;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryClass(
                                _topCategories[index].id.toString(),
                                _topCategories[index].name)));
                  },
                ));
          }),
    );
  }

  // addCatList(_random, index) {
  //   return
  // }

  addBorder() {
    return Divider(
      color: Colors.red,
      height: 2,
    );
  }

  addFeaturedBreedersList() {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 250, maxHeight: 250),
        child: Container(
            //   constraints: BoxConstraints(
            //  minHeight: 250, minWidth: double.infinity, maxHeight: 250),
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: _featuredBreeders.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                              imageUrl: _featuredBreeders[index].filename,
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.70,
                              fit: BoxFit.cover),
                        ),
                        space(),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              _featuredBreeders[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        space(),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Row(children: [
                              Image.asset(
                                "assets/location.png",
                                width: 15,
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  _featuredBreeders[index].address != null
                                      ? _featuredBreeders[index].address
                                      : "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ])),
                        space(),
                      ],
                    ),
                  ),
                  onTap: () {
                    //  _featuredBreeders[index].id.toString()
                    FocusScope.of(context).requestFocus(FocusNode());

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetDetailClass(
                                  id: _featuredBreeders[index].id.toString(),
                                  fromBreeder: true,
                                  isPreview: false,
                                  post: null,
                                  images: null,
                                )));
                  },
                ));
          },
        )));
  }

  addtopBreedersList() {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 250, maxHeight: 250),
        child: Container(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: _topRatedBreeder.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                              imageUrl: _topRatedBreeder[index].profileImg,
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.70,
                              fit: BoxFit.cover),
                        ),
                        space(),
                        checkName(index),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              _topRatedBreeder[index].fullName.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        space(),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/location.png",
                                width: 15,
                                height: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  _topRatedBreeder[index].address != null
                                      ? _topRatedBreeder[index].address
                                      : "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        space(),
                      ],
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    print("_topRatedBreeder[index].id.toString() :-" +
                        _topRatedBreeder[index].id.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BreedersDetailpage(
                                breederid:
                                    _topRatedBreeder[index].id.toString())));
                  },
                ));
          },
        )));
  }

  addFeaturedPetsList() {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 250, maxHeight: 250),
        child: Container(
            //   constraints: BoxConstraints(
            //  minHeight: 250, minWidth: double.infinity, maxHeight: 250),
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: _featuredPostList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                              imageUrl: _featuredPostList[index].filename,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.70,
                              fit: BoxFit.cover),
                        ),
                        space(),
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 5),
                            child: Text(
                              _featuredPostList[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        space(),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 5),
                          child: Text(
                            _featuredPostList[index].categoryName,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Montserrat",
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        space(),
                      ],
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetDetailClass(
                                  id: _featuredPostList[index].id.toString(),
                                  fromBreeder: true,
                                  isPreview: false,
                                  post: null,
                                  images: null,
                                )));
                  },
                ));
          },
        )));
  }

  addMenuButton() {
    return InkWell(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 5.0, color: Colors.white),
          color: Colors.white,
        ),
        child: Center(
          child: Image.asset(
            "assets/menu.webp",
            width: 20,
            height: 20,
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        this.widget.callback();
      },
    );
  }

  void removecancel() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _IsSearching = false;
    });
  }

  addFilterButton() {
    return _IsSearching
        ? new IconButton(
            icon: new Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
              removecancel();
            })
        : Container();
  }

  Widget _buildSearchBox() {
    return new TextField(
      controller: controller,
      decoration: new InputDecoration(
        prefixIcon: _IsSearching
            ? null
            : new Icon(Icons.search, color: Color(0xff9C27B0)),
        hintText: 'Search',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Color(0xff9C27B0), //         color: Color(0xFF9C27B0),
          fontFamily: "Montserrat",
          // fontSize: 15,
          fontStyle: FontStyle.normal,
        ),
      ),
      onChanged: onSearchTextChanged,
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    _IsSearching = true;
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    var dict = {"search": text};
    _searchBloc.search(dict);
    setState(() {});
  }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    throw UnimplementedError();
  }

  checkName(index) {
    print("data111 :- " + _topRatedBreeder[index].fullName.toString());
    return SizedBox.shrink();
  }

  checkSizeFeaturePost() {
    return _featuredPostList.length > 0
        ? Column(
            children: [
              addFeaturedPets(),
              space(),
              space(),
              addFeaturedPetsList()
            ],
          )
        : dataLoad
            ? Text(
                "No featured post available at this time",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              )
            : SizedBox.shrink();
  }

  checkSizeBottomSpaceFeaturePost() {
    return _featuredPostList.length > 0
        ? Column(
            children: [
              space(),
              space(),
              space(),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: addBorder(),
              )
            ],
          )
        : SizedBox.shrink();
  }

  Future<void> breederCalling() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    print("isBreeder---  " + isBreeder.toString());
    print("token---  " + token.toString());
    var boolCheckBreeder = 0;
    if (isBreeder.toString() == "1") {
      boolCheckBreeder = 1;
    } else {
      boolCheckBreeder = 0;
    }

    setState(() {
      prefs.setInt(ISBREEDER, boolCheckBreeder);
      this.widget.isBreederCall();
    });
  }
}

class TopCategory {
  Color color;
  String name;

  TopCategory({this.color, this.name});
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
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
                    )
                  ]));
        });
  }
}
