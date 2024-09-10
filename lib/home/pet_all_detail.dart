import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/models/myposts.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PetDetailAllClass extends StatefulWidget {
  PetDetailAllClass({Key key, this.post}) : super(key: key);
  var post;

  @override
  _PetDetailAllClassState createState() => _PetDetailAllClassState();
}

class _PetDetailAllClassState extends State<PetDetailAllClass> {
  PostDetailBloc _postDetailBloc;
  int _current = 0;
  PostModelClass _post;
  String id = "";
  var _isLoading = false;
  FavBloc _favBloc;
  @override
  void initState() {
    super.initState();
    id = widget.post.toString();
    _postDetailBloc = PostDetailBloc();
    _favBloc = FavBloc();
    _postDetailBloc.getPostData(id);
    _postDetailBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _post = event.data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addBottomBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addSlider(_post.filename),
                  space(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(_post.filename.length)),
                  addRow(),
                  space(),
                  space(),
                  addTitle(),
                  space(),
                  addDescription(),
                  space(),
                  addProperties(),
                  addFeaturedPets(),
                  addpetsList()
                ],
              ),
            ),
    );
  }

  addBottomBar() {
    return Container(
        color: Colors.transparent,
        height: 80,
        child: Padding(
            padding: EdgeInsets.only(right: 0, left: 0),
            child: addConnectButton()
            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [addConnectButton()],
            // ),
            ));
  }

  addOfferButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 80,
      child: FlatButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        color: Colors.white,
        child: Text("Make an offer",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
      ),
    );
  }

  addConnectButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {},
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Connect with Breeder",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
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
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {},
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Send",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
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
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {},
        color: Colors.white,
        textColor: Colors.black,
        child: Text("90.00",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
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
                    child: Text("Make An Offer", style: kHeading)),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur sit adipiscing elit, sed do eiusmod",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          color: Color(0xFF595959),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal),
                    )),
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
                              bottomRight: Radius.circular(15)),
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
                              bottomRight: Radius.circular(15)),
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
                        )),
                  ],
                ),
                space(),
                // space(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [addPrice(), addSendButton()],
                  ),
                )
              ],
            ),
          );
        });
  }

  addTitle() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(
          "Description",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        ));
  }

  addDescription() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: new DescriptionTextWidget(text: _post.description));
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
    return Stack(children: [
      events.length != 0
          ? Column(children: [
              CarouselSlider.builder(
                itemCount: events.length,
                itemBuilder: (context, index, val) {
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
              Row(children: [
                Image.asset(
                  "assets/location.png",
                  color: Colors.white,
                  width: 15,
                  height: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(_post.address,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 14,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400))
              ])
            ],
          )),
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
      Positioned(
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
                onTap: () {},
              ),
              SizedBox(width: 20),
              isGuestLogin
                  ? Container()
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
                                  ? new AssetImage('assets/heart.webp')
                                  : new AssetImage(
                                      "assets/unselectedHeart.webp"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
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
            ],
          ))
    ]);
  }

  Widget _loadControllerImage(filename) {
    return InkWell(
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.darken,
          child: CachedNetworkImage(
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
          ),
        ),
        onTap: () {});
  }

  space() {
    return SizedBox(
      height: 10,
    );
  }

  addRow() {
    return Padding(
        padding: EdgeInsets.all(20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: CachedNetworkImage(
                    imageUrl: _post.breeder.profileImg,
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _post.breeder.firstName + " " + _post.breeder.lastName,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 17,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Owner",
                    style: kSubHeading,
                  )
                ],
              )
            ],
          ),
          Text(
            "\$ 35",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Color(0xFF9C27B0),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600),
          ),
        ]));
  }

  addProperties() {
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
                            bottomRight: Radius.circular(5)),
                      ),
                      height: 90,
                      width: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ));
              }),
        ));
  }

  addFeaturedPets() {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Pets",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Show All",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ));
  }

  addpetsList() {
    return Padding(
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
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.grey.withOpacity(0.2),
                        //       spreadRadius: 2,
                        //       blurRadius: 3,
                        //       offset: Offset(0, 1), // changes position of shadow
                        //     ),
                        //   ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _post.feturedPost[position].filename,
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          space(),
                          Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text(_post.feturedPost[position].name,
                                  style: kTextFeildStyle, maxLines: 1)),
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
                                  Expanded(child: addrating())
                                ],
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetDetailClass(
                                  _post.feturedPost[position].id.toString())));*/
                    },
                  ));
            }),
      ),
    );
  }

  addrating() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 18,
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
}
