import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/models/filter_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FilterClass extends StatefulWidget {
  FilterClass({Key key}) : super(key: key);

  @override
  _FilterClassState createState() => _FilterClassState();
}

class _FilterClassState extends State<FilterClass> {
  double _currentSliderValue = 0;
  FilterBloc _bloc;
  double _locationSliderValue = 0;
  bool _isLoading = false;
  List<FilterModelClass> _filterModel;
  Map<String, String> _dict = {};
  List<Map> listData = List();
  Position position;

  @override
  void initState() {
    super.initState();
    Geolocator.checkPermission().then((value) => {getLocation()});
    _bloc = FilterBloc();
    _bloc.getFilterData();
    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            setState(() {
              _filterModel = event.data;
            });
            break;
          case Status.ERROR:
            _isLoading = false;
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

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xff9C27B0)),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height)
          : Padding(
              padding: EdgeInsets.fromLTRB(20, 80, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addHeading(),
                  addSpace(),
                  addSpace(),
                  showList(),
                  addSpace(),
                  addSpace(),
                  addSpace(),
                  addSpace(),
                  addApplyButton(),
                ],
              ),
            ),
    ));
  }

  addHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Filters",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 25,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Color(0xFF080040))),
        InkWell(
          child: Image.asset(
            "assets/cancel.webp",
            width: 50,
            height: 50,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  addSpace() {
    return SizedBox(
      height: 5,
    );
  }

  addTitle(str) {
    return Text(str,
        style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            color: Color(0xFF080040)));
  }

  addRowTitle(str, FilterModelClass option) {
    String min;
    String max;
    if (option.option[0].name == "Minimum") {
      min = option.option[0].value.toString();
    }
    if (option.option[1].name == "Maximum") {
      max = option.option[1].value.toString();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(str,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Color(0xFF080040))),
        Text("$min" + " - " + "$max",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Color(0xFF080040)))
      ],
    );
  }

  addSlider(FilterModelClass option) {
    print(option.option[0].name);
    print(option.option[1].name);
    print(option.option[2].name);
    double min = 0;
    double max = 0;
    int steps = 0;
    if (option.option[0].name == "Minimum") {
      min = option.option[0].value.toDouble();
    }
    if (option.option[1].name == "Maximum") {
      max = option.option[1].value.toDouble();
    }
    if (option.option[2].name == "Steps") {
      steps = option.option[2].value;
    }

    return Column(
      children: [
        Slider(
          activeColor: Color(0xff9C27B0),
          inactiveColor: Color(0xffF5C849),
          value: _currentSliderValue,
          min: min,
          max: max,
          divisions: steps,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Min.",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Max.",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }

  showList() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _filterModel.length,
        itemBuilder: (context, position) {
          return Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _filterModel[position].name == "Location"
                        ? addRowTitle(
                            _filterModel[position].name, _filterModel[position])
                        : _filterModel[position].name == "Price"
                            ? addRowTitle(_filterModel[position].name,
                                _filterModel[position])
                            : addTitle(_filterModel[position].name),
                    addSpace(),
                    addSpace(),
                    addSpace(),
                    _filterModel[position].name == "Location"
                        ? addRangeSlider(_filterModel[position])
                        : _filterModel[position].name == "Price"
                            ? addSlider(_filterModel[position])
                            : addGridView(
                                _filterModel[position].option, position)
                  ],
                ),
                onTap: () {},
              ));
        });
  }

  addRangeSlider(FilterModelClass option) {
    print(option.option[0].name);
    print(option.option[1].name);
    print(option.option[2].name);
    double min = 0;
    double max = 0;
    int steps = 0;
    if (option.option[0].name == "Minimum") {
      min = option.option[0].value.toDouble();
    }
    if (option.option[1].name == "Maximum") {
      max = option.option[1].value.toDouble();
    }
    if (option.option[2].name == "Steps") {
      steps = option.option[2].value;
    }

    return Column(
      children: [
        Slider(
          activeColor: Color(0xff9C27B0),
          inactiveColor: Color(0xffF5C849),
          value: _locationSliderValue,
          min: min,
          max: max,
          divisions: steps,
          label: _locationSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _locationSliderValue = value;
            });
          },
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option.option[0].value.toString(),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  option.option[1].value.toString(),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ))
      ],
    );
  }

  addGridView(List<Option> options, position) {
    return new GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 3.0,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: new List.generate(options.length, (index) {
        return InkWell(
          child: new Container(
            decoration: BoxDecoration(
              color: _filterModel[position].selectedIndex == index
                  ? Color(0xFF9C27B0)
                  : Color(0xFFF5F3FE),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                options[index].name,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    color: _filterModel[position].selectedIndex == index
                        ? Colors.white
                        : Color(0xFF595959),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _filterModel[position].selectedIndex = index;
              _dict[_filterModel[position].name] =
                  options[index].name.toString();
            });
          },
        );
      }),
    );
  }

  addApplyButton() {
    print(_locationSliderValue);
    print(_currentSliderValue);
    if (_currentSliderValue != 0.0) {
      _dict["price"] = _currentSliderValue.toString();
    }
    if (_locationSliderValue != 0.0) {
      _dict["location"] = _locationSliderValue.toString();
      _dict["latitude"] = position.latitude.toString();
      _dict["longitude"] = position.longitude.toString();
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          // side: BorderSide(color: Color(0xFF9C27B0)),
          onPressed: () {
            Navigator.pop(context, _dict);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BreederslistClass(
            //             showFilters: true, dict: _dict, categoryName: "")));
          },
          color: Color(0xFF9C27B0),
          textColor: Colors.white,
          child: Text("Apply",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
        ));
  }
}
