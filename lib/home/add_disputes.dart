import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/class/toastMessage.dart';
import 'package:fauna/models/complaint_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/material.dart';

class AddDisputesList extends StatefulWidget {
  AddDisputesList({Key key}) : super(key: key);

  @override
  _AddDisputesListState createState() => _AddDisputesListState();
}

class _AddDisputesListState extends State<AddDisputesList> {
  ComplaintBloc _bloc;
  var _isLoading = true;
  List<ComplaintModel> _list = [];
  AddDisputeBloc _addDisputeBloc;
  bool isClick = false;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc = ComplaintBloc();
    _addDisputeBloc = AddDisputeBloc();
    _bloc.getComplaintType();
    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _list = event.data;

            break;
          case Status.ERROR:
            _isLoading = false;
            print(event.message);
            _showAlert(context, event.message);
            break;
        }
      });
    });

    _addDisputeBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            showMessage("Complaint added Successfully");
            isClick = false;
            Navigator.pop(context);
            break;
          case Status.ERROR:
            _isLoading = false;
            _showAlert(context, event.message);
            print(event.message);
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
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () {
                Navigator.pop(context);
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
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(25, 60, 25, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fill the below details for complaint",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset("assets/banner/Dispute.webp"),
              SizedBox(
                height: 25,
              ),
              Text(
                "Enter your complaint as",
                style: kSubHeading,
              ),
              Row(
                children: [
                  new Radio(
                    activeColor: Color(0xff9C27B0),
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text(
                    'User',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  new Radio(
                    activeColor: Color(0xff9C27B0),
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text(
                    'Breeder',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              addDropDown(),
              SizedBox(
                height: 20,
              ),
              addDescription(),
              SizedBox(
                height: 30,
              ),
              Center(child: addSaveButton())
            ],
          ),
        )));
  }

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  var _status = "";
  var type = "";

  addDropDown() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 25,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: new DropdownButtonFormField<String>(
                  iconEnabledColor: Color(0xff9C27B0),
                  decoration: new InputDecoration(
                    //  hintText: "Pending",
                    border: InputBorder.none,
                  ),
                  items: _list.map((val) {
                    var index = _list.indexOf(val);
                    return DropdownMenuItem<String>(
                      value: val.title,
                      child: new Text(
                        val.title,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  hint: Text("Complaint Type",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          color: Color(0xFFFB9700),
                          fontWeight: FontWeight.w600)),
                  onSaved: (String val) {},
                  onChanged: (val) {
                    setState(() {
                      _status = val;
                    });
                  }))),
      onPressed: () {},
    );
  }

  addDescription() {
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
          //height: 50,
          child: TextFormField(
              style: kTextFeildStyle,
              maxLines: 10,
              minLines: 10,
              controller: _controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: kSubHeading,
                  hintText: 'Enter Description'))),
      onPressed: () {},
    );
  }

  addSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
          end: const Alignment(0.0, -1),
          begin: const Alignment(0.0, 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          if (_controller.text.isEmpty) {
            showToast("Enter Description");
          } else {
            setState(() {
              isClick = true;
            });
            if (isClick) {
              add();
            }
          }
        },
        textColor: Colors.white,
        child: isClick
            ? CircularProgressIndicator()
            : Text(
                "Submit",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  add() async {
    var obj =
        await _list.where((food) => food.title.contains(_status)).toList();

    var val = "1";
    if (_radioValue == 0) {
      val = "1";
    } else {
      val = "2";
    }
    var dict = {
      "complainAs": val,
      "type": obj[0].id.toString(),
      "complaint": _controller.text
    };
    print(dict);
    _addDisputeBloc.addDisputes(dict);
  }
}
