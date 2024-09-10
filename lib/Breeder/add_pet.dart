import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/class/imagePick.dart';
import 'package:fauna/class/progressShowBreeder.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_pet_detail.dart';

class AddPetClass extends StatefulWidget {
// AddPetClass({Key key}) : super(key: key);
  PostModelClass dict;
  final bool fromDrafts;
  final String id;

  AddPetClass({this.dict, this.fromDrafts, this.id});

  @override
  _AddPetClassState createState() => _AddPetClassState();
}

class _AddPetClassState extends State<AddPetClass> {
  File _image;
  final picker = ImagePicker();
  List<File> images = List<File>();

  bool isChanged1 = false;
  bool isChanged3 = false;
  bool isChanged4 = false;
  bool isChanged2 = false;
  var changePositionImage = 100;
  File image1;
  File image2;
  File image3;
  File image4;

  List<Filename> imagefilename = List<Filename>();
  List<File> compressedImages = List<File>();
  List decodedList = [];
  List<Map> decodedListSubscriber = List();
  var loading = true;

  var minimunPrice;
  var maximumPrice;
  Map priceSet = Map();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  String _lat = "";
  String _long = "";
  PostDetailBloc _postDetailBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    userLocation();
    listFetch();

    if (widget.fromDrafts) {
      if (widget.id != "") {
        _postDetailBloc = PostDetailBloc();
        _postDetailBloc.getPostData(widget.id);
        _postDetailBloc.loginStream.listen((event) {
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
                print(event.data.price);
                widget.dict = PostModelClass(price: event.data.price);
                nameController.text = event.data.name;

                if (event.data.price != null) {
                  widget.dict.price = event.data.price;
                  widget.dict.filter = event.data.filter;
                } else {
                  widget.dict.price = 0;
                }
                if (event.data.mainCategory != null) {
                  widget.dict.mainCategory = event.data.mainCategory;
                }
                if (event.data.subCategory != null) {
                  widget.dict.subCategory = event.data.subCategory;
                }
                if (event.data.postType != null) {
                  widget.dict.postType = event.data.postType;
                  if (event.data.postType == 2) {
                    widget.dict.femaleCount = event.data.femaleCount;
                    widget.dict.maleCount = event.data.maleCount;
                    widget.dict.totalCount = event.data.totalCount;
                  } else {}
                }

                if (event.data.address != "") {
                  locationController.text = event.data.address.toString();
                  _lat = event.data.latitude.toString();
                  _long = event.data.longitude.toString();
                  widget.dict.address = event.data.address.toString();
                  widget.dict.latitude = event.data.latitude;
                  widget.dict.longitude = event.data.address;
                }
                if (event.data.description != "") {
                  descriptionController.text =
                      event.data.description.toString();
                  widget.dict.description = event.data.description.toString();
                }
                if (event.data.filename.length > 0) {
                  widget.dict.id = event.data.id;
                  widget.dict.name = event.data.name;
                  widget.dict.filename = event.data.filename;
                  print(">>>>>>>>------   " + event.data.filename.toString());
                  imagefilename = event.data.filename;
                }

                break;
              case Status.ERROR:
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();
                _isLoading = false;
                break;
            }
          });
        });
      }
    } else {
      if (widget.dict != null) {
        print(widget.dict.filter);
        nameController.text = widget.dict.name;
        locationController.text = widget.dict.address;
        descriptionController.text = widget.dict.description;
        _lat = widget.dict.latitude.toString();
        _long = widget.dict.longitude.toString();

        print(">>>>>>>>------   " + widget.dict.filename.toString());
        print(widget.dict.id);
        imagefilename = widget.dict.filename;
        for (int i = 0; i < widget.dict.filename.length; i++) {
          print(widget.dict.filename[i].id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // actions: [
            //   widget.fromDrafts
            //       ? IconButton(
            //           icon: Icon(Icons.drafts, color: Color(0xff080040)),
            //           onPressed: () {
            //             saveAsDrafts();
            //           },
            //         )
            //       : SizedBox.shrink()
            // ],
            title: Text(
              widget.dict != null
                  ? widget.fromDrafts
                      ? "Drafts"
                      : "Edit Details"
                  : "Add Details",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
                      child: progressShow(true, false, false),
                    )),
                    Text("Add Photos",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    //addContainer(),
                    imagePickFiled(context),
                    SizedBox(height: 20),
                    Text(
                        widget.dict != null
                            ? "Edit Pet Description "
                            : "Add Pet Description",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    addname(),
                    SizedBox(height: 10),
                    selectLocation(),
                    SizedBox(height: 10),
                    addDescrptn(),
                    SizedBox(height: 20),
                    addNextButton()
                  ],
                )),
          ),
        ));
  }

  addContainer() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.20,
        color: Colors.pink);
  }

  addname() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Pet Name';
                }
                return null;
              },
              controller: nameController,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Enter Pet Name'))),
      onPressed: () {},
    );
  }

  selectLocation() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Location';
                }
                return null;
              },
              controller: locationController,
              enabled: false,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Select or Enter Location'))),
      onPressed: () {
        pickerAddress(context);
      },
    );
  }

  addDescrptn() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          //  height: 50,
          child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Description';
                }
                return null;
              },
              controller: descriptionController,
              style: kTextFeildStyle,
              maxLines: 8,
              minLines: 8,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Add Description'))),
      onPressed: () {},
    );
  }

  pickerAddress(context) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE");
    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyC8aGCWtPd2ko30C_gMAQwDNaDtkIsqWPE",
        //apiHeaders: await GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        locationController.text = p.description;
        _lat = lat.toString();
        _long = lng.toString();
      });
      //scaffold.showSnackBar(
      //SnackBar(content: Text("${p.description} - $lat/$lng")),
      //);
    }
  }

  addNextButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 50,
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
          if (widget.dict != null) {
            if (locationController.text == "") {
              showMessage("Please select location");
              return;
            } else if (nameController.text == "") {
              showMessage("Please enter name");
              return;
            } else if (descriptionController.text == "") {
              showMessage("Please enter description.");
              return;
            } else {
              navigateToNextPage();
            }
          } else {
            if (images.length < 1) {
              showMessage("Please select image");
              return;
            }
            if (nameController.text == "") {
              showMessage("Please enter name");
              return;
            }
            if (locationController.text == "") {
              showMessage("Please select location");
              return;
            }
            if (descriptionController.text == "") {
              showMessage("Please enter description.");
              return;
            }
            navigateToNextPage();
          }
        },
        // color: Color(0xFF9C27B0),
        // textColor: Colors.white,
        child: Text("Next", style: kButtontyle),
      ),
    );
  }

  imagePickFiled(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Stack(
          children: <Widget>[selectedImagesShow()],
        ));
  }

  selectedImagesShow() {
    var size = MediaQuery.of(context).size.width.toInt();
    var imageFirst;
    var imageSecond;
    var imageThird;
    var imageFourth;
    if (images.length > 0) {
      imageFirst = images[0];
    }
    if (images.length > 1) {
      imageSecond = images[1];
    }
    if (images.length > 2) {
      imageThird = images[2];
    }
    if (images.length > 3) {
      imageFourth = images[3];
    }
    return Container(
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 8.0),
                child: widget.dict == null
                    ? imageFirst == null
                        ? UnicornOutlineButton(
                            strokeWidth: 1,
                            radius: 12,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                            child: SizedBox(
                                height: 400,
                                child: Align(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.image,
                                          size: 40.0,
                                          color: Color(0xFF9C27B0),
                                        ),
                                        onPressed: () {
                                          imagePickData(context);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "Add Photo",
                                          style: TextStyle(
                                              color: Color(0xFF9C27B0),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                )),
                            onPressed: () {
                              imagePickData(context);
                            },
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    images[0],
                                    width: MediaQuery.of(context).size.width,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  )),
                              Align(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (mounted)
                                      setState(() {
                                        changePositionImage = 0;
                                      });
                                    imagePickData(context);
                                  },
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          )
                    : isChanged1
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  image1,
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Align(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    imagePickData(context, id: 1);
                                  },
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: imagefilename[0].filename,
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Align(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    print(
                                        "widget.dict.filename[0].id.toString() :---" +
                                            widget.dict.filename[0].id
                                                .toString());
                                    deleteImage(
                                        widget.dict.filename[0].id.toString(),
                                        1);
                                  },
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          ),
              )),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2.0, 4.0, 8.0, 4.0),
                    child: widget.dict == null
                        ? imageSecond == null
                            ? UnicornOutlineButton(
                                strokeWidth: 1,
                                radius: 12,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF3D00),
                                    Color(0xFF9C27B0)
                                  ],
                                  end: const Alignment(0.0, -1),
                                  begin: const Alignment(0.0, 0.6),
                                ),
                                child: SizedBox(
                                    height: 100,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        color: Color(0xFF9C27B0),
                                      ),
                                      onPressed: () {
                                        imagePickData(context);
                                      },
                                    )),
                                onPressed: () {
                                  imagePickData(context);
                                },
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        images[1],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )),
                                  Align(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (mounted)
                                          setState(() {
                                            changePositionImage = 1;
                                          });
                                        imagePickData(context);
                                      },
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                ],
                              )
                        : widget.dict.filename.length >= 2
                            ? isChanged2
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 2);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.dict.filename[1].filename,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            deleteImage(
                                                widget.dict.filename[1].id
                                                    .toString(),
                                                2);
                                            //loadEditAssets(2);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                            : isChanged2
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 2);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : UnicornOutlineButton(
                                    strokeWidth: 1,
                                    radius: 12,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFF3D00),
                                        Color(0xFF9C27B0)
                                      ],
                                      end: const Alignment(0.0, -1),
                                      begin: const Alignment(0.0, 0.6),
                                    ),
                                    child: SizedBox(
                                        height: 100,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.image,
                                            color: Color(0xFF9C27B0),
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 2);
                                          },
                                        )),
                                    onPressed: () {
                                      imagePickData(context, id: 2);
                                    },
                                  ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                    child: widget.dict == null
                        ? imageThird == null
                            ? UnicornOutlineButton(
                                strokeWidth: 1,
                                radius: 12,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF3D00),
                                    Color(0xFF9C27B0)
                                  ],
                                  end: const Alignment(0.0, -1),
                                  begin: const Alignment(0.0, 0.6),
                                ),
                                child: SizedBox(
                                    height: 100,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        color: Color(0xFF9C27B0),
                                      ),
                                      onPressed: () {
                                        imagePickData(context);
                                      },
                                    )),
                                onPressed: () {
                                  imagePickData(context);
                                },
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      images[2],
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (mounted)
                                          setState(() {
                                            changePositionImage = 2;
                                          });
                                        imagePickData(context);
                                      },
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                ],
                              )
                        : widget.dict.filename.length >= 3
                            ? isChanged3
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 3);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.dict.filename[2].filename,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              deleteImage(
                                                  widget.dict.filename[2].id
                                                      .toString(),
                                                  3);
                                              //loadEditAssets(3);
                                            }),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                            : isChanged3
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 3);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : UnicornOutlineButton(
                                    strokeWidth: 1,
                                    radius: 12,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFF3D00),
                                        Color(0xFF9C27B0)
                                      ],
                                      end: const Alignment(0.0, -1),
                                      begin: const Alignment(0.0, 0.6),
                                    ),
                                    child: SizedBox(
                                        height: 100,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.image,
                                            color: Color(0xFF9C27B0),
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 3);
                                          },
                                        )),
                                    onPressed: () {
                                      imagePickData(context, id: 3);
                                    },
                                  ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 2.0, 4.0),
                    child: widget.dict == null
                        ? imageFourth == null
                            ? UnicornOutlineButton(
                                strokeWidth: 1,
                                radius: 12,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF3D00),
                                    Color(0xFF9C27B0)
                                  ],
                                  end: const Alignment(0.0, -1),
                                  begin: const Alignment(0.0, 0.6),
                                ),
                                child: SizedBox(
                                    height: 100,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        color: Color(0xFF9C27B0),
                                      ),
                                      onPressed: () {
                                        imagePickData(context);
                                      },
                                    )),
                                onPressed: () {
                                  imagePickData(context);
                                },
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      images[3],
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (mounted)
                                          setState(() {
                                            changePositionImage = 3;
                                          });
                                        imagePickData(context);
                                      },
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                ],
                              )
                        : widget.dict.filename.length >= 4
                            ? isChanged4
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 4);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.dict.filename[3].filename,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            deleteImage(
                                                widget.dict.filename[3].id
                                                    .toString(),
                                                4);
                                            //loadEditAssets(4);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                            : isChanged4
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Align(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 4);
                                          },
                                        ),
                                        alignment: Alignment.topRight,
                                      ),
                                    ],
                                  )
                                : UnicornOutlineButton(
                                    strokeWidth: 1,
                                    radius: 12,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFF3D00),
                                        Color(0xFF9C27B0)
                                      ],
                                      end: const Alignment(0.0, -1),
                                      begin: const Alignment(0.0, 0.6),
                                    ),
                                    child: SizedBox(
                                        height: 100,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.image,
                                            color: Color(0xFF9C27B0),
                                          ),
                                          onPressed: () {
                                            imagePickData(context, id: 4);
                                          },
                                        )),
                                    onPressed: () {
                                      imagePickData(context, id: 4);
                                    },
                                  ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future testCompressAndGetFile(String file, String targetPath) async {
    String fileName = file.split('.').last;
    print(fileName);
    if (fileName == "HEIC") {
      final result = await FlutterImageCompress.compressAndGetFile(
        file,
        targetPath,
        quality: 50,
        minWidth: 400,
        format: CompressFormat.heic,
        minHeight: 400,
      );
      compressedImages.add(result);
    } else {
      final result = await FlutterImageCompress.compressAndGetFile(
        file,
        targetPath,
        quality: 50,
        minWidth: 400,
        minHeight: 400,
      );
      compressedImages.add(result);
    }

    print("compressedImages" + compressedImages.toString());
    // }
  }

  void imagePickData(BuildContext context, {id}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text('Choose Action')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: FlatButton(
                            child: Text("Camera"),
                            onPressed: () async {
                              Navigator.pop(context);
                              File image = await imagePick(context, "Camera");
                              if (id == null) {
                                setState(() {
                                  if (image != null) {
                                    if (changePositionImage != 100) {
                                      images.removeAt(changePositionImage);
                                      images.insert(changePositionImage, image);
                                    } else {
                                      images.add(image);
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  if (id == 1) {
                                    if (image != null) {
                                      isChanged1 = true;
                                      image1 = image;
                                    }
                                  }
                                  if (id == 2) {
                                    if (image != null) {
                                      isChanged2 = true;
                                      image2 = image;
                                    }
                                  }
                                  if (id == 3) {
                                    if (image != null) {
                                      isChanged3 = true;
                                      image3 = image;
                                    }
                                  }
                                  if (id == 4) {
                                    if (image != null) {
                                      isChanged4 = true;
                                      image4 = image;
                                    }
                                  }
                                });
                              }
                              // imageConvert(image,id);
                            },
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.blue,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blue,
                          ),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: FlatButton(
                            child: Text("Gallery"),
                            onPressed: () async {
                              Navigator.pop(context);
                              File image = await imagePick(context, "Gallery");
                              if (id == null) {
                                setState(() {
                                  if (image != null) {
                                    if (changePositionImage != 100) {
                                      images.removeAt(changePositionImage);
                                      images.insert(changePositionImage, image);
                                    } else {
                                      images.add(image);
                                    }
                                  }
                                });
                              } else {
                                setState(() {
                                  if (id == 1) {
                                    if (image != null) {
                                      isChanged1 = true;
                                      image1 = image;
                                    }
                                  }
                                  if (id == 2) {
                                    if (image != null) {
                                      isChanged2 = true;
                                      image2 = image;
                                    }
                                  }
                                  if (id == 3) {
                                    if (image != null) {
                                      isChanged3 = true;
                                      image3 = image;
                                    }
                                  }
                                  if (id == 4) {
                                    if (image != null) {
                                      isChanged4 = true;
                                      image4 = image;
                                    }
                                  }
                                });
                              }
                            },
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.blue,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blue,
                          ),
                        )
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: new SizedBox(
                      width: double.infinity,
                      // height: double.infinity,
                      child: new OutlineButton(
                          borderSide: BorderSide(color: Color(0xff9C27B0)),
                          child: new Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0))),
                    ),
                  ),
                ],
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)));
        });
  }

  Future<void> loadEditAssets(id, {var multiImagePick}) async {
    compressedImages = [];
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    /*try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Fauna ",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }*/
    if (!mounted) return;
    if (resultList.length > 0) Dialogs.showLoadingDialog(context, _keyLoader);
    print("resultList :-" + resultList.toString());
    print("resultList length :-" + resultList.length.toString());
    resultList.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        String fileName = tempFile.path.split('.').last;
        print(fileName);
        if (fileName == "HEIC") {
          final dir = await path_provider.getTemporaryDirectory();
          var img = imageAsset.name.replaceAll(new RegExp(r"\s+"), "");
          final targetPath = dir.absolute.path + "/${img.toString()}";
          print(targetPath);
          final result = await FlutterImageCompress.compressAndGetFile(
              tempFile.absolute.path, targetPath,
              quality: 55, minWidth: 500, format: CompressFormat.heic);
          compressedImages.add(result);
          if (widget.fromDrafts) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          } else {
            addImage();
          }
        } else {
          final dir = await path_provider.getTemporaryDirectory();
          var img = imageAsset.name.replaceAll(new RegExp(r"\s+"), "");
          final targetPath = dir.absolute.path + "/${img.toString()}";
          print(targetPath);
          final result = await FlutterImageCompress.compressAndGetFile(
            tempFile.absolute.path,
            targetPath,
            quality: 55,
            minWidth: 500,
            minHeight: 500,
          );
          compressedImages.add(result);
          if (widget.fromDrafts) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          } else {
            addImage();
          }
        }
      }
    });
/*    print(compressedImages);
    setState(() {
      try {
        if (id == 1) {
          image1 = resultList[0];
          isChanged1 = true;
        }
        if (id == 2) {
          image2 = resultList[0];
          isChanged2 = true;
        }
        if (id == 3) {
          image3 = resultList[0];
          isChanged3 = true;
        }
        if (id == 4) {
          image4 = resultList[0];
          isChanged4 = true;
        }
      } catch (e) {}
      // _error = error;
    });*/
  }

  Future<void> loadAssets({var multiImagePick}) async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      /*resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Fauna ",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );*/
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    resultList.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        String fileName = tempFile.path.split('.').last;
        print(fileName);
        final dir = await path_provider.getTemporaryDirectory();
        var img = imageAsset.name.replaceAll(new RegExp(r"\s+"), "");
        final targetPath = dir.absolute.path + "/${img.toString()}";
        print(targetPath);
        testCompressAndGetFile(tempFile.absolute.path, targetPath);
        //  }
      }
    });
    print("resultList :- " + resultList.toString());

    setState(() {
      // _error = error;
    });
  }

  uplaodImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + ADD_POSTIMG);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    if (Platform.isIOS) {
      for (int i = 0; i < images.length; i++) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(images[i].openRead()));
        var length = await images[i].length();
        var multipartFile_identity_front = new http.MultipartFile(
            'file[]', stream, length,
            filename: path.basename(images[i].path));
        request.files.add(multipartFile_identity_front);
      }
    } else {
      for (int i = 0; i < images.length; i++) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(images[i].openRead()));
        var length = await images[i].length();
        var multipartFile_identity_front = new http.MultipartFile(
            'file[]', stream, length,
            filename: path.basename(images[i].path));
        request.files.add(multipartFile_identity_front);
      }
    }
    request.fields['postId'] = widget.dict.id.toString();
  }

  Future<void> listFetch() async {
    ApiProvider _apiProvider = ApiProvider();
    List sdecoded = jsonDecode(await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + FIELDS, SECRETKEY));
    Map sdecoded2 = jsonDecode(await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + POSTFIELDS, SECRETKEY));
    List<Map> decodedListPostSubscriber = List();
    List category = sdecoded2['option'];
    print(" :-" + category.toString());
    for (int i = 0; i < category.length; i++) {
      decodedListPostSubscriber.add({
        "id": category[i]['id'].toString(),
        "name": category[i]['name'],
      });
    }

    setState(() {
      for (int i = 0; i < sdecoded.length; i++) {
        if (sdecoded[i]["name"] == "Location") {
          sdecoded.remove(sdecoded[i]);
        }
      }
      for (int i = 0; i < sdecoded.length; i++) {
        if (sdecoded[i]["name"] == "Price") {
          var price = sdecoded[i];
          setPrice(price);
          print("Price--" + sdecoded[i].toString());
          sdecoded.remove(sdecoded[i]);
          // minimunPrice=
        }
      }
      decodedList = sdecoded;
      decodedListSubscriber = decodedListPostSubscriber;
      loading = false;
    });
    print("decoded ~~~~~~~~~~~~~~~~~ " + decodedList.toString());
  }

  Future<void> navigateToNextPage() async {
    if (widget.dict != null) {
      if (loading) {
        showMessage("Please wait a min");
      } else {
        voiddataEedit();
      }
    } else {
      if (loading) {
        showMessage("Please wait a min");
      } else {
        dataAdd();
      }
    }
  }

  voiddataEedit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri;
    if (widget.fromDrafts) {
      uri = Uri.parse(ApiProvider.baseUrl + ADDPOST);
    } else {
      uri = Uri.parse(ApiProvider.baseUrl + EDIT_POST);
    }

    Map<String, String> headers = {"Authorization": "Bearer " + token};

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    for (int i = 0; i < compressedImages.length; i++) {
      final String _fileName = compressedImages[i].path;
      Uint8List data = (await rootBundle.load(compressedImages[i].path))
          .buffer
          .asUint8List();
      List<int> _imageData = data.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes('file[]', _imageData, filename: _fileName),
      );
    }

    request.fields['postId'] = widget.dict.id.toString();
    request.fields['name'] = nameController.text;
    request.fields['address'] = locationController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['latitude'] = _lat;
    request.fields['longitude'] = _long;
    widget.dict.type = "1";

    if (widget.fromDrafts) {
      if (widget.dict.latitude == null) {
        widget.dict.latitude = _lat;
        widget.dict.longitude = _long;
        widget.dict.address = locationController.text;
      }
      if (widget.dict.description == null) {
        widget.dict.description = descriptionController.text;
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BeederPostCreate(
                  dict: widget.dict,
                  decoded: decodedList,
                  decodedListSubscriber: decodedListSubscriber,
                  request: request,
                  images: images,
                  fromDrafts: widget.fromDrafts,
                  priceMap: priceSet,
                )));
  }

  void dataAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + ADDPOST);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    if (Platform.isIOS) {
      for (int i = 0; i < images.length; i++) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(images[i].openRead()));
        var length = await images[i].length();
        var multipartFile_identity_front = new http.MultipartFile(
            'file[]', stream, length,
            filename: path.basename(images[i].path));
        request.files.add(multipartFile_identity_front);
      }
    } else {
      for (int i = 0; i < images.length; i++) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(images[i].openRead()));
        var length = await images[i].length();
        var multipartFile_identity_front = new http.MultipartFile(
            'file[]', stream, length,
            filename: path.basename(images[i].path));
        request.files.add(multipartFile_identity_front);
      }
    }

    request.fields['name'] = nameController.text;
    request.fields['address'] = locationController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['latitude'] = _lat;
    request.fields['longitude'] = _long;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BeederPostCreate(
                  dict: null,
                  decoded: decodedList,
                  decodedListSubscriber: decodedListSubscriber,
                  request: request,
                  images: images,
                  fromDrafts: widget.fromDrafts,
                  priceMap: priceSet,
                )));
  }

  void deleteImage(imageid, id) async {
    print(" widget.dict.id.toString(); -  " + widget.dict.id.toString());
    print(" widget.imageId.toString(); -  " + imageid.toString());

    Dialogs.showLoadingDialog(context, _keyLoader);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + DELETE_POSTIMG);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['postId'] = widget.dict.id.toString();
    request.fields['imageId'] = imageid.toString();
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        // showMessage("Post Deleted successfully".toString());
        imagePickData(context, id: id);
      } else {
        showMessage(error.toString());
      }
    });
  }

  void addImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + ADD_POSTIMG);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['postId'] = widget.dict.id.toString();

    for (int i = 0; i < compressedImages.length; i++) {
      final String _fileName = compressedImages[i].path;
      Uint8List data = (await rootBundle.load(compressedImages[i].path))
          .buffer
          .asUint8List();
      List<int> _imageData = data.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes('file[]', _imageData, filename: _fileName),
      );
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Map data = jsonDecode(await value);
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        showMessage("Post added successfully".toString());
      } else {
        showMessage(error.toString());
      }
    });
  }

  void saveAsDrafts() async {
    if (nameController.text == "") {
      showMessage("Please enter name");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + SAVEDRAFTPOST);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    if (Platform.isIOS) {
      for (int i = 0; i < images.length; i++) {
        final String _fileName = images[i].path;
        Uint8List data =
            (await rootBundle.load(images[i].path)).buffer.asUint8List();
        List<int> _imageData = data.buffer.asUint8List();
        request.files.add(
          http.MultipartFile.fromBytes('file[]', _imageData,
              filename: _fileName),
        );
      }
    } else {
      for (int i = 0; i < images.length; i++) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(images[i].openRead()));
        var length = await images[i].length();
        var multipartFile_identity_front = new http.MultipartFile(
            'file[]', stream, length,
            filename: path.basename(images[i].path));
        request.files.add(multipartFile_identity_front);
      }
    }

    if (widget.fromDrafts) {
      request.fields['post_id'] = widget.id.toString();
    } else {
      request.fields['post_id'] = "0";
    }
    request.fields['name'] = nameController.text;

    if (descriptionController.text != null ||
        descriptionController.text != "") {
      request.fields['description'] = descriptionController.text;
    }

    if (locationController.text != null || locationController.text != "") {
      request.fields['address'] = locationController.text;
      request.fields['latitude'] = _lat;
      request.fields['longitude'] = _long;
    }

    Dialogs.showLoadingDialog(context, _keyLoader);
    // showMessage("Please wait");
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      var data = jsonDecode(await value);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print("data-------------" + data.toString());
      var error = data['message'];
      if (response.statusCode == 200) {
        print(response.statusCode);
        showMessage("Post saved  as drafts successfully".toString());
        Navigator.pop(context, "load");
      } else {
        showMessage(error.toString());
      }
    });
  }

  void setPrice(sdecoded) {
    if (sdecoded["option"] != null) {
      if (sdecoded["option"][0] != null) {
        setIndexPrice(sdecoded["option"][0]);
      }
      if (sdecoded["option"][1] != null) {
        setIndexPrice(sdecoded["option"][1]);
      }
      if (sdecoded["option"][2] != null) {
        setIndexPrice(sdecoded["option"][0]);
      }
    }
  }

  void setIndexPrice(sdecoded) {
    print("sdecoded Price" + sdecoded.toString());

    if (mounted)
      setState(() {
        if (sdecoded['key_name'] == "minimum") {
          minimunPrice = sdecoded['value'];
          priceSet.addAll({
            'minimunPrice': double.parse(minimunPrice.toString()),
          });
        } else if (sdecoded['key_name'] == "maximum") {
          maximumPrice = sdecoded['value'];
          priceSet.addAll({
            'maximumPrice': double.parse(maximumPrice.toString()),
          });
        } else {}
      });
  }

  Future<void> userLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = prefs.getString(ADDRESS);
    var latitude = prefs.getString(LATITUDE);
    var longitude = prefs.getString(LONGITUDE);
    if (mounted) if (address != "null") {
      setState(() {
        locationController.text = address;
        _lat = latitude;
        _long = longitude;
      });
    }
  }

  void imageConvert(File image, id) {}
}
