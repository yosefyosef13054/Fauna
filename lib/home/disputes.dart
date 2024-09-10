import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/add_disputes.dart';
import 'package:fauna/home/favorite.dart';
import 'package:fauna/models/disputes_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Disputes extends KFDrawerContent {
  @override
  _DisputesState createState() => _DisputesState();
}

class _DisputesState extends State<Disputes> {
  int segmentedControlValue = 0;
  DisputesBloc _bloc;
  List<DisputesModel> _disputes;
  var _isLoading = true;
  var _filterStatus = "0";
  var userEnable = false;
  var breederEnable = false;
  var fromBreeder = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DisputesBloc();
    var _dict = {"type": "1", "status": "0"};
    _bloc.getDisputes(_dict);
    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _disputes = [];
            _disputes = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            print(event.message);
            _showAlert(context, event.message);
            break;
        }
      });
    });
    checkBreeder();
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
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
          child: isGuestLogin ? null : addSaveButton(),
        ),
        appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () {
                widget.onMenuPressed();
              },
            ),
            title: Text(
              "Dispute Resolution Form",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        body: isGuestLogin
            ? guestuser(context)
            : SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    breederEnable ? _segmentedControl() : userSet(),
                    space(),
                    space(),
                    addDropDown(),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : disputesList(),
                  ],
                ),
              )));
  }

  space() {
    return SizedBox(
      height: 10,
    );
  }

  var _status = "";
  var statusArr = ["Solved", "Pending", "Archive"];

  addDropDown() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.30,
        height: 60,
        child: new DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xff9C27B0),
            decoration: new InputDecoration(
              //  hintText: "Pending",
              border: InputBorder.none,
            ),
            items: statusArr.map((String val) {
              var index = statusArr.indexOf(val);
              return DropdownMenuItem<String>(
                value: val,
                child: new Text(
                  val,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            hint: Text("Status",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
            onSaved: (String val) {},
            onChanged: (String val) {
              setState(() {
                _status = val;
                print("_status :- " + _status.toString());
                if (segmentedControlValue == 0) {
                  if (_status == "Pending") {
                    var _dict = {"type": "1", "status": "0"};
                    _bloc.getDisputes(_dict);
                  } else {
                    var _dict = {"type": "1", "status": "1"};
                    _bloc.getDisputes(_dict);
                  }
                } else {
                  if (_status == "Pending") {
                    var _dict = {"type": "2", "status": "0"};
                    _bloc.getDisputes(_dict);
                  } else {
                    var _dict = {"type": "2", "status": "1"};
                    _bloc.getDisputes(_dict);
                  }
                }
              });
            }));
  }

  Widget disputesList() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _disputes.length,
        itemBuilder: (context, position) {
          return Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: InkWell(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addID(_disputes[position].id.toString()),
                        space(),
                        adddesp(_disputes[position].complaint.toString()),
                        space(),
                        addAddress(_disputes[position].address.toString()),
                        space(),
                        addPhone(_disputes[position].phone.toString()),
                        space(),
                        addDate(_disputes[position].createdAt.toString()),
                        space(),
                        addStatus(_disputes[position])
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              ));
        });
  }

  addSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDisputesList(),
            ),
          );
        },
        textColor: Colors.white,
        child: Text(
          "Add Disputes",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  addStatus(DisputesModel dispute) {
    var id = dispute.status;
    var name;
    if (id == 0) {
      name = "pending";
    } else if (id == 1) {
      name = "solved";
    } else if (id == 2) {
      name = "archive";
    } else {
      name = "Status";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xff9C27B0).withOpacity(0.4),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                dispute.complainName ?? "",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15.5,
                  color: Color(0xff9C27B0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        // SizedBox(
        //   width: 10,
        // ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: name == "solved"
                ? Color(0xff34AD09).withOpacity(0.4)
                : Color(0xffFB9700).withOpacity(0.4),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              name,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15.5,
                color: name == "solved" ? Color(0xff34AD09) : Color(0xffFB9700),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  addID(str) {
    return Text(
      "ID:" + str,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  adddesp(str) {
    return Text(
      str,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  addAddress(address) {
    return Row(
      children: [
        Image.asset("assets/location.png", width: 15, height: 15),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            address ?? '',
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Color(0xff595959),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  addPhone(str) {
    return Row(
      children: [
        Image.asset("assets/phoneIcon.webp", width: 15, height: 15),
        SizedBox(
          width: 8,
        ),
        Expanded(
            child: Text(
          str,
          style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              color: Color(0xff595959),
              fontWeight: FontWeight.w600),
        ))
      ],
    );
  }

  addDate(str) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Text(
        DateFormat('dd MMM, yyyy').format(DateTime.parse(str)),
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 16,
          color: Color(0xff595959),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _segmentedControl() => Container(
        width: MediaQuery.of(context).size.width,
        height: 52,
        decoration: new BoxDecoration(
            color: Color(0xFFF1F1F5),
            borderRadius: new BorderRadius.circular(40)),
        child: CupertinoSegmentedControl<int>(
          selectedColor: Color(0xFF9C27B0),
          borderColor: Color(0xFFF1F1F5),
          unselectedColor: Color(0xFFF1F1F5),
          children: {
            0: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'User',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
            1: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Breeder',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
          },
          onValueChanged: (int val) {
            setState(() {
              segmentedControlValue = val;
              if (segmentedControlValue == 0) {
                if (_status == "Pending") {
                  var _dict = {"type": "1", "status": "0"};
                  _bloc.getDisputes(_dict);
                } else {
                  var _dict = {"type": "1", "status": "1"};
                  _bloc.getDisputes(_dict);
                }
              } else {
                if (_status == "Pending") {
                  var _dict = {"type": "2", "status": "0"};
                  _bloc.getDisputes(_dict);
                } else {
                  var _dict = {"type": "2", "status": "1"};
                  _bloc.getDisputes(_dict);
                }
              }
            });
          },
          groupValue: segmentedControlValue,
        ),
      );

  Future<void> checkBreeder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var data = prefs.getInt(ISBREEDER);
      print("data---" + data.toString());
      //0 not breeder
      //1 breeder
      //2 pending
      if (data.toString() == '1') {
        fromBreeder = true;
        breederEnable = true;
        userEnable = true;
      } else {
        fromBreeder = false;
        breederEnable = false;
        userEnable = true;
      }
    });
  }

  userSet() {
    return SizedBox.shrink();
  }
}
