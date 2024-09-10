import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/pet_detail.dart';
import 'package:fauna/models/breederDetail_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/sidebar/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BreedersDetailpage extends StatefulWidget {
  String breederid;

  BreedersDetailpage({this.breederid});

  @override
  _BreedersDetailpageState createState() => _BreedersDetailpageState();
}

class _BreedersDetailpageState extends State<BreedersDetailpage> {
  BreederDetailBloc _breederDetailBloc;
  BreederDetailModel _detailModel;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _breederDetailBloc = BreederDetailBloc();
    var data = {"breederId": widget.breederid};
    _breederDetailBloc.getBreederListInfo(data);
    _breederDetailBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _detailModel = event.data;
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
          "Breeder’s Details   ",
          style: TextStyle(
              color: Color(0xff080040),
              fontFamily: "Montserrat",
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffFDEEFF),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xff9C27B0)),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height)
          : SingleChildScrollView(
              child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.40,
                  color: Color(0xffFDEEFF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          DottedBorder(
                              borderType: BorderType.Circle,
                              radius: Radius.circular(25),
                              color: Colors.pink,
                              padding: EdgeInsets.all(10),
                              child: imageCheck(_detailModel)),
                          Positioned.fill(
                            bottom: 0,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset("assets/breedertag.png")),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _detailModel.fullName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Member Since " + _detailModel.memberFrom,
                        style: TextStyle(
                            color: Colors.black38,
                            // fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _detailModel.description ?? "",
                        style: TextStyle(
                            color: Colors.black38,
                            // fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   "assets/location.png",
                            //   width: 15,
                            //   height: 15,
                            // ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(_detailModel.address.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400),
                                maxLines: 2),
                            SizedBox(
                              width: 5,
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      addrating(),
                    ],
                  ),
                ),
                addGridView()
              ],
            )),
    );
  }

  addGridView() {
    return new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white,
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Published Posts",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children:
                      new List.generate(_detailModel.post.length, (index) {
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
                                  imageUrl: _detailModel.post[index].filename,
                                  height: MediaQuery.of(context).size.width /
                                      2 *
                                      0.50,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(_detailModel.post[index].name,
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
                                child: Text(_detailModel.post[index].address,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                    "\$" + _detailModel.post[index].price,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                            // ),
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PetDetailClass(
                                      id: _detailModel.post[index].id
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
              ],
            )));
  }

  imageCheck(var profileImg) {
    if (profileImg.toString() != "null") {
      print("profileImg :-" + profileImg.toString());
      return CircularImage(
        CachedNetworkImageProvider(
          _detailModel.profileImg ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoIrOYja2QSdE0QTb3UDKI_ksIiIGEEY2ERw&usqp=CAU",
        ),
        width: 100,
        height: 100,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  addrating() {
    var rating = 0.0;
    print("Rating - " + _detailModel.rating.toString());
    if (_detailModel.rating.toString() == "null") {
    } else {
      rating = double.parse(_detailModel.rating.toString());
    }
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 18,
      ignoreGestures: true,
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
