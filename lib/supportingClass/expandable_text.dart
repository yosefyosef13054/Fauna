import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 90) {
      firstHalf = widget.text.substring(0, 90);
      secondHalf = widget.text.substring(90, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(
              firstHalf,
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  color: Color(0xFF595959),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal),
            )
          : new Column(
              children: <Widget>[
                new Text(
                  flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      color: Color(0xFF595959),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 5,
                ),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        flag ? "Show More" : "Show Less",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
