import 'package:flutter/material.dart';

class RegisterSuccessClass extends StatefulWidget {
  RegisterSuccessClass({Key key}) : super(key: key);

  @override
  _RegisterSuccessClassState createState() => _RegisterSuccessClassState();
}

class _RegisterSuccessClassState extends State<RegisterSuccessClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/banner/registerSuccesful.webp",
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.width * 0.80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Thank you for your application.\n One of our moderators will review your application and reach out as soon as possible.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: () {
          // print("Tapped");
          // Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
        },
      ),
    );
  }
}
