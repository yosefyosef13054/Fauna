import 'dart:convert';
import 'dart:typed_data';

import 'package:fauna/class/progressShowBreeder.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/post_model.dart';
import 'package:fauna/networking/ApiProvider.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/paymentStripe/subscription.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeederPostCreate extends StatefulWidget {
  BeederPostCreate(
      {Key key,
      this.dict,
      this.decoded,
      this.decodedListSubscriber,
      this.request,
      this.images,
      this.fromDrafts,
      this.priceMap})
      : super(key: key);

  List decoded = [];
  List<Map> decodedListSubscriber;
  List images = [];
  List<Asset> imagesAll = List<Asset>();
  var request;
  bool fromDrafts;
  var priceMap;
  PostModelClass dict;

  @override
  State<StatefulWidget> createState() {
    return ListViewDemoState();
  }
}

enum SingingCharacter { individual, generic }

class ListViewDemoState extends State<BeederPostCreate> {
  SingingCharacter _character = SingingCharacter.individual;

  var _value = 0.0;
  var CategorySelected = false;
  var decodeSUbcategory;
  String category_hint = "category";
  Map _valueData;
  var categoryId = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List editArr = [];
  var _subCat;
  List<Filter> filter = [];
  String _username = "";
  String _profile = "";
  var request = new http.MultipartRequest(
      "POST", Uri.parse(ApiProvider.baseUrl + SAVEDRAFTPOST));

  TextEditingController priceController = TextEditingController();

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(USERNAME);
      _profile = prefs.getString(USERPROFILE);
    });
  }

  @override
  void initState() {
    super.initState();
    for (var val in widget.decoded) {
      val["isHide"] = false;
    }
    getUser();
    if (widget.dict != null) {
      if (widget.dict.postType.toString() == "2") {
        for (var val in widget.decoded) {
          if (val["key_name"] == "gender") {
            val["isHide"] = true;
          }
        }
        _character = SingingCharacter.generic;
        femalevalue = widget.dict.femaleCount;
        malevalue = widget.dict.maleCount;
      } else {
        _character = SingingCharacter.individual;
      }

      for (var val in widget.decodedListSubscriber) {
        if (val["id"] == widget.dict.mainCategory.toString()) {
          setState(() {
            _valueData = val;
          });
          widget.request.fields["category"] = val["id"];
          request.fields["category"] = val["id"];
          listFetch(val["id"]);
          break;
        }
      }

      setState(() {
        // _value = widget.dict.price;
        // print("_value :- " + _value.toString());
        priceController.text = widget.dict.price.toString();
      });
    } else {
      print("not from edit");
    }
    priceSet(widget.decoded);
    /*listFetch();*/
    if (widget.dict != null) {
      for (var val in widget.decoded) {
        // var index = widget.decoded.indexOf(val);
        val["isFilterChnaged"] = false;

        if (widget.dict.filter != null) {
          for (var value in widget.dict.filter) {
            if (val["key_name"] == value.id) {
              for (var optn in val["option"]) {
                if (optn["name"] == value.value) {
                  editArr.add(value);
                  widget.request.fields[val["key_name"]] = value.value;
                  request.fields[val["key_name"]] = value.value;
                  break;
                }
              }
              if (!editArr.contains(value)) {
                editArr.add(value);
              }
            } else {}
          }
        }
      }
    }
  }

  bool isCategoryChnaged = false;
  bool isFilterChnaged = false;
  bool rememberMe = false;
  var malevalue = 0;
  var femalevalue = 0;

  selectMaleGenric() {
    return UnicornOutlineButton(
        onPressed: null,
        strokeWidth: 1,
        radius: 24,
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: 60,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Male",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(children: [
                      InkWell(
                        child: Text(
                          "+",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            malevalue += 1;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        malevalue.toString(),
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        child: Text(
                          "-",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            if (malevalue != 0) {
                              malevalue -= 1;
                            }
                          });
                        },
                      ),
                    ])
                  ],
                ))));
  }

  selectFemaleGenric() {
    return UnicornOutlineButton(
        onPressed: null,
        strokeWidth: 1,
        radius: 24,
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: 60,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Female",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(children: [
                      InkWell(
                        child: Text(
                          "+",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            femalevalue += 1;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        femalevalue.toString(),
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        child: Text(
                          "-",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        onTap: () {
                          if (femalevalue != 0) {
                            setState(() {
                              femalevalue -= 1;
                            });
                          }
                        },
                      ),
                    ])
                  ],
                ))));
  }

  selectMultiple() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Radio<SingingCharacter>(
                activeColor: Colors.pink,
                value: SingingCharacter.individual,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    for (var val in widget.decoded) {
                      if (val["key_name"] == "gender") {
                        val["isHide"] = false;
                      }
                    }
                    _character = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Individual",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Radio<SingingCharacter>(
                activeColor: Colors.pink,
                value: SingingCharacter.generic,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    for (var val in widget.decoded) {
                      if (val["key_name"] == "gender") {
                        val["isHide"] = true;
                      }
                    }
                    _character = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Litter",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              widget.fromDrafts
                  ? IconButton(
                      icon: Icon(Icons.drafts, color: Color(0xff080040)),
                      onPressed: () {
                        saveAsDrafts();
                      },
                    )
                  : Container()
            ],
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
            centerTitle: true,
          ),
          body: new Container(
              child: new SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: progressShow(true, true, false),
                  ),
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Text("Add Pet Information",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                    child: selectMultiple()),
                _character == SingingCharacter.generic
                    ? Container(
                        height: 70,
                        child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: selectMaleGenric()))
                    : Container(),
                _character == SingingCharacter.generic
                    ? Container(
                        height: 70,
                        child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: selectFemaleGenric()))
                    : Container(),
                Container(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: UnicornOutlineButton(
                        strokeWidth: 1,
                        radius: 24,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                          end: const Alignment(0.0, -1),
                          begin: const Alignment(0.0, 0.6),
                        ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 70,
                            child: Padding(
                              child: new DropdownButtonHideUnderline(
                                child: DropdownButton<Map>(
                                  items: widget.decodedListSubscriber
                                      .map((Map map) {
                                    return new DropdownMenuItem<Map>(
                                      value: map,
                                      child: new Text(
                                        map["name"],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Map value) {
                                    setState(() {
                                      _valueData = value;
                                      print("valueCheck :" + value.toString());
                                      updateCategory(value);
                                    });
                                  },
                                  hint: Text(category_hint,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  value: _valueData,
                                ),
                              ),
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            )),
                        onPressed: () {},
                      ),
                    )),
                CategorySelected
                    ? Container(
                        height: 70,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: UnicornOutlineButton(
                            strokeWidth: 1,
                            radius: 24,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                            ),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                height: 70,
                                child: Padding(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      iconEnabledColor: Color(0xFF9C27B0),
                                      items: _dropDownItem(
                                          decodeSUbcategory['name'],
                                          decodeSUbcategory['option']),
                                      onChanged: (value) {
                                        isCategoryChnaged = true;
                                        if (value
                                            .toString()
                                            .contains("Select")) {
                                        } else {
                                          decodeSUbcategory['name'] = value;
                                          // widget.request.fields['category'] =
                                          //     decodeSUbcategory['name'];
                                          for (var _valueData
                                              in decodeSUbcategory['option']) {
                                            if (decodeSUbcategory['name'] ==
                                                _valueData['name'].toString()) {
                                              widget.request
                                                      .fields['category'] =
                                                  _valueData['id'].toString();
                                              request.fields['category'] =
                                                  _valueData['id'].toString();
                                            }

                                            print("_valueData['name'] :- " +
                                                _valueData['name'].toString());
                                          }
                                          setState(() {});
                                        }
                                      },
                                      hint: widget.dict != null
                                          ? isCategoryChnaged
                                              ? Text(decodeSUbcategory['name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : widget.dict.subCategory == null
                                                  ? Text(
                                                      decodeSUbcategory['name'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold))
                                                  : widget.dict.subCategory != 0
                                                      ? Text(_subCat["name"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                      : Text(
                                                          decodeSUbcategory[
                                                              'name'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                          : Text(decodeSUbcategory['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                )),
                            onPressed: () {},
                          ),
                        ))
                    : SizedBox.shrink(),
                Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.decoded.length,
                        //  itemExtent:
                        //    _character == SingingCharacter.generic ? null : 70.0,
                        itemBuilder: (BuildContext context, int index) {
                          return widget.decoded[index]["isHide"]
                              ? SizedBox.shrink()
                              : Container(
                                  height: 70,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: UnicornOutlineButton(
                                      strokeWidth: 1,
                                      radius: 24,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFF3D00),
                                          Color(0xFF9C27B0)
                                        ],
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                      ),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          height: 70,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              iconEnabledColor:
                                                  Color(0xFF9C27B0),
                                              items: _dropDownItem(
                                                  widget.decoded[index]['name'],
                                                  widget.decoded[index]
                                                      ['option']),
                                              onChanged: (value) {
                                                if (value
                                                    .toString()
                                                    .contains("Select")) {
                                                } else {
                                                  widget.decoded[index]
                                                      ['name'] = value;
                                                  widget.decoded[index]
                                                          ["isFilterChnaged"] =
                                                      true;
                                                  widget.request.fields[
                                                      widget.decoded[index]
                                                          ['key_name']] = value;
                                                  request.fields[
                                                      widget.decoded[index]
                                                          ['key_name']] = value;
                                                  filter.add(Filter(
                                                      id: widget.decoded[index]
                                                          ['key_name'],
                                                      value: value));
                                                  setState(() {});
                                                }
                                              },
                                              hint: widget.dict != null
                                                  ? widget.decoded[index][
                                                              'isFilterChnaged'] ??
                                                          false
                                                      ? Text(
                                                          widget.decoded[index]
                                                                  ['name'] ??
                                                              '',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : editArr[index].value !=
                                                              ""
                                                          ? Text(
                                                              editArr[index]
                                                                  .value,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                          : Text(
                                                              widget.decoded[
                                                                          index]
                                                                      [
                                                                      'name'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                  : Text(
                                                      widget.decoded[index]
                                                              ['name'] ??
                                                          '',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                          )),
                                      onPressed: () {},
                                    ),
                                  ));
                        })),
                Container(child: viewSet()),
                widget.dict != null
                    ? widget.fromDrafts
                        ? Padding(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            child: Row(
                              children: [
                                Expanded(flex: 12, child: subscribeBtn())
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                            child: saveBtn())
                    : Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Row(
                          children: [
                            Expanded(flex: 12, child: previewBtn()),
                            Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(flex: 12, child: subscribeBtn())
                          ],
                        ),
                      )
              ],
            ),
          ))),
    );
  }

  addPrice() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: UnicornOutlineButton(
          strokeWidth: 1,
          radius: 24,
          gradient: LinearGradient(
            colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
            end: const Alignment(0.0, -1),
            begin: const Alignment(0.0, 0.6),
          ),
          child: SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Price';
                    }
                    return null;
                  },
                  controller: priceController,
                  style: kTextFeildStyle,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      hintStyle: kSubHeading,
                      hintText: 'Enter Pet Price'))),
          onPressed: () {},
        ));
  }

  saveBtn() {
    return GestureDetector(
      onTap: () {
        widget.request.fields['price'] = priceController.text.toString();
        print("widget.request :-" + widget.request.fields.toString());
        if (_character == SingingCharacter.individual) {
          if (widget.request.fields['gender'] == null) {
            showMessage("Please select gender");
            return;
          } else {
            savePostInfo();
          }
        } else {
          savePostInfo();
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
            end: const Alignment(0.0, -1),
            begin: const Alignment(0.0, 0.6),
          ),
        ),
        child: Text("Save",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }

  viewSet() {
    return Column(
      children: [
        /*Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Price",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
              Expanded(
                  child: Text("\$ " + _value.toInt().toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0))),
            ],
          ),
        ),*/
        addPrice(),
        /*SliderTheme(
          data: SliderThemeData(
              inactiveTrackColor: Color(0xFF9C27B0),
              activeTrackColor: Color(0xFF9C27B0),
              thumbColor: Color(0xFFFF3D00),
              activeTickMarkColor: Color(0xFF9C27B0)),
          child: Slider(
            min: widget.priceMap['minimunPrice'],
            max: widget.priceMap['maximumPrice'],
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ),*/
        /*Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Min.",
                style: TextStyle(fontSize: 16.0),
              )),
              Expanded(
                  child: Text("Max.",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16.0))),
            ],
          ),
        ),*/
      ],
    );
  }

  Future<void> _apiDataUpload(String type) async {
    List<String> keys = List();
    List<String> keysDynamic = List();
    // widget.request.fields['price'] = _value.toInt().toString();
    widget.request.fields['price'] = priceController.text.toString();
    print("widget.request :-" + widget.request.fields.toString());

    for (var key in widget.request.fields.entries) {
      keys.add(key.key.toString());
    }
    for (var keyCheck in widget.decoded) {
      print("keyCheck.request :-" + keyCheck['key_name'].toString());
      if (_character == SingingCharacter.individual) {
        keysDynamic.add(keyCheck['key_name'].toString());
      } else {
        if (keyCheck["key_name"].toString() == "gender") {
        } else {
          keysDynamic.add(keyCheck['key_name'].toString());
        }
      }
    }

    if (keys.contains("category")) {
      bool allDataSelected = false;
      for (int i = 0; i < keysDynamic.length; i++) {
        print("key!!!! " + keysDynamic[i].toString());
        if (keys.contains(keysDynamic[i].toString())) {
          allDataSelected = true;
        } else {
          allDataSelected = false;
          var data = keysDynamic[i].toString();
          showMessage("Please select $data");
          break;
        }
      }
      if (_character == SingingCharacter.individual) {
        widget.request.fields['postType'] = "1";
      } else {
        int totalcount = femalevalue + malevalue;
        if (totalcount == 0) {
          showMessage("Please select number of female or male counts");
          return;
        }
        widget.request.fields['postType'] = "2";
        widget.request.fields['femaleCount'] = femalevalue.toString();
        widget.request.fields['maleCount'] = malevalue.toString();
        widget.request.fields['totalCount'] = totalcount.toString();
      }

      if (allDataSelected) {
        navigateToPay(widget.request, type);

        /* Dialogs.showLoadingDialog(context, _keyLoader);
        var response = await widget.request.send();
        response.stream.transform(utf8.decoder).listen((value) async {
          var data = jsonDecode(await value);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          print("data-------------" + data.toString());
          var error = data['message'];
          if (response.statusCode == 200) {
            print(response.statusCode);
            Navigator.pop(context, "data");
            Navigator.pop(context, "data");
            showMessage("Post uploaded successfully".toString());
          } else {
            showMessage(error.toString());
          }
        });*/

      }
    } else {
      print("Please select Category");
      showMessage("Please select Category");
    }
  }

  subscribeBtn() {
    return GestureDetector(
      onTap: () {
        if (priceController.text.toString().trim().toString() == "") {
          showToast("Please Enter Price");
        } else {
          _apiDataUpload("PostDirect");
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
            end: const Alignment(0.0, -1),
            begin: const Alignment(0.0, 0.6),
          ),
        ),
        child: Text("Post",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  previewBtn() {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          if (priceController.text.toString().trim().toString() == "") {
            showToast("Please Enter Price");
          } else {
            _apiDataUpload("Preview");
          }
        },
        color: Colors.white,
        textColor: Color(0xFF9C27B0),
        child: Text("Preview", style: kButtontyleUnselect),
      ),
    );
  }

  Future<void> listFetch(id) async {
    ApiProvider _apiProvider = ApiProvider();
    var sdecoded = jsonDecode(await _apiProvider.getApiDataRequest(
        ApiProvider.baseUrl + SUBCATEGORIES + "/" + id, SECRETKEY));
    setState(() {
      decodeSUbcategory = sdecoded;
      CategorySelected = true;
    });
    if (widget.dict != null) {
      if (widget.dict.subCategory != null) {
        if (widget.dict.subCategory != 0) {
          for (var val in decodeSUbcategory["option"]) {
            if (val["id"].toString() == widget.dict.subCategory.toString()) {
              widget.request.fields['category'] = _valueData['id'].toString();
              request.fields['category'] = _valueData['id'].toString();
              setState(() {
                _subCat = val;
              });
            }
          }
        }
      } else {}
    }
  }

  void savePostInfo() async {
    print('-----------update pets');
    Dialogs.showLoadingDialog(context, _keyLoader);
    if (_character == SingingCharacter.individual) {
      widget.request.fields['postType'] = "1";
    } else {
      int totalcount = femalevalue + malevalue;
      if (totalcount == 0) {
        showMessage("PLease select number of female or male counts");
        return;
      }
      widget.request.fields['postType'] = "2";
      widget.request.fields['femaleCount'] = femalevalue.toString();
      widget.request.fields['maleCount'] = malevalue.toString();
      widget.request.fields['totalCount'] = totalcount.toString();
    }

    try {
      var response = await widget.request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        var data = jsonDecode(value);
        print("data-------------" + data.toString());
        var error = data['message'];
        if (response.statusCode == 200) {
          print(response.statusCode);
          showMessage("Post updated successfully".toString());
          Navigator.pop(context, "data");
          Navigator.pop(context, "data");
          Navigator.pop(context, "data");
        } else {
          showMessage(error.toString());
        }
      });
    } catch (exception) {
      showMessage(exception.toString());
    }
  }

  void updateCategory(Map value) {
    setState(() {
      print("value :-" + value.toString());
      _valueData = value;
      categoryId = value['id'];
      widget.request.fields['category'] = categoryId;
      request.fields['category'] = categoryId;

      listFetch(categoryId);
    });
  }

  //var uri = Uri.parse(ApiProvider.baseUrl + SAVEDRAFTPOST);

  void saveAsDrafts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    var uri = Uri.parse(ApiProvider.baseUrl + SAVEDRAFTPOST);
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    request.headers.addAll(headers);

    for (int i = 0; i < widget.images.length; i++) {
      final String _fileName = widget.images[i].path;
      Uint8List data =
          (await rootBundle.load(widget.images[i].path)).buffer.asUint8List();
      List<int> _imageData = data.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes('file[]', _imageData, filename: _fileName),
      );
    }
    if (_character == SingingCharacter.individual) {
      request.fields['postType'] = "1";
    } else {
      int totalcount = femalevalue + malevalue;
      if (totalcount == 0) {
        showMessage("PLease select number of female or male counts");
        return;
      }
      request.fields['postType'] = "2";
      request.fields['femaleCount'] = femalevalue.toString();
      request.fields['maleCount'] = malevalue.toString();
      request.fields['totalCount'] = totalcount.toString();
    }

    request.fields['post_id'] = widget.dict.id.toString();
    request.fields['name'] = widget.dict.name.toString();
    request.fields['address'] = widget.dict.address.toString();
    request.fields['latitude'] = widget.dict.latitude;
    request.fields['longitude'] = widget.dict.longitude;
    request.fields['description'] = widget.dict.description;
    request.fields['price'] = priceController.text.toString();
    print(request.fields);
    //1=normal post, 2=feature post
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
        showMessage("Post saved successfully".toString());
        Navigator.pop(context, "load");
        Navigator.pop(context, "data");
      } else {
        showMessage(error.toString());
      }
    });
  }

  Future<void> navigateToPay(request, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customer_id = prefs.getString(STRIPECUSTOMERID).toString();
    print("val11 :- " + customer_id.toString());
    if (customer_id == 'null') {
      showToast("your Stripe account not setup proper");
    } else {
      if (type == "PostDirect") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Subscription(customerId: customer_id, request: request)));
      } else {
        previewPage(customer_id, request, type);
      }
    }
  }

  void priceSet(List decoded) {
    print("decoded :- " + decoded.toString());
    for (var item in decoded) {
      print("item :- " + item['name'].toString());
    }
  }

  void previewPage(String customer_id, requestData, String type) {
    List<String> ids = [];
    List<Filter> filterNew = [];
    List reversedfilter = [];
    reversedfilter = filter.reversed.toList();
    for (int i = 0; i < reversedfilter.length; i++) {
      if (ids.contains(reversedfilter[i].id.toString())) {
      } else {
        filterNew.add(reversedfilter[i]);
      }
      ids.add(reversedfilter[i].id.toString());
    }
    filterNew = filterNew.reversed.toList();

    Breeder breeder =
        Breeder(profileImg: _profile, firstName: _username, lastName: "");
    // price: _value.toInt().toString(),
    var post = PostModelClass(
        address: widget.request.fields['address'],
        name: widget.request.fields['name'],
        price: priceController.text.toString(),
        description: widget.request.fields['description'],
        filter: filterNew,
        visits: 0,
        breeder: breeder);
    print(post);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PetDetailClass(
                  id: null,
                  fromBreeder: true,
                  isPreview: true,
                  post: post,
                  images: widget.images,
                  isIamCreator: true,
                  requestData: requestData,
                  customer_id: customer_id,
                )));
  }
}

List<DropdownMenuItem<String>> _dropDownItem(
    var decodedfirst, List<dynamic> decoded) {
  List<String> ddl = [];
  // ddl.add("Select " + decodedfirst);

  for (int i = 0; i < decoded.length; i++) {
    ddl.add(decoded[i]['name']);
  }
  return ddl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}

List<DropdownMenuItem<String>> _dropDownCategoryItem(
    var decodedfirst, List<dynamic> decoded) {
  List<String> ddl = [];
  ddl.add(decodedfirst);

  for (int i = 0; i < decoded.length; i++) {
    print("Selected Data :-" +
        decoded[i]['name'] +
        "------" +
        decoded[i]['id'].toString());
    var name = decoded[i]['name'].toString();
    var id = decoded[i]['id'].toString();
    ddl.add(name + "-" + id);
  }
  return ddl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}
