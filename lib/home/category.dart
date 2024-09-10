import 'package:fauna/blocs/home_bloc.dart';
import 'package:fauna/home/petLists.dart';
import 'package:fauna/models/sub_category.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:flutter/material.dart';

class CategoryClass extends StatefulWidget {
  final String id;
  final String name;
  CategoryClass(this.id, this.name);
  @override
  _CategoryClassState createState() => _CategoryClassState();
}

class _CategoryClassState extends State<CategoryClass> {
  var _selectedItem = 0;
  SubcategoryBloc _subcategoryBloc;
  SearchCategiryBloc _searchCategiryBloc;
  bool _IsSearching = false;

  List<SubCategoryModelClass> _categories;
  var _isLoading = false;
  var id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
    _subcategoryBloc = SubcategoryBloc();
    _searchCategiryBloc = SearchCategiryBloc();
    _subcategoryBloc.getSubCategoryData(id);
    _subcategoryBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _categories = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            _showAlert(context, event.message);
            break;
        }
      });
    });

    _searchCategiryBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            _isLoading = true;
            break;
          case Status.COMPLETED:
            _isLoading = false;
            _categories = event.data;
            break;
          case Status.ERROR:
            _isLoading = false;
            // _showAlert(context, event.message);
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
                  fontWeight: FontWeight.w600,
                ),
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
                      fontWeight: FontWeight.w600,
                    ),
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff080040)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: false,
            title: Text(
              "Breed",
              style: TextStyle(
                  color: Color(0xff080040),
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addTitle(),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                      //controller: _textController,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          disabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                              //fontFamily: Constants.FontRegular,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFBFBFBF),
                              fontSize: 15)),
                      onChanged: onSearchTextChanged,
                      // onChanged: () {

                      // },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  showList(),
                ],
              )),
        ));
  }

  onSearchTextChanged(String text) async {
    _categories.clear();
    _IsSearching = true;
    if (text.isEmpty) {
      _subcategoryBloc.getSubCategoryData(id);
      setState(() {});
      return;
    }
    var dict = {"categoryId": id, "category": text};
    _searchCategiryBloc.search(dict);
    setState(() {});
  }

  addTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          !_isLoading
              ? "All ${widget.name} Breeds (${_categories.length})"
              : "All ${widget.name} Breeds",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BreederslistClass(
                  categoryName: 'All ${widget.name} Breeds',
                  showFilters: true,
                  category: widget.id,
                  isAll: 'showAll',
                ),
              ),
            );
          },
          child: Text(
            "Show All",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 17.5,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  showList() {
    return _isLoading
        ? Center(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color(0xff9C27B0),
                ),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            itemBuilder: (context, position) {
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: InkWell(
                  child: Container(
                      child: Column(
                    children: [
                      (_selectedItem == position)
                          ? UnicornOutlineButton(
                              strokeWidth: 1,
                              radius: 25,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BreederslistClass(
                                      categoryName: _categories[position].name,
                                      showFilters: false,
                                      category:
                                          _categories[position].id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_categories[position].name,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                    )
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width - 60,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_categories[position].name,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        height: 2,
                      ),
                    ],
                  )),
                  onTap: () {
                    setState(() {
                      _selectedItem = position;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BreederslistClass(
                          categoryName: _categories[position].name,
                          showFilters: false,
                          category: _categories[position].id.toString(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
