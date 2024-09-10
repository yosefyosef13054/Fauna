import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/class/shimmerEffects/imageloadshimmer.dart';
import 'package:fauna/class/shimmerEffects/sizeImageShimmer.dart';
import 'package:fauna/home/breeder_detail.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/breederList_model.dart';
import 'package:fauna/models/explore.dart';
import 'package:fauna/networking/Response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class BreederList extends StatefulWidget {
  final bool isFeatured;

  BreederList({this.isFeatured});

  @override
  _BreederListState createState() => _BreederListState();
}

class _BreederListState extends State<BreederList> {
  BreederListBloc _bloc;
  ExploreBloc _explorebloc;
  bool _isLoading = true;
  List<FeaturedBreederModel> _posts = [];
  List<ExploreModelClass> _exploreposts = [];
  var bodyParam;

  @override
  void initState() {
    super.initState();
    _bloc = BreederListBloc();
    _explorebloc = ExploreBloc();
    getLatLong();
    if (widget.isFeatured) {
      _explorebloc.explorePosts(bodyParam ??
          {
            'latitude': '',
            'longitude': '',
          });
    } else {
      _bloc.getTopBreedersList();
    }

    _explorebloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _exploreposts = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            _showAlert(context, event.message);
            break;
        }
      });
    });

    _bloc.loginStream.listen((event) {
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
            _showAlert(context, event.message);
            break;
        }
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
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.isFeatured ? "Explore" : "Top Rated Breeders",
            style: TextStyle(
                color: Color(0xff080040),
                fontFamily: "Montserrat",
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(10),
                child: new GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  children: new List.generate(
                      widget.isFeatured ? _exploreposts.length : _posts.length,
                      (index) {
                    return new GridTile(
                        child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xffAEAEAE),
                              width: 1,
                            ),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        sizeImageShimmer(
                                            context,
                                            MediaQuery.of(context).size.width,
                                            MediaQuery.of(context).size.width /
                                                2 *
                                                0.60),
                                    imageUrl: widget.isFeatured
                                        ? _exploreposts[index].filename
                                        : _posts[index].profileImg ??
                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoIrOYja2QSdE0QTb3UDKI_ksIiIGEEY2ERw&usqp=CAU",
                                    height: MediaQuery.of(context).size.width /
                                        2 *
                                        0.60,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      print("Error Image :- " + url.toString());
                                    }),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                      widget.isFeatured
                                          ? _exploreposts[index].name.toString()
                                          : _posts[index].fullName.toString(),
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1)),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(children: [
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
                                    widget.isFeatured
                                        ? _exploreposts[index]
                                            .address
                                            .toString()
                                        : _posts[index].address.toString(),
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ]),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                            ],
                            // ),
                          )),
                      onTap: () {
                        if (widget.isFeatured) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PetDetailClass(
                                        id: _exploreposts[index].id.toString(),
                                        fromBreeder: false,
                                        isPreview: false,
                                        post: null,
                                        images: null,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BreedersDetailpage(
                                      breederid: _posts[index].id.toString())));
                        }
                      },
                    ));
                  }),
                ),
              ));
  }
}
